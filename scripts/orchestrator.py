#!/usr/bin/env python3
"""
CloaudeCodeCTO Orchestrator — Stage 4.5

Binds the 8-phase project lifecycle to actual selected components.

Reads:
  - templates/lifecycle.json     (phase template, preferred agents/skills)
  - decisions/selected.json      (curated components)

For each phase, resolves preferred agent/skill names to real components.
If a preferred item isn't in selected.json, searches for the best
alternative by domain + description keyword match.

Outputs:
  - decisions/lifecycle-bindings.json    final phase → component mapping
  - templates/start-project.md           meta-command file
  - templates/project-lifecycle/SKILL.md orchestrator skill
"""

from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parent.parent
TEMPLATES = ROOT / "templates"
DECISIONS = ROOT / "decisions"
LIFECYCLE = TEMPLATES / "lifecycle.json"
SELECTED = DECISIONS / "selected.json"
BINDINGS = DECISIONS / "lifecycle-bindings.json"
START_CMD = TEMPLATES / "start-project.md"
LIFECYCLE_SKILL_DIR = TEMPLATES / "project-lifecycle"


def find_exact(selected: dict[str, list[dict[str, Any]]], comp_type: str, name: str) -> dict[str, Any] | None:
    """Find a component by exact id match."""
    for c in selected.get(comp_type, []):
        if c["id"] == name:
            return c
    return None


def find_by_keywords(
    selected_of_type: list[dict[str, Any]],
    keywords: list[str],
    domain_hint: str | None = None,
    limit: int = 1,
) -> list[dict[str, Any]]:
    """Fuzzy match: score each candidate by keyword hits, prefer same domain."""
    scored: list[tuple[float, dict[str, Any]]] = []
    for c in selected_of_type:
        text = (c["id"] + " " + (c.get("description") or "")).lower()
        hits = sum(1 for kw in keywords if kw.lower() in text)
        if hits == 0:
            continue
        score = hits + (c.get("combined_score", 0) / 100)
        if domain_hint and c.get("domain") == domain_hint:
            score += 2
        scored.append((score, c))
    scored.sort(key=lambda x: -x[0])
    return [c for _, c in scored[:limit]]


def resolve_phase(
    phase: dict[str, Any],
    selected_by_type: dict[str, list[dict[str, Any]]],
) -> dict[str, Any]:
    """Resolve a single phase's preferred agents/skills to real components."""
    resolved_agents: list[dict[str, Any]] = []
    resolved_skills: list[dict[str, Any]] = []
    unresolved: list[str] = []

    # Agents
    for agent_name in phase.get("preferred_agents", []):
        found = find_exact(selected_by_type, "agent", agent_name)
        if found:
            resolved_agents.append({
                "name": agent_name,
                "id": found["id"],
                "source": found["source_repo"],
                "score": found["combined_score"],
                "resolved": "exact",
            })
        else:
            # Fallback: keyword search in agents
            alternatives = find_by_keywords(
                selected_by_type.get("agent", []),
                keywords=agent_name.split("-"),
                domain_hint=phase.get("id"),
                limit=1,
            )
            if alternatives:
                alt = alternatives[0]
                resolved_agents.append({
                    "name": agent_name,
                    "id": alt["id"],
                    "source": alt["source_repo"],
                    "score": alt["combined_score"],
                    "resolved": "alternative",
                })
            else:
                unresolved.append(f"agent:{agent_name}")

    # Skills
    for skill_name in phase.get("preferred_skills", []):
        found = find_exact(selected_by_type, "skill", skill_name)
        if found:
            resolved_skills.append({
                "name": skill_name,
                "id": found["id"],
                "source": found["source_repo"],
                "score": found["combined_score"],
                "resolved": "exact",
            })
        else:
            alternatives = find_by_keywords(
                selected_by_type.get("skill", []),
                keywords=skill_name.split("-"),
                domain_hint=phase.get("id"),
                limit=1,
            )
            if alternatives:
                alt = alternatives[0]
                resolved_skills.append({
                    "name": skill_name,
                    "id": alt["id"],
                    "source": alt["source_repo"],
                    "score": alt["combined_score"],
                    "resolved": "alternative",
                })
            else:
                unresolved.append(f"skill:{skill_name}")

    return {
        "id": phase["id"],
        "order": phase["order"],
        "name": phase["name"],
        "tagline": phase.get("tagline", ""),
        "entry_criteria": phase.get("entry_criteria", ""),
        "exit_criteria": phase.get("exit_criteria", ""),
        "outputs": phase.get("outputs", []),
        "typical_duration": phase.get("typical_duration", ""),
        "questions_to_user": phase.get("questions_to_user", []),
        "agents": resolved_agents,
        "skills": resolved_skills,
        "unresolved": unresolved,
    }


