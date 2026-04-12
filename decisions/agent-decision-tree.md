# Agent Decision Tree

Her kullanıcı isteğinde Claude Code'un hangi agent'ı çağıracağı bu tabloya göre seçilmelidir. Her tetikleyici için agent'lar skor sırasıyla listelenir.

**Toplam agent:** 307
**Overlap eşiği (Jaccard >= 0.4):** 22 çift

## data / ML / AI

| Öncelik | Agent | Skor | Kaynak | Açıklama |
|---------|-------|------|--------|----------|
| 1 | `devops-engineer` | 91 | voltagent-subagents | Use this agent when building or optimizing infrastructure automation, CI/CD pipe |
| 2 | `ml-engineer` | 91 | voltagent-subagents | Use this agent when building production ML systems requiring model training pipe |
| 3 | `review-agent` | 90 | continuous-claude-v3 | Review implementation by comparing plan (intent) vs Braintrust session (reality) |
| 4 | `cs-demand-gen-specialist` | 89 | alirezarezvani-claud | Demand generation and customer acquisition specialist for lead generation, conve |
| 5 | `devops-incident-responder` | 89 | voltagent-subagents | Use when actively responding to production incidents, diagnosing critical servic |
| 6 | `dart-build-resolver` | 87 | everything-claude-co | Dart/Flutter build, analysis, and dependency error resolution specialist. Fixes  |
| 7 | `kotlin-build-resolver` | 87 | everything-claude-co | Kotlin/Gradle build, compilation, and dependency error resolution specialist. Fi |
| 8 | `build-error-resolver` | 87 | everything-claude-co | Build and TypeScript error resolution specialist. Use PROACTIVELY when build fai |

## deploy / devops

| Öncelik | Agent | Skor | Kaynak | Açıklama |
|---------|-------|------|--------|----------|
| 1 | `deployment-engineer` | 91 | voltagent-subagents | Use this agent when designing, building, or optimizing CI/CD pipelines and deplo |
| 2 | `devops-engineer` | 91 | voltagent-subagents | Use this agent when building or optimizing infrastructure automation, CI/CD pipe |
| 3 | `healthcare-reviewer` | 91 | everything-claude-co | Reviews healthcare application code for clinical safety, CDSS accuracy, PHI comp |
| 4 | `ml-engineer` | 91 | voltagent-subagents | Use this agent when building production ML systems requiring model training pipe |
| 5 | `cs-demand-gen-specialist` | 89 | alirezarezvani-claud | Demand generation and customer acquisition specialist for lead generation, conve |
| 6 | `devops-incident-responder` | 89 | voltagent-subagents | Use when actively responding to production incidents, diagnosing critical servic |
| 7 | `vue-specialist` | 88 | rohitg00-toolkit | Vue 3 development with Composition API, Pinia state management, Nuxt 3, and VueU |
| 8 | `dart-build-resolver` | 87 | everything-claude-co | Dart/Flutter build, analysis, and dependency error resolution specialist. Fixes  |

## design / architect

| Öncelik | Agent | Skor | Kaynak | Açıklama |
|---------|-------|------|--------|----------|
| 1 | `architect` | 92 | continuous-claude-v3 | Feature planning, design documentation, AND integration planning |
| 2 | `deployment-engineer` | 91 | voltagent-subagents | Use this agent when designing, building, or optimizing CI/CD pipelines and deplo |
| 3 | `devops-engineer` | 91 | voltagent-subagents | Use this agent when building or optimizing infrastructure automation, CI/CD pipe |
| 4 | `ml-engineer` | 91 | voltagent-subagents | Use this agent when building production ML systems requiring model training pipe |
| 5 | `plan-reviewer` | 90 | continuous-claude-v3 | Reviews feature plans (from architect) and change plans (from phoenix) |
| 6 | `kotlin-reviewer` | 88 | everything-claude-co | Kotlin and Android/KMP code reviewer. Reviews Kotlin code for idiomatic patterns |
| 7 | `angular-architect` | 87 | voltagent-subagents | Use when architecting enterprise Angular 15+ applications with complex state man |
| 8 | `api-designer` | 87 | voltagent-subagents | Use this agent when designing new APIs, creating API specifications, or refactor |

## document

