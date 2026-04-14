#!/usr/bin/env python3
"""
Generate profile-specific install TSVs from decisions/install.tsv.

Profiles are scoped to *software project development* — web, mobile, backend,
frontend, databases, DevOps, testing, documentation. Business automation,
games, legal/healthcare domains, and niche SDK wrappers are excluded from
minimal/standard; they live in the `full` profile only.

Writes:
  decisions/profiles/minimal.tsv   — ~50 components, ~3k session tokens
  decisions/profiles/standard.tsv  — ~200 components, ~12-15k session tokens (default)

decisions/install.tsv stays as-is = the `full` profile (~2388, ~91k tokens).

Run after install.tsv changes:
    python scripts/curate_profiles.py
"""
from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TSV = ROOT / "decisions" / "install.tsv"
OUT_DIR = ROOT / "decisions" / "profiles"
OUT_DIR.mkdir(parents=True, exist_ok=True)


# ============================================================
# MINIMAL — hand-picked essentials (~50 items, ~3k tokens)
# ============================================================
MINIMAL_SKILLS = {
    # Orchestration runtime
    "project-lifecycle", "continuous-learning-v2", "iterative-retrieval",
    "autonomous-agent-harness", "agent-sort", "dmux-workflows",
    "token-budget-advisor", "context-budget", "verification-loop",
    "eval-harness", "agent-eval",
    # Core languages (top picks only)
    "python-pro", "javascript-pro", "typescript-expert", "rust-pro",
    "golang-pro", "java-pro", "cpp-pro", "csharp-pro",
    # Dev essentials
    "tdd", "test-driven-development", "clean-code", "simplify-code",
    "debugging-strategies", "systematic-debugging", "error-detective",
    "code-review-excellence",
    # Architecture
    "backend-architect", "frontend-developer", "api-design",
    "api-design-patterns", "software-architecture",
    # Security (top)
    "security-auditor", "security-review",
    # Performance
    "performance-engineer", "performance-optimization",
    # Prompting
    "prompt-engineering", "prompt-caching",
    # Documentation
    "api-documentation", "documentation",
}
MINIMAL_AGENTS = {
    "code-reviewer", "debugger", "architect-review", "backend-architect",
    "frontend-developer", "python-pro", "javascript-pro", "typescript-expert",
    "rust-pro", "golang-pro", "security-auditor", "test-automator",
    "performance-engineer", "chief-of-staff", "code-architect",
    "loop-operator", "harness-optimizer",
}
MINIMAL_COMMANDS = {
    "plan", "review", "commit", "pr-create", "pr-review", "debug",
    "refactor", "test", "tdd", "start-project", "ship", "release",
    "fix", "audit-deps", "code-review", "security-scan",
    "go-test", "python-review", "rust-test", "cpp-review",
}