def render_start_project_md(bindings: dict[str, Any]) -> str:
    """Generate the /start-project meta-command markdown."""
    lines = [
        "---",
        "name: start-project",
        "description: Start a new project and guide the user through all 8 phases from discovery to maintenance, choosing the right agents and skills at each step.",
        "---",
        "",
        "# /start-project — Proje Yaşam Döngüsü Orkestratörü",
        "",
        "Kullanıcı bir proje başlatmak istediğinde bu komutu çalıştırır. Claude Code, kullanıcıyı 8 faz boyunca yönlendirir, her fazda uygun agent'ları ve skill'leri çağırır, fazlar arası handoff yapar ve ilerlemeyi takip eder.",
        "",
        "## Başlangıç Protokolü",
        "",
        "1. Kullanıcıya proje türünü sor: `web app | mobile app | CLI | library | SaaS | microservice | data pipeline`",
        "2. `decisions/project-state.json` dosyasını kontrol et — var olan bir state varsa kaldığı yerden devam et",
        "3. Yoksa yeni state oluştur ve **Phase 1 (Discovery)** ile başla",
        "4. Her faz başında: fazı tanıt, kullanıcıya soracağın soruları göster, onay bekle",
        "5. Faz içinde uygun agent'ları otomatik çağır (aşağıdaki haritaya göre)",
        "6. Faz bittiğinde: çıktıları özetle, `project-state.json`'ı güncelle, sonraki faza geçmeyi sor",
        "",
        "## Faz → Agent / Skill Haritası",
        "",
    ]

    for phase in bindings["phases"]:
        lines.append(f"### Phase {phase['order']} — {phase['name']} _\"{phase['tagline']}\"_")
        lines.append("")
        lines.append(f"**Giriş kriteri:** {phase['entry_criteria']}")
        lines.append(f"**Çıkış kriteri:** {phase['exit_criteria']}")
        lines.append(f"**Tipik süre:** {phase['typical_duration']}")
        lines.append("")
        if phase["agents"]:
            lines.append("**Agent'lar (öncelik sırasıyla):**")
            for a in phase["agents"]:
                marker = "OK" if a["resolved"] == "exact" else "ALT"
                lines.append(f"- `{a['id']}` ({a['source']}, skor {a['score']}) [{marker}]")
            lines.append("")
        if phase["skills"]:
            lines.append("**Skill'ler:**")
            for s in phase["skills"]:
                marker = "OK" if s["resolved"] == "exact" else "ALT"
                lines.append(f"- `{s['id']}` ({s['source']}, skor {s['score']}) [{marker}]")
            lines.append("")
        if phase["questions_to_user"]:
            lines.append("**Kullanıcıya sorulacaklar:**")
            for q in phase["questions_to_user"]:
                lines.append(f"- {q}")
            lines.append("")
        if phase["outputs"]:
            lines.append(f"**Çıktılar:** {', '.join(phase['outputs'])}")
            lines.append("")
        lines.append("---")
        lines.append("")

    lines.extend([
        "## Handoff Kuralları",
        "",
        "Her faz bittiğinde, sonraki faza aşağıdakileri aktar:",
        "",
    ])
    for h in bindings.get("handoffs", []):
        lines.append(f"- `{h['from']}` → `{h['to']}`: **{h['payload']}**")
    lines.extend([
        "",
        "## State Takibi",
        "",
        "`decisions/project-state.json` şeması:",
        "```json",
        "{",
        "  \"project_name\": \"...\",",
        "  \"project_type\": \"web app|mobile|cli|lib|saas|...\",",
        "  \"current_phase\": \"discovery|planning|...|maintain\",",
        "  \"completed_phases\": [\"discovery\"],",
        "  \"phase_outputs\": {",
        "    \"discovery\": [\"docs/PRD.md\", \"docs/user-stories.md\"]",
        "  },",
        "  \"started_at\": \"ISO timestamp\",",
        "  \"last_updated\": \"ISO timestamp\"",
        "}",
        "```",
        "",
        "## Önemli Notlar",
        "",
        "- **Agent seçiminde tereddüt etme** — bu dosyada her faz için belirtilen agent'ları sırayla dene",
        "- **Kullanıcıya her fazda onay sor** — otomatik bir sonraki faza atlama",
        "- **State'i her değişiklikten sonra kaydet** — session kesilse bile kaldığı yerden devam edilebilsin",
        "- **Alternatif işaretli [ALT] olanlar** — tercih edilen tam eşleşme değil, en yakın seçim",
    ])

    return "\n".join(lines) + "\n"