| Öncelik | Agent | Skor | Kaynak | Açıklama |
|---------|-------|------|--------|----------|
| 1 | `architect` | 92 | continuous-claude-v3 | Feature planning, design documentation, AND integration planning |
| 2 | `api-designer` | 87 | voltagent-subagents | Use this agent when designing new APIs, creating API specifications, or refactor |
| 3 | `doc-updater` | 87 | everything-claude-co | Documentation and codemap specialist. Use PROACTIVELY for updating codemaps and  |
| 4 | `tdd-guide` | 87 | everything-claude-co | Test-Driven Development specialist enforcing write-tests-first methodology. Use  |
| 5 | `technical-writer` | 87 | voltagent-subagents | Use this agent when you need to create, improve, or maintain technical documenta |
| 6 | `opensource-packager` | 83 | everything-claude-co | Generate complete open-source packaging for a sanitized project. Produces CLAUDE |
| 7 | `docs-lookup` | 82 | everything-claude-co | When the user asks how to use a library, framework, or API or needs up-to-date c |
| 8 | `scribe` | 82 | continuous-claude-v3 | Documentation, handoffs, session summaries, and ledger management |

## fix bug / debug

| Öncelik | Agent | Skor | Kaynak | Açıklama |
|---------|-------|------|--------|----------|
| 1 | `devops-incident-responder` | 89 | voltagent-subagents | Use when actively responding to production incidents, diagnosing critical servic |
| 2 | `dart-build-resolver` | 87 | everything-claude-co | Dart/Flutter build, analysis, and dependency error resolution specialist. Fixes  |
| 3 | `kotlin-build-resolver` | 87 | everything-claude-co | Kotlin/Gradle build, compilation, and dependency error resolution specialist. Fi |
| 4 | `build-error-resolver` | 87 | everything-claude-co | Build and TypeScript error resolution specialist. Use PROACTIVELY when build fai |
| 5 | `cpp-build-resolver` | 87 | everything-claude-co | C++ build, CMake, and compilation error resolution specialist. Fixes build error |
| 6 | `data-engineer` | 87 | voltagent-subagents | Use this agent when you need to design, build, or optimize data pipelines, ETL/E |
| 7 | `database-reviewer` | 87 | everything-claude-co | PostgreSQL database specialist for query optimization, schema design, security,  |
| 8 | `go-build-resolver` | 87 | everything-claude-co | Go build, vet, and compilation error resolution specialist. Fixes build errors,  |

## optimize performance

| Öncelik | Agent | Skor | Kaynak | Açıklama |
|---------|-------|------|--------|----------|
| 1 | `ml-engineer` | 91 | voltagent-subagents | Use this agent when building production ML systems requiring model training pipe |
| 2 | `angular-architect` | 87 | voltagent-subagents | Use when architecting enterprise Angular 15+ applications with complex state man |
| 3 | `build-engineer` | 87 | voltagent-subagents | Use this agent when you need to optimize build performance, reduce compilation t |
| 4 | `cpp-reviewer` | 87 | everything-claude-co | Expert C++ code reviewer specializing in memory safety, modern C++ idioms, concu |
| 5 | `csharp-reviewer` | 87 | everything-claude-co | Expert C# code reviewer specializing in .NET conventions, async patterns, securi |
| 6 | `database-optimizer` | 87 | voltagent-subagents | Use this agent when you need to analyze slow queries, optimize database performa |
| 7 | `database-reviewer` | 87 | everything-claude-co | PostgreSQL database specialist for query optimization, schema design, security,  |
| 8 | `go-reviewer` | 87 | everything-claude-co | Expert Go code reviewer specializing in idiomatic Go, concurrency patterns, erro |

## plan project

| Öncelik | Agent | Skor | Kaynak | Açıklama |
|---------|-------|------|--------|----------|
| 1 | `cs-project-manager` | 93 | alirezarezvani-claud | Project Manager agent for sprint planning, Jira/Confluence workflows, Scrum cere |
| 2 | `architect` | 92 | continuous-claude-v3 | Feature planning, design documentation, AND integration planning |
| 3 | `plan-reviewer` | 90 | continuous-claude-v3 | Reviews feature plans (from architect) and change plans (from phoenix) |
| 4 | `review-agent` | 90 | continuous-claude-v3 | Review implementation by comparing plan (intent) vs Braintrust session (reality) |
| 5 | `cs-agile-product-owner` | 89 | alirezarezvani-claud | Agile product owner agent for epic breakdown, sprint planning, backlog refinemen |
| 6 | `cloud-architect` | 87 | voltagent-subagents | Use this agent when you need to design, evaluate, or optimize cloud infrastructu |
| 7 | `planner` | 87 | everything-claude-co | Expert planning specialist for complex features and refactoring. Use PROACTIVELY |
| 8 | `scrum-master` | 87 | voltagent-subagents | Use when teams need facilitation, process optimization, velocity improvement, or |