# ============================================================
# STANDARD — scoped to: project dev, web, mobile, docs
# Target: ~200 items, ~12-15k tokens
# ============================================================
# Include only components matching these tight patterns (skills).
# No broad prefix matching — each regex requires exact name anchoring.
STANDARD_SKILLS_INCLUDE = [
    # Languages — core skill names
    r"^(python|javascript|typescript|rust|golang|go|java|cpp|csharp|ruby|swift|kotlin|php|dart|elixir|scala|haskell)-(pro|patterns|idioms|best-practices|testing|testing-patterns|performance-optimization|coding-standards|async-patterns|concurrency-patterns|mastery|systems|advanced|development|packaging)$",
    r"^(go|rust|kotlin)-(idioms|concurrency-patterns|coroutines-expert|coroutines-flows)$",
    r"^(typescript-advanced|javascript-mastery|javascript-testing-patterns|python-best-practices|python-performance-optimization|python-fastapi-development|python-packaging|python-patterns|python-testing|python-testing-patterns|rust-async-patterns|rust-systems|rust-testing|modern-javascript-patterns|bash-scripting|bash-pro|posix-shell-pro|powershell-windows)$",
    # Web frameworks — frontend
    r"^(nextjs-best-practices|nextjs-mastery|nextjs-app-router-patterns|nextjs-turbopack|nextjs-supabase-auth|react-patterns|react-component-performance|react-modernization|react-state-management|react-ui-patterns|react-nextjs-development|react-flow-architect|react-flow-node-ts|angular|angular-migration|angular-ui-patterns|sveltekit|nuxt4-patterns|astro|vue-patterns|tanstack-query-expert|zustand-store-ts|zod-validation-expert)$",
    # Web frameworks — backend
    r"^(fastapi-pro|fastapi-router-py|django-pro|django-patterns|django-tdd|django-security|django-access-review|django-perf-review|django-verification|nestjs-expert|nestjs-patterns|springboot-patterns|springboot-security|springboot-tdd|springboot-verification|laravel-expert|laravel-patterns|laravel-security|laravel-tdd|laravel-verification|hono|trpc-fullstack|websocket-realtime|graphql-architect|graphql-design)$",
    # Node / runtime
    r"^(nodejs-backend-patterns|nodejs-best-practices|bun-development|bun-runtime|dotnet-backend|dotnet-backend-patterns|dotnet-patterns)$",
    # Mobile
    r"^(mobile-developer|mobile-development|ios-developer|android-clean-architecture|android-jetpack-compose-expert|react-native-architecture|flutter-expert|dart-flutter-patterns|expo-dev-client|expo-deployment|expo-api-routes|expo-cicd-workflows|expo-tailwind-setup|expo-ui-jetpack-compose|expo-ui-swift-ui|upgrading-expo|kotlin-coroutines-expert|kotlin-coroutines-flows|kotlin-ktor-patterns|kotlin-exposed-patterns|kotlin-testing|kotlin-patterns|swift-actor-persistence|swift-concurrency-6-2|swift-concurrency-expert|swift-protocol-di-testing|swiftui-expert-skill|swiftui-patterns|swiftui-ui-patterns|swiftui-view-refactor|swiftui-performance-audit|compose-multiplatform-patterns)$",
    # Testing
    r"^(tdd|tdd-guide|tdd-mastery|tdd-workflow|tdd-orchestrator|tdd-workflows-tdd-cycle|tdd-workflows-tdd-red|tdd-workflows-tdd-green|tdd-workflows-tdd-refactor|test-automator|test-driven-development|testing-strategies|testing-patterns|testing-qa|e2e-testing|e2e-testing-patterns|webapp-testing|integration-test|unit-test|unit-testing-test-generate|playwright-pro|playwright-skill|playwright-java)$",
    # Databases
    r"^(postgres-patterns|postgres-optimization|postgresql|postgresql-optimization|database-architect|database-admin|database-design|database-designer|database-schema-designer|database-optimization|database-optimizer|database-migration|database-migrations|database-migrations-migration-observability|database-migrations-sql-migrations|redis-patterns|supabase-automation|neon-postgres|drizzle-orm-expert|prisma-expert|sql-pro|sql-database-assistant|sql-optimization-patterns|nosql-expert|nosql-patterns|dbt-transformation-patterns|event-store-design)$",
    # Cloud & infra
    r"^(aws-cloud-patterns|aws-solution-architect|aws-serverless|aws-security-audit|aws-iam-best-practices|aws-cost-optimizer|cdk-patterns|cloudformation-best-practices|terraform-aws-modules|azure-cloud-architect|azure-functions|gcp-cloud-architect|gcp-cloud-run|kubernetes-architect|kubernetes-operations|kubernetes-deployment|kubernetes-observability-monitor-setup|k8s-manifest-generator|k8s-security-policies|docker-expert|docker-patterns|docker-best-practices|docker-development|terraform-specialist|terraform-patterns|terraform-infrastructure|terraform-skill|helm-chart-builder|helm-chart-scaffolding|cloudflare-workers-expert|vercel-deployment|serverless-patterns)$",
    # DevOps / CI/CD
    r"^(cloud-architect|cloud-devops|hybrid-cloud-architect|multi-cloud-architecture|devops-automation|devops-deploy|devops-troubleshooter|gitops-workflow|cicd-automation-workflow-automate|ci-cd-pipeline-builder|ci-cd-pipelines|gitlab-ci-patterns|github-actions-templates|deployment-engineer|deployment-patterns|deployment-pipeline-design|deployment-procedures|incident-responder|incident-response|observability-engineer|distributed-tracing|prometheus-configuration|grafana-dashboards|observability-monitoring-monitor-setup|observability-monitoring-slo-implement|monorepo-architect|monorepo-management|monorepo-navigator|nx-workspace-patterns|turborepo-caching|bazel-build-optimization)$",
    # Architecture patterns
    r"^(architect|architect-review|architecture|architecture-patterns|architecture-decision-records|api-design|api-design-patterns|api-design-principles|api-design-reviewer|api-documentation|api-documentation-generator|api-documenter|api-endpoint-builder|api-patterns|api-test-suite-builder|microservices-design|microservices-patterns|domain-driven-design|ddd-strategic-design|ddd-tactical-patterns|ddd-context-mapping|hexagonal-architecture|cqrs-implementation|event-sourcing-architect|saga-orchestration|software-architecture|senior-architect|migration-architect|legacy-modernizer|rest-api-patterns|openapi-spec-generation)$",
    # Code quality
    r"^(code-reviewer|code-review|code-review-ai-ai-review|code-review-checklist|code-review-excellence|code-simplifier|simplify-code|clean-code|refactor|code-refactoring-refactor-clean|code-refactoring-tech-debt|code-refactoring-context-restore|debug|debug-hooks|debugging-strategies|debugging-toolkit-smart-debug|systematic-debugging|phase-gated-debugging|error-detective|error-handling-patterns|find-bugs|bug-hunter|dead-code|tech-debt-tracker|codebase-cleanup-refactor-clean|codebase-cleanup-tech-debt|codebase-cleanup-deps-audit|dependency-management-deps-audit|dependency-upgrade|codebase-onboarding|codebase-audit-pre-push)$",
    # Git / workflow
    r"^(git-advanced|git-advanced-workflows|git-workflow|git-pr-workflows-git-workflow|git-pr-workflows-pr-enhance|git-hooks-automation|git-worktree-manager|using-git-worktrees|github|github-workflow-automation|github-issue-creator|gh-review-requests|pr-review-expert|pr-writer|describe-pr|create-pr|iterate-pr|fix-review|commit|create-branch|finishing-a-development-branch|git-pushing|merge)$",
    # Backend patterns (languages already covered above)
    r"^(backend-architect|backend-dev-guidelines|backend-patterns|backend-development-feature-development|backend-security-coder)$",
    # Frontend patterns
    r"^(frontend-developer|frontend-excellence|frontend-design|frontend-dev-guidelines|frontend-patterns|ui-ux-designer|ui-ux-pro-max|design-system|ui-design-system|tailwind-patterns|tailwind-design-system|radix-ui-design-system|shadcn|frontend-security-coder|web-performance-optimization|webapp-testing|a11y-audit|accessibility-wcag|accessibility-compliance-accessibility-audit|ui-a11y|wcag-audit-patterns|web-design-guidelines|progressive-web-app)$",
    # Security — core web/api essentials
    r"^(security-auditor|security-audit|security-review|security-hardening|security-scan|security-pen-testing|api-security-best-practices|api-security-testing|authentication-patterns|broken-authentication|sql-injection-testing|xss-html-injection|file-path-traversal|security-scanning-security-dependencies|security-scanning-security-hardening|security-scanning-security-sast|secrets-management|secrets-vault-manager|env-secrets-manager|threat-modeling-expert|owasp|top-web-vulnerabilities|web-security-testing|frontend-mobile-security-xss-scan|mobile-security-coder)$",
    # Performance
    r"^(performance-engineer|performance-optimization|performance-profiler|performance-profiling|web-performance-optimization|python-performance-optimization|react-component-performance|database-optimization|database-optimizer|postgres-optimization|postgresql-optimization|sql-optimization-patterns|k6-load-testing|load-test)$",
    # Documentation
    r"^(documentation|documentation-generation-doc-generate|api-documentation|api-documentation-generator|api-documenter|technical-writing|changelog-generator|changelog-automation|docs-architect|readme|writer|writing-skills|writing-plans|plan-writing|doc-coauthoring|avoid-ai-writing|tutorial-engineer)$",
    # Prompting / AI core
    r"^(prompt-engineer|prompt-engineer-toolkit|prompt-engineering|prompt-engineering-patterns|prompt-caching|prompt-optimizer|llm-app-patterns|llm-integration|llm-evaluation|llm-structured-output|llm-prompt-optimizer|llm-cost-optimizer|ml-engineer|ai-engineer|rag-engineer|rag-architect|rag-implementation|langchain-architecture|langgraph|pydantic-ai)$",
    # Orchestration (already in minimal but re-include for safety)
    r"^(project-lifecycle|continuous-learning-v2|iterative-retrieval|autonomous-agent-harness|agent-sort|dmux-workflows|token-budget-advisor|context-budget|verification-loop|eval-harness|agent-eval|context-engine|context-agent|context-optimization|context-window-management|context-degradation|context-compression|context-fundamentals|context-driven-development)$",
    # Build tooling
    r"^(monorepo-architect|monorepo-management|monorepo-navigator|nx-workspace-patterns|turborepo-caching|bazel-build-optimization|devcontainer-setup|dockerfile|docker-expert)$",
    # Diagrams & visualization (dev docs)
    r"^(mermaid-expert|c4-architecture-c4-architecture|c4-context|c4-container|generate-erd|diagram|create-chart|json-canvas|wiki-vitepress)$",
]

