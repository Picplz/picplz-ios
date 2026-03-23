# 📸 Picplz iOS

내 인생샷 찍어줄 작가님과 위치기반 매칭!

## 🛠 주요 기술 스택

- **UI**: SwiftUI
- **Architecture**: Modular + Clean Architecture
- **State Management**:
  [The Composable Architecture (TCA)](https://github.com/pointfreeco/swift-composable-architecture)
- **Dependency Injection**:
  [swift-dependencies](https://github.com/pointfreeco/swift-dependencies)
- **Project Management**: [Tuist](https://tuist.io/)
- **Version Control**: [mise](https://mise.jdx.dev/) (Developer Tooling Manager)

## 🏗 아키텍처 개요

- **PicplzApp**: 앱의 진입점 및 루트 설정
- **Features**: 화면별 UI 및 TCA Feature (Splash, Onboarding, Main 등)
- **Domain**: 순수 비즈니스 로직 및 인터페이스 (Entities, UseCases)
- **DependencyInjection**: DI 연결 통로 및 실체 구현체 주입
- **Networking/Storage/Platform**: API 통신, 로컬 데이터 저장소, 플랫폼 종속
  서비스

> 💡 더 자세한 아키텍처 및 모듈 의존성 그래프는
> [ONBOARDING.md](./Documents/ONBOARDING.md)에서 확인하실 수 있습니다.

## 🚀 빠른 시작 (Getting Started)

프로젝트를 실행하기 위해 필요한 최소한의 단계입니다.

### 1. 사전 준비 (Prerequisites)

```bash
# mise 설치 (macOS 기준)
brew install mise
```

### 2. 설정 파일

- Configs 디렉토리에 debug.xcconfig와 release.xcconfig 파일을 복사합니다.

### 3. 프로젝트 설정 및 생성

```bash
# 1. 필수 개발 도구 설치 (tuist 등)
mise install

# 2. 외부 의존성(SPM) 패키지 설치
tuist install

# 3. Xcode 프로젝트 생성
tuist generate
```

### 4. 프로젝트 실행

생성된 `Picplz.xcworkspace` 파일을 Xcode에서 열고, `PicplzApp` 타겟을 선택하여
실행합니다.

## 📂 주요 디렉토리 구조

- `Projects/`: 각 모듈의 소스 코드가 위치합니다.
- `Tuist/`: 프로젝트 설정 및 의존성 관리 도구 설정이 포함되어 있습니다.
- `Configs/`: 빌드 설정(`.xcconfig`) 파일이 위치합니다.