def render_lifecycle_skill_md(bindings: dict[str, Any]) -> str:
    """Generate the project-lifecycle SKILL.md."""
    phase_summary = ", ".join(f"{p['order']}.{p['name']}" for p in bindings["phases"])
    return f"""---
name: project-lifecycle
description: Claude Code'un projeyi baştan sona yönetmesini sağlayan 8 fazlı yaşam döngüsü orkestratörü. Kullanıcıyı Discovery → Planning → Design → Build → Test → Document → Ship → Maintain yolculuğunda yönlendirir, her fazda uygun agent'ları ve skill'leri çağırır.
trigger: when user wants to start a new project from scratch, or wants guidance through a full project lifecycle
---

# Project Lifecycle Orchestrator

## Amaç

Bu skill Claude Code'a bir projeyi **baştan sona** yönetme yetkisi verir. Kullanıcı "yeni proje başlat" veya "bu projeyi sıfırdan kurgulayalım" dediğinde otomatik tetiklenir.

## Ne Zaman Aktif?

- Kullanıcı `/start-project` komutunu çalıştırdığında
- Kullanıcı "yeni proje" veya "proje başlat" dediğinde
- Mevcut proje bağlamı yoksa ve kullanıcı planlama/mimari isteğinde bulunduğunda

## 8 Faz

{phase_summary}

Her faz için:
1. Giriş kriterini kontrol et
2. Kullanıcıya fazın sorularını sor
3. Uygun agent'ları (bu faza özel atanmış) çağır
4. Skill'leri kullan, çıktı dosyalarını üret
5. Çıkış kriterini doğrula
6. `project-state.json`'ı güncelle
7. Sonraki faza geçmeyi kullanıcıya sor

## Uygulama

Detaylı faz-agent-skill haritası için `start-project.md` dosyasına bakın.

## State

Proje durumu `decisions/project-state.json` dosyasında tutulur. Bu dosya sayesinde oturum kesilse bile proje kaldığı yerden devam eder.

## Tetikleme Örnekleri

- "Bir SaaS projesi başlatmak istiyorum"
- "Yeni bir CLI uygulaması kuralım"
- "Bu projeyi baştan planlayalım"
- "/start-project"
- "Full stack web app yapacağız, nereden başlayalım?"
"""


def main() -> int:
    if not LIFECYCLE.exists():
        print(f"ERROR: {LIFECYCLE} not found", file=sys.stderr)
        return 1
    if not SELECTED.exists():
        print(f"ERROR: {SELECTED} not found. Run curator.py first.", file=sys.stderr)
        return 1

    lifecycle = json.loads(LIFECYCLE.read_text(encoding="utf-8"))
    selected = json.loads(SELECTED.read_text(encoding="utf-8"))

    # Group selected by type
    selected_by_type: dict[str, list[dict[str, Any]]] = {"skill": [], "agent": [], "command": []}
    for c in selected["components"]:
        selected_by_type[c["type"]].append(c)

    print(f"Lifecycle has {len(lifecycle['phases'])} phases")
    print(f"Selected pool: {sum(len(v) for v in selected_by_type.values())} components")
    print()

    # Resolve each phase
    resolved_phases = []
    for phase in lifecycle["phases"]:
        rp = resolve_phase(phase, selected_by_type)
        resolved_phases.append(rp)

        exact_agents = sum(1 for a in rp["agents"] if a["resolved"] == "exact")
        alt_agents = sum(1 for a in rp["agents"] if a["resolved"] == "alternative")
        exact_skills = sum(1 for s in rp["skills"] if s["resolved"] == "exact")
        alt_skills = sum(1 for s in rp["skills"] if s["resolved"] == "alternative")

        print(f"  Phase {rp['order']}: {rp['name']:<12}")
        print(f"    Agents: {exact_agents} exact + {alt_agents} alt  (pref {len(phase['preferred_agents'])})")
        print(f"    Skills: {exact_skills} exact + {alt_skills} alt  (pref {len(phase['preferred_skills'])})")
        if rp["unresolved"]:
            print(f"    Unresolved: {', '.join(rp['unresolved'])}")

    bindings = {
        "version": lifecycle["version"],
        "phases": resolved_phases,
        "handoffs": lifecycle.get("handoffs", []),
    }

    BINDINGS.write_text(
        json.dumps(bindings, indent=2, ensure_ascii=False, default=str),
        encoding="utf-8",
    )
    print()
    print(f"  -> {BINDINGS.relative_to(ROOT)}")

    # Render meta-command
    START_CMD.write_text(render_start_project_md(bindings), encoding="utf-8")
    print(f"  -> {START_CMD.relative_to(ROOT)}")

    # Render skill
    LIFECYCLE_SKILL_DIR.mkdir(parents=True, exist_ok=True)
    (LIFECYCLE_SKILL_DIR / "SKILL.md").write_text(render_lifecycle_skill_md(bindings), encoding="utf-8")
    print(f"  -> {(LIFECYCLE_SKILL_DIR / 'SKILL.md').relative_to(ROOT)}")

    print()
    print("=" * 60)
    print("  ORCHESTRATE COMPLETE")
    print("=" * 60)

    return 0


if __name__ == "__main__":
    sys.exit(main())