STANDARD_AGENTS_INCLUDE = [
    r"^(backend-architect|frontend-developer|architect|architect-review|code-reviewer|test-automator|debugger|security-auditor|python-pro|javascript-pro|typescript-expert|rust-pro|golang-pro|java-pro|cpp-pro|csharp-pro|ruby-pro|php-pro|swift-pro|kotlin-pro|elixir-pro|haskell-pro|scala-pro|bash-pro|api-designer|graphql-architect|database-architect|database-admin|database-optimizer|ml-engineer|mlops-engineer|ai-engineer|rag-engineer|data-engineer|data-scientist|devops-automation|devops-deploy|devops-troubleshooter|cloud-architect|kubernetes-architect|terraform-specialist|performance-engineer|incident-responder|tdd-orchestrator|legacy-modernizer|docs-architect|api-documenter|prompt-engineer|fastapi-pro|django-pro|nextjs-best-practices|react-patterns|vue-patterns|flutter-expert|chief-of-staff|code-architect|loop-operator|harness-optimizer|deployment-engineer|database-designer|network-engineer|senior-backend|senior-frontend|senior-fullstack|senior-devops|senior-security|senior-data-engineer|senior-ml-engineer|senior-architect|senior-qa|senior-pm|mobile-developer|ios-developer)$",
]