## refactor / clean

| Öncelik | Agent | Skor | Kaynak | Açıklama |
|---------|-------|------|--------|----------|
| 1 | `kotlin-reviewer` | 88 | everything-claude-co | Kotlin and Android/KMP code reviewer. Reviews Kotlin code for idiomatic patterns |
| 2 | `api-designer` | 87 | voltagent-subagents | Use this agent when designing new APIs, creating API specifications, or refactor |
| 3 | `build-engineer` | 87 | voltagent-subagents | Use this agent when you need to optimize build performance, reduce compilation t |
| 4 | `cli-developer` | 87 | voltagent-subagents | Use this agent when building command-line tools and terminal applications that r |
| 5 | `cloud-architect` | 87 | voltagent-subagents | Use this agent when you need to design, evaluate, or optimize cloud infrastructu |
| 6 | `data-engineer` | 87 | voltagent-subagents | Use this agent when you need to design, build, or optimize data pipelines, ETL/E |
| 7 | `database-optimizer` | 87 | voltagent-subagents | Use this agent when you need to analyze slow queries, optimize database performa |
| 8 | `mlops-engineer` | 87 | voltagent-subagents | Use this agent when you need to design and implement ML infrastructure, set up C |

## review code

| Öncelik | Agent | Skor | Kaynak | Açıklama |
|---------|-------|------|--------|----------|
| 1 | `healthcare-reviewer` | 91 | everything-claude-co | Reviews healthcare application code for clinical safety, CDSS accuracy, PHI comp |
| 2 | `plan-reviewer` | 90 | continuous-claude-v3 | Reviews feature plans (from architect) and change plans (from phoenix) |
| 3 | `review-agent` | 90 | continuous-claude-v3 | Review implementation by comparing plan (intent) vs Braintrust session (reality) |
| 4 | `kotlin-reviewer` | 88 | everything-claude-co | Kotlin and Android/KMP code reviewer. Reviews Kotlin code for idiomatic patterns |
| 5 | `cpp-reviewer` | 87 | everything-claude-co | Expert C++ code reviewer specializing in memory safety, modern C++ idioms, concu |
| 6 | `csharp-reviewer` | 87 | everything-claude-co | Expert C# code reviewer specializing in .NET conventions, async patterns, securi |
| 7 | `data-engineer` | 87 | voltagent-subagents | Use this agent when you need to design, build, or optimize data pipelines, ETL/E |
| 8 | `database-reviewer` | 87 | everything-claude-co | PostgreSQL database specialist for query optimization, schema design, security,  |

## secure / audit

| Öncelik | Agent | Skor | Kaynak | Açıklama |
|---------|-------|------|--------|----------|
| 1 | `devops-engineer` | 91 | voltagent-subagents | Use this agent when building or optimizing infrastructure automation, CI/CD pipe |
| 2 | `healthcare-reviewer` | 91 | everything-claude-co | Reviews healthcare application code for clinical safety, CDSS accuracy, PHI comp |
| 3 | `api-designer` | 87 | voltagent-subagents | Use this agent when designing new APIs, creating API specifications, or refactor |
| 4 | `cloud-architect` | 87 | voltagent-subagents | Use this agent when you need to design, evaluate, or optimize cloud infrastructu |
| 5 | `csharp-reviewer` | 87 | everything-claude-co | Expert C# code reviewer specializing in .NET conventions, async patterns, securi |
| 6 | `database-reviewer` | 87 | everything-claude-co | PostgreSQL database specialist for query optimization, schema design, security,  |
| 7 | `incident-responder` | 87 | voltagent-subagents | Use this agent when an active security breach, service outage, or operational in |
| 8 | `penetration-tester` | 87 | voltagent-subagents | Use this agent when you need to conduct authorized security penetration tests to |

## test / TDD

