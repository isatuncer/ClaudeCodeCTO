# Source Code Security Chain

> **Compliance References:**
> - Based on: SLSA v1.0, NIST SSDF
> - Spec: SLSA Level 1-3
> - Controls: Supply chain integrity
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Principle: Every step from code to artifact is verifiable, signed, and traceable.

---

## 1. Signed Commits (GPG)

### Why?
Anyone can put someone else's name in a commit message. With GPG signing, "this commit was ACTUALLY made by this person" is proven.

### Requirements
| Situation | GPG Required? |
|-----------|--------------|
| main/develop branch | **YES** |
| feature branch | Recommended |
| Hotfix | YES |
| CI/CD bot commit | With bot GPG key |

### Verification
```bash
# Is the commit signed?
git log --show-signature -1
# gpg: Signature made ... using RSA key
# gpg: Good signature from "Developer <dev@example.com>"
```

---

## 2. Branch Protection

### main Branch
| Rule | Value |
|------|-------|
| Direct push | **PROHIBITED** |
| PR required | YES |
| Min reviewers | 2 |
| Signed commit | YES |
| CI pass required | YES (lint + test + build + security scan) |
| Dismiss stale reviews | YES (new commit -> previous approval invalidated) |
| Admin bypass | NO (admin also follows the rules) |

### develop Branch
| Rule | Value |
|------|-------|
| Direct push | PROHIBITED |
| PR required | YES |
| Min reviewers | 1 |
| CI pass required | YES |

---

## 3. SBOM (Software Bill of Materials)

### Why?
Answer the question "What's in this software?" with a complete list of all dependencies.
CRITICAL for supply chain attack detection.

### Content
```json
{
  "bomFormat": "CycloneDX",
  "specVersion": "1.5",
  "components": [
    {
      "name": "express",
      "version": "4.19.2",
      "type": "library",
      "licenses": [{ "id": "MIT" }],
      "hashes": [{ "alg": "SHA-256", "content": "abc123..." }]
    }
  ]
}
```

### Generation
```bash
# Node.js
npx @cyclonedx/cyclonedx-npm --output-file sbom.json

# Python
pip install cyclonedx-bom
cyclonedx-py -o sbom.json

# Go
cyclonedx-gomod -output sbom.json
```

### In CI/CD
- SBOM is automatically generated with every release
- SBOM is stored as an artifact
- Scanned against known vulnerability databases

---

## 4. Supply Chain Security

### Controls
| Control | Implementation |
|---------|---------------|
| **Dependency pinning** | Exact version (use = not ^) |
| **Lock file commit** | package-lock.json / yarn.lock / pnpm-lock.yaml MUST be committed |
| **Dependency review** | Reviewer approval before adding new package |
| **Vulnerability scan** | Snyk/npm audit in every CI run |
| **License check** | GPL/AGPL -> PROHIBITED |
| **Typosquatting** | Verify package name is correct (express vs exprss) |
| **SBOM** | Generate with every release |
| **Reproducible builds** | Same source -> same binary (hashes match) |

### Prohibited Actions
- [ ] `npm install [package]` -> FIRST check license + vulnerability
- [ ] Do not use unknown registries (only npm/pypi/crates.io)
- [ ] Be cautious of packages with pre/post install scripts

---

## 5. Artifact Signing

### Docker Image Signing
```bash
# Sign image with Cosign
cosign sign --key cosign.key [registry]/[image]:[tag]

# Verify
cosign verify --key cosign.pub [registry]/[image]:[tag]
```

### Deployment Chain
```
Source Code (signed commit)
  -> Build (CI/CD, deterministic)
    -> Test (all tests passed)
      -> Scan (SAST + SCA + container scan)
        -> Sign (sign artifact)
          -> Deploy (only signed artifacts are deployed)
```

---

## 6. Git Hygiene

| Rule | Description |
|------|------------|
| `.gitignore` up to date | Secrets, dependencies, build files NEVER committed |
| Large files | Files > 5MB use git LFS |
| Secrets NEVER | Secret scan with pre-commit hook |
| History rewrite | PROHIBITED on main (no force push) |
| Merge strategy | Squash merge (feature), merge commit (release) |
| Branch cleanup | Auto-delete after merge |
| Tags | Signed tag for every release (vX.Y.Z) |

---

## Related Documents
- `governance/standards/BRANCHING_STRATEGY.md`
- `governance/standards/GIT_HOOKS.md`
- `governance/standards/SHIFT_LEFT_SECURITY.md`
- `governance/standards/DEPENDENCY_MANAGEMENT.md`
