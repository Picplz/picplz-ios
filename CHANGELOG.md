# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- 카카오 로그인
- 키체인을 통한 토큰 관리
- 고객 및 작가 회원가입
- 고객용 작가 리뷰 목록 페이지 (정렬 기능 포함)
- 사진 리뷰 모아보기 그리드 및 개별 사진 상세 보기 (페이징 지원)
- 공통 임시 네비게이션 바 컴포넌트

### Changed

- DI 방식 개선
- 모듈 의존 관계 개선
- 작가 상세 화면의 더미 데이터를 Domain 엔티티 기반 렌더링으로 정리하고 프리뷰 목 데이터를 static mock으로 통합
- 고객 홈 플로우 네비게이션 구조를 단일 NavigationStack 및 Delegate 패턴으로 통합 리팩터링
- 프로젝트 작업 규칙 명시 (GEMINI.md)

### Deprecated

### Removed

### Fixed

### Security

[unreleased]: https://github.com/Picplz/picplz-ios/commits/develop/