| Öncelik | Agent | Skor | Kaynak | Açıklama |
|---------|-------|------|--------|----------|
| 1 | `architect` | 92 | continuous-claude-v3 | Feature planning, design documentation, AND integration planning |
| 2 | `penetration-tester` | 87 | voltagent-subagents | Use this agent when you need to conduct authorized security penetration tests to |
| 3 | `prompt-engineer` | 87 | voltagent-subagents | Use this agent when you need to design, optimize, test, or evaluate prompts for  |
| 4 | `tdd-guide` | 87 | everything-claude-co | Test-Driven Development specialist enforcing write-tests-first methodology. Use  |
| 5 | `arbiter` | 86 | continuous-claude-v3 | Unit and integration test execution and validation |
| 6 | `accessibility-tester` | 85 | voltagent-subagents | Use this agent when you need comprehensive accessibility testing, WCAG complianc |
| 7 | `frontend-developer` | 85 | voltagent-subagents | Use when building complete frontend applications across React, Vue, and Angular  |
| 8 | `migration-planner` | 85 | alirezarezvani-claud | Analyzes Cypress or Selenium test suites and creates a file-by-file migration pl |

## write code

| Öncelik | Agent | Skor | Kaynak | Açıklama |
|---------|-------|------|--------|----------|
| 1 | `deployment-engineer` | 91 | voltagent-subagents | Use this agent when designing, building, or optimizing CI/CD pipelines and deplo |
| 2 | `devops-engineer` | 91 | voltagent-subagents | Use this agent when building or optimizing infrastructure automation, CI/CD pipe |
| 3 | `ml-engineer` | 91 | voltagent-subagents | Use this agent when building production ML systems requiring model training pipe |
| 4 | `review-agent` | 90 | continuous-claude-v3 | Review implementation by comparing plan (intent) vs Braintrust session (reality) |
| 5 | `devops-incident-responder` | 89 | voltagent-subagents | Use when actively responding to production incidents, diagnosing critical servic |
| 6 | `vue-specialist` | 88 | rohitg00-toolkit | Vue 3 development with Composition API, Pinia state management, Nuxt 3, and VueU |
| 7 | `dart-build-resolver` | 87 | everything-claude-co | Dart/Flutter build, analysis, and dependency error resolution specialist. Fixes  |
| 8 | `kotlin-build-resolver` | 87 | everything-claude-co | Kotlin/Gradle build, compilation, and dependency error resolution specialist. Fi |

## Yüksek Overlap'ler (manuel inceleme)

| A | B | Similarity | A Domain | B Domain |
|---|---|------------|----------|----------|
| `kotlin-build-resolver` | `java-build-resolver` | 0.667 | coding | frontend |
| `braintrust-analyst` | `session-analyst` | 0.667 | devops | project-mgmt |
| `cpp-build-resolver` | `go-build-resolver` | 0.579 | frontend | frontend |
| `Solo Founder` | `solo-founder` | 0.56 | devops | docs |
| `kotlin-build-resolver` | `cpp-build-resolver` | 0.55 | coding | frontend |
| `kotlin-build-resolver` | `go-build-resolver` | 0.55 | coding | frontend |
| `kotlin-build-resolver` | `rust-build-resolver` | 0.522 | coding | frontend |
| `Growth Marketer` | `growth-marketer` | 0.517 | frontend | docs |
| `Finance Lead` | `finance-lead` | 0.515 | frontend | docs |
| `cpp-build-resolver` | `java-build-resolver` | 0.478 | frontend | frontend |
| `cpp-build-resolver` | `rust-build-resolver` | 0.478 | frontend | frontend |
| `go-build-resolver` | `java-build-resolver` | 0.478 | frontend | frontend |
| `go-build-resolver` | `rust-build-resolver` | 0.478 | frontend | frontend |
| `go-reviewer` | `rust-reviewer` | 0.471 | coding | coding |
| `dart-build-resolver` | `kotlin-build-resolver` | 0.462 | frontend | coding |
| `java-build-resolver` | `rust-build-resolver` | 0.462 | frontend | frontend |
| `laravel-specialist` | `symfony-specialist` | 0.44 | devops | frontend |
| `Startup CTO` | `startup-cto` | 0.438 | architecture | docs |
| `dart-build-resolver` | `cpp-build-resolver` | 0.423 | frontend | frontend |
| `dart-build-resolver` | `go-build-resolver` | 0.423 | frontend | frontend |
| `dart-build-resolver` | `java-build-resolver` | 0.414 | frontend | frontend |
| `dart-build-resolver` | `rust-build-resolver` | 0.414 | frontend | frontend |

