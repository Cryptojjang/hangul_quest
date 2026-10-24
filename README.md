# Hangul Bricks (formerly HangulQuest)

게임 플레이만으로 자모 인식 → 글자 조합 → 단어 읽기에 도달하는 한글 학습 게임.
iOS 1차 타깃, Flutter 단일 코드베이스. 문서: [제품 사양서](docs/PRODUCT_SPEC.md) ·
[사운드 사양](docs/SOUND_SPEC.md) · [디자인 아이덴티티](docs/DESIGN_SPEC.md)

## 구조

```
lib/
  core/            # 순수 Dart 게임·학습 로직 (Flutter 의존 없음)
    hangul/        #   유니코드 음절 조합/분해 엔진 + 자모 데이터
    game/          #   1~3단계 라운드 엔진 (조립 퍼즐 포함)
    srs/           #   간격 반복(SM-2 계열)
    adaptive/      #   오답 추적 + 가중 출제
    economy/       #   무료/프리미엄 경계 (ContentGate)
    data/          #   커리큘럼·어휘·7일 트래커
    events/        #   이벤트 로깅 계약
  platform/        # 교체 지점 (스토어 종속성 격리)
    billing/       #   BillingGateway: mock / StoreKit / Play / Lemon Squeezy(web)
    speech/        #   SpeechRecognizer + 교체 가능한 발음 채점 모듈
    audio/         #   AudioAssetManager (TTS 플레이스홀더 → 성우 녹음)
    device/        #   햅틱, 푸시
  state/           # 로컬 우선 저장 (ProgressStore) + 컴포지션 루트 (AppState)
  features/        # 화면 (온보딩/홈/미니레슨/4개 스테이지/도감/복습/페이월/설정)
  theme/           # 디자인 시스템 (달항아리 미니멀 + 단청 액센트)
```

## 개발

```sh
flutter pub get
flutter test          # 코어 로직 검증 (조합·SRS·페이월·결제 전환 등)
flutter run           # dev 채널: mock 결제 + TTS 플레이스홀더
```

결제 채널 전환은 `AppServices` 구성에서 `BillingConfig.gatewayFor(channel)` 하나로
이뤄진다. 스토어 빌드에 비스토어 게이트웨이가 연결되면 어서트로 즉시 실패한다.

## 스토어 심사

`docs/PRODUCT_SPEC.md` §8 체크리스트 참조. `flutter create` 후
`ios/REVIEW_CHECKLIST.md`의 Info.plist 키를 반영할 것.
