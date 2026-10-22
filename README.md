# Personal Flow

Personal Flow는 개인 소프트웨어 개발 작업을 정의부터 계획, 구현, 리뷰, QA, 회고까지 이어 주는 Codex 스킬입니다. 자체 개발 프레임워크를 새로 만드는 대신, 프로젝트별 상태를 `.flow/`에 기록하고 현재 환경에서 사용할 수 있는 OpenSpec, gstack, Compound Engineering(CE), OMX를 필요한 단계에만 연결합니다.

## 작업 흐름

```text
task -> discover? -> brainstorm? -> plan -> work -> review -> polish? -> qa -> close
                           ^                  |                   |
                           +------ rework ----+-------- rework ----+
```

작업 규모에 따라 가장 작은 프로필을 선택합니다.

| 프로필 | 기본 단계 | 용도 |
|---|---|---|
| `small` | plan → work → review → QA → close | 범위가 작고 요구사항이 명확한 작업 |
| `standard` | 필요시 discover/brainstorm 추가 | 일반적인 기능 개발과 수정 |
| `large` | 제품·설계 검토와 병렬 작업을 선택적으로 추가 | 아키텍처, 보안, 주요 UX 또는 여러 작업 흐름이 바뀌는 경우 |

## 주요 특징

- 작업 정의, 결정, 계획, 리뷰, QA 결과와 후속 작업을 `.flow/tasks/<slug>/`에 보존합니다.
- 테스트·린트·타입 검사 등 실제 검증 결과를 완료 근거로 사용합니다.
- 필수 운영 규칙과 선택 권장사항을 구분합니다.
- `AGENTS.md`, 작업 분해, 컨텍스트, 완료 조건, 근거 조사, diff·위험·롤백 보고를 확인합니다.
- 반복해서 효과가 검증된 프롬프트는 필요할 때 별도 스킬로 발전시킬 수 있습니다.
- 외부 도구의 버전과 현재 세션에서 실제 사용할 수 있는 기능을 확인하며, 특정 버전의 명령을 추측하거나 강제하지 않습니다.

## 설치

사용자 전역 스킬 경로에 저장소를 복제합니다.

```powershell
New-Item -ItemType Directory -Force "$HOME\.agents\skills" | Out-Null

git clone `
  https://github.com/ddokkang1105/personal-flow.git `
  "$HOME\.agents\skills\personal-flow"
```

최종 파일 경로가 다음과 같아야 합니다.

```text
$HOME/.agents/skills/personal-flow/SKILL.md
```

Codex에서 스킬이 표시되지 않으면 앱을 재시작합니다. 같은 이름의 스킬을 `.agents/skills`와 기존 `.codex/skills` 양쪽에 중복 설치하지 마세요. 자세한 로컬 스킬 경로와 탐지 방식은 [OpenAI 스킬 문서](https://developers.openai.com/codex/skills)를 참고하세요.

## 사용

새 작업 예시:

```text
$personal-flow 새 작업 시작: 로그인 오류 수정.
small 프로필로 계획 → 작성 → 문서 리뷰 → 검증 → 종료까지 진행해줘.
```

작업을 시작하면 프로젝트에 `.flow/`가 생성되고 다음 문서들이 관리됩니다.

```text
.flow/
├─ tasks/<task-slug>/
│  ├─ task.md
│  ├─ decisions.md
│  ├─ plan.md
│  ├─ review.md
│  ├─ qa.md
│  ├─ followups.md
│  └─ state.yaml
└─ knowledge/
```

작업 폴더만 직접 만들 수도 있습니다. macOS/Linux에서는 스킬 디렉터리에서 Python 스크립트를 실행합니다.

```bash
python3 scripts/new-task.py --title "로그인 오류 수정" --profile small --root /path/to/repo/.flow
```

PowerShell에서는 다음 명령을 사용합니다.

```powershell
& "$HOME\.agents\skills\personal-flow\scripts\new-task.ps1" `
  -Title "로그인 오류 수정" `
  -Profile small `
  -Root "C:\path\to\repo\.flow"
```

## 외부 프레임워크

외부 프레임워크는 선택 의존성이며 이 저장소에 포함되지 않습니다.

| 프레임워크 | 역할 |
|---|---|
| OpenSpec | 선택적인 작업·사양 관리 |
| gstack | 제품, 아키텍처, 디자인 및 브라우저 QA 게이트 |
| Compound Engineering | 계획, 구현, 리뷰 및 지식 정리의 주 실행 루프 |
| OMX | 명시적으로 승인된 독립 작업의 선택적 병렬 런타임 |

설치 여부 확인은 권한이나 실행 승인을 의미하지 않습니다. 사용할 수 없는 프레임워크는 직접 수행 방식으로 대체하고 그 사실을 작업 기록에 남깁니다.

환경 탐지(macOS/Linux):

```bash
python3 scripts/probe-frameworks.py /path/to/repo
```

환경 탐지(Windows PowerShell):

```powershell
& "$HOME\.agents\skills\personal-flow\scripts\probe-frameworks.ps1" `
  -ProjectRoot "C:\path\to\repo"
```

## 업데이트

로컬 변경이 없는지 먼저 확인한 다음 fast-forward 업데이트만 허용합니다.

```powershell
git -C "$HOME\.agents\skills\personal-flow" status --short
git -C "$HOME\.agents\skills\personal-flow" pull --ff-only
```

외부 프레임워크가 업그레이드되면 탐지 결과와 공식 변경 기록을 다시 확인해야 합니다. Personal Flow는 외부 프레임워크를 자동으로 설치하거나 업그레이드하지 않습니다.

## 저장소 구성

```text
SKILL.md                 핵심 워크플로와 단계별 규칙
agents/openai.yaml       Codex UI 메타데이터
assets/templates/        프로젝트별 `.flow` 작업 템플릿
references/              프레임워크 라우팅, 운영 체크리스트, 출처
scripts/new-task.py      새 작업 문서 초기화(macOS/Linux)
scripts/new-task.ps1     새 작업 문서 초기화(Windows)
scripts/probe-frameworks.py
                         설치된 외부 프레임워크 탐지(macOS/Linux)
scripts/probe-frameworks.ps1
                         설치된 외부 프레임워크 탐지(Windows)
```

세부 운영 기준은 [실무 운영 및 프롬프트 체크리스트](references/practical-operations-checklist.md), 프레임워크 선택 기준은 [Framework Routing](references/framework-routing.md), 조사 출처와 갱신 규칙은 [Source Registry](references/sources.md)에서 확인할 수 있습니다.

## 운영 원칙

- 커밋, 푸시, 배포, 외부 게시와 다른 런타임 실행은 명시적인 승인 없이 수행하지 않습니다.
- 프로젝트별 `.flow/` 기록은 이 스킬 저장소에 커밋하지 않습니다.
- 버전·모델·reasoning effort·기능 플래그는 현재 환경에서 제공되는 값만 사용합니다.
- 문서와 스크립트가 충돌하면 `SKILL.md`의 현재 규칙과 프로젝트에 적용되는 `AGENTS.md`를 우선합니다.

보조 스크립트는 macOS/Linux용 Python과 Windows용 PowerShell 구현을 제공합니다.
