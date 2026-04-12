# AGENTS.md

## 목적

이 문서는 `picplz-ios`에서 작업하는 에이전트가 프로젝트 구조와 변경 원칙을 빠르게 이해하도록 돕기 위한 간단한 가이드입니다.

## 프로젝트 구조

- `Projects/PicplzApp`: 앱 진입점과 앱 레벨 상태 전환
- `Projects/Features`: SwiftUI 화면, TCA Feature, 디자인 시스템
- `Projects/Domain`: 엔티티, 유스케이스, 저장소 프로토콜
- `Projects/Networking`: API, DTO, 네트워크 저장소 구현
- `Projects/Platform`: 위치 등 플랫폼 기능 구현
- `Projects/Storage`: 로컬 저장소 구현
- `Projects/DependencyInjection`: `swift-dependencies` live 등록
- `Projects/Common`, `Projects/SharedSupports`: 공통 코드

## 핵심 원칙

- 레이어 경계를 유지한다.
- 비즈니스 규칙은 가능한 `Domain`에 둔다.
- `Domain` 엔티티에는 UI 표현 편의를 위한 문자열 조합, 포맷팅, 화면 전용 computed property를 넣지 않는다.
- DTO는 `Networking`에만 두고, 외부에는 `Domain` 모델을 사용한다.
- 구현 연결은 `DependencyInjection`에서 처리한다.
- 화면 로직은 TCA Reducer에 두고, View는 표현과 액션 전달에 집중한다.

## 변경 가이드

- 새 기능은 보통 `Domain → 구현체(Networking/Platform/Storage) → DependencyInjection → Features` 순서로 추가한다.
- UI 전용 가공값이 필요하면 `Features`에서 `Entities+UI` 형태의 extension으로 분리한다.
- 앱 초기 진입이나 전역 분기가 바뀔 때만 `PicplzApp`을 수정한다.
- `Features`가 `Networking`의 구현 세부사항을 직접 알지 않도록 유지한다.
- 플랫폼 SDK 접근은 `Platform`에 두고, `Features`에서 직접 다루지 않는다.

## 작업 시 주의

- 실제 키나 엔드포인트는 하드코딩하지 않는다.
- 기존 `FIXME`, `TODO`와 충돌하지 않는지 확인한다.
- 사용자 영향이 있는 변경이나 중요한 구조 변경은 `CHANGELOG.md`를 함께 갱신한다.
- PR 작성 시 `.github/pull_request_template.md` 규칙을 따른다.
- 이슈와 PR의 말미에 "이 이슈/PR은 YOUR_MODEL_ID가 함께 작성했습니다"라고 덧븉인다. 

## 빠른 참고

- 앱 시작: `Projects/PicplzApp/Sources/PicplzApp.swift`
- 앱 루트 상태: `Projects/PicplzApp/Sources/AppFeature.swift`
- 로그인 시작점: `Projects/Features/Sources/Onboarding/OnboardingFeature.swift`
- 프로젝트 템플릿: `Tuist/ProjectDescriptionHelpers/Project+Templates.swift`
- 의존성 등록: `Projects/DependencyInjection/Sources`