STANDARD_COMMANDS_INCLUDE = [
    r"^(plan|review|code-review|pr-review|pr-create|pr|commit|ship|release|deploy|debug|test|tdd|refactor|fix|fix-issue|fix-issues|fix-vulnerability|start-project|build|ci-pipeline|cleanup|clean|doc-gen|docs|docs-architect|find-dead-code|generate-docs|generate-tests|generate-erd|diagram|integration-test|snapshot-test|unit-test|test-coverage|test-fix|e2e|go-test|go-build|go-review|python-review|rust-build|rust-test|rust-review|kotlin-build|kotlin-test|kotlin-review|cpp-build|cpp-review|cpp-test|flutter-build|flutter-test|flutter-review|audit-deps|audit|security-check|security-scan|dependency-audit|update-deps|migrate|db-migrate|rollback|benchmark|profile|optimize|analyze-ci-failure|explain-plan|review-pr|describe-pr|create-pr|code-migrate|dead-code|focused-fix|generate-openapi|generate-report|load-test|migrate-file|monitor|onboard|optimize-dockerfile|optimize-query|pipeline|plan-apply|refactor-clean|remove-dead-code|rename|run-audit|run-load-test|secrets-scan|tech-debt|test-endpoint|update-docs|update-readme|design-api|design-schema|design-review|create-component|create-contract|create-migration|create-module|api-docs|write-adr|adr|evolve|harness-audit|skill-health|memory-bank|explore|track-management)$",
]


def load_tsv(path: Path) -> list[tuple[str, str, str]]:
    rows = []
    with path.open(encoding="utf-8") as f:
        for line in f:
            line = line.rstrip("\r\n")
            if not line or line.startswith("#"):
                continue
            parts = line.split("\t")
            if len(parts) == 3:
                rows.append(tuple(parts))
    return rows


def write_tsv(path: Path, rows: list[tuple[str, str, str]], header: str) -> None:
    by_type = {"skill": 0, "agent": 0, "command": 0}
    for ctype, _, _ in rows:
        by_type[ctype] = by_type.get(ctype, 0) + 1
    with path.open("w", encoding="utf-8", newline="\n") as f:
        f.write("# type\tid\tpath\n")
        f.write(f"# {header}\n")
        f.write(f"# Total: {len(rows)} components\n")
        f.write(f"# By type: {by_type}\n")
        f.write("# Generated by scripts/curate_profiles.py -- do not edit by hand\n")
        for row in rows:
            f.write("\t".join(row) + "\n")


def _compile(patterns):
    return [re.compile(p, re.IGNORECASE) for p in patterns]


def curate_minimal(all_rows):
    result = []
    seen = set()
    for ctype, cid, cpath in all_rows:
        if (ctype, cid) in seen:
            continue
        if ctype == "skill" and cid in MINIMAL_SKILLS:
            result.append((ctype, cid, cpath))
            seen.add((ctype, cid))
        elif ctype == "agent" and cid in MINIMAL_AGENTS:
            result.append((ctype, cid, cpath))
            seen.add((ctype, cid))
        elif ctype == "command" and cid in MINIMAL_COMMANDS:
            result.append((ctype, cid, cpath))
            seen.add((ctype, cid))
    return result


def curate_standard(all_rows):
    skill_pats = _compile(STANDARD_SKILLS_INCLUDE)
    agent_pats = _compile(STANDARD_AGENTS_INCLUDE)
    command_pats = _compile(STANDARD_COMMANDS_INCLUDE)
    minimal_keys = {(ctype, cid) for ctype, cid, _ in curate_minimal(all_rows)}

    result = []
    seen = set()
    for ctype, cid, cpath in all_rows:
        key = (ctype, cid)
        if key in seen:
            continue
        if key in minimal_keys:
            result.append((ctype, cid, cpath))
            seen.add(key)
            continue
        pats = None
        if ctype == "skill":
            pats = skill_pats
        elif ctype == "agent":
            pats = agent_pats
        elif ctype == "command":
            pats = command_pats
        if pats and any(p.search(cid) for p in pats):
            result.append((ctype, cid, cpath))
            seen.add(key)
    return result


def main():
    all_rows = load_tsv(TSV)
    print(f"Source: {TSV.name} ({len(all_rows)} components)")

    minimal = curate_minimal(all_rows)
    write_tsv(OUT_DIR / "minimal.tsv", minimal, "Profile: minimal (hand-picked essentials)")
    print(f"  minimal.tsv:  {len(minimal)} components")

    standard = curate_standard(all_rows)
    write_tsv(OUT_DIR / "standard.tsv", standard, "Profile: standard (software project dev scope)")
    print(f"  standard.tsv: {len(standard)} components")

    # full.tsv is just a copy of install.tsv in the profiles/ folder,
    # so the installer can always read decisions/profiles/<name>.tsv
    write_tsv(OUT_DIR / "full.tsv", all_rows, "Profile: full (entire catalog — ~91k session tokens)")
    print(f"  full.tsv:     {len(all_rows)} components")

    def by_type(rows):
        counts = {"skill": 0, "agent": 0, "command": 0}
        for ctype, _, _ in rows:
            counts[ctype] = counts.get(ctype, 0) + 1
        return counts

    print(f"  minimal  by type: {by_type(minimal)}")
    print(f"  standard by type: {by_type(standard)}")
    est_skill_tokens = 50  # rough average per skill frontmatter
    print(f"  standard estimated skill tokens: ~{by_type(standard)['skill'] * est_skill_tokens}")


if __name__ == "__main__":
    main()
