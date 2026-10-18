# iOS 심사 대응 체크리스트 (빌드 전 필수)

> `flutter create --platforms=ios .` 실행 후 `ios/Runner/Info.plist`에 아래 키를 추가하고
> 이 폴더의 내용을 `ios/`로 옮긴다.

## 1. Info.plist 필수 키

```xml
<key>NSMicrophoneUsageDescription</key>
<string>발음 도전 모드에서 회원님의 한국어 발음을 채점하기 위해 마이크를 사용합니다. 음성은 기기에서만 처리되며 저장되거나 전송되지 않습니다.</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>말한 발음을 글자로 인식해 채점하기 위해 음성 인식을 사용합니다. 인식은 기기 내에서 처리됩니다.</string>
```

## 2. 앱 내 필수 화면 (구현 완료 — 코드 위치)
- 구독 해지 안내: `lib/features/settings/settings_screen.dart` → `ManageSubscriptionScreen`
- 개인정보 처리방침(인앱 + 외부 URL 연결 지점): 동일 파일 → `PrivacyPolicyScreen`
  (`policyUrl = https://hangulquest.app/privacy` — App Store Connect 메타데이터와 일치시킬 것)
- 이용약관(EULA, guideline 3.1.2): 동일 파일 → `TermsOfUseScreen`
  (`termsUrl` = Apple 표준 EULA — 자체 약관을 만들면 교체, App Store Connect와 일치시킬 것)
- 페이월 고지: 가격/기간/자동갱신/해지/복원/이용약관 — `lib/features/paywall/paywall_screen.dart`

## 3. 결제 규정 (guideline 3.1.1)
- 스토어 빌드에서 외부 결제 유도 문구·링크 금지 — 코드 레벨 가드:
  `BillingConfig.isValidPairing` + `AppServices` 생성자 어서트
  (Stripe/mock 게이트웨이는 `allowedInStoreBuild = false`).
- Stripe는 Flutter Web 배포에서만 사용.

## 4. 권한 거부 시 동작
- 마이크 거부 → 4단계만 비활성(안내 화면), 나머지 기능 전부 정상.
  검증: `test/app_flow_test.dart` "speech unavailable disables stage 4".

## 5. 플랫폼 채널 (구현 완료 — Xcode 빌드 검증 필요)
- `ios/Runner/SpeechChannel.swift`: `hq/speech` — SFSpeechRecognizer(ko-KR),
  `requiresOnDeviceRecognition = true`, 마이크 탭 + 타임아웃. Dart 측:
  `lib/platform/speech/ios_speech_recognizer.dart`.
- `ios/Runner/BillingChannel.swift`: `hq/billing` — StoreKit 2
  (Product.products / purchase / currentEntitlements), `hq/billing/status`
  EventChannel이 Transaction.updates를 스트리밍. Dart 측:
  `lib/platform/billing/storekit_billing.dart`.
- 채널 페이로드 계약은 `test/platform_channel_test.dart`가 고정
  (Swift 수정 시 이 테스트와 페이로드 키를 맞출 것).
- Swift 소스는 Windows에서 컴파일 불가 — macOS/Xcode에서 빌드 확인 필요.
  두 파일을 Xcode의 Runner 타깃에 추가해야 한다(파일 존재만으로는 빌드에 포함 안 됨).

## 6. 제출 전 확인
- [x] Info.plist 키 2종 반영 (마이크·음성인식)
- [x] 릴리스 와이어링: `AppServices.appStore(audio: ...)` 팩토리 (main에서 dev와 교체)
- [x] 오디오 에셋 번들: 165슬롯 매니페스트(`assets/audio/manifest.json`),
      성우 녹음 교체 시 `dart run tool/gen_audio_manifest.dart` 재실행만 하면 됨
- [ ] Xcode에서 SpeechChannel.swift / BillingChannel.swift를 Runner 타깃에 추가 + 빌드
- [ ] App Store Connect: 구독 상품 `hq_premium_monthly` / `hq_premium_yearly` + 7일 무료 체험 설정
- [ ] 개인정보 처리방침 URL 라이브 상태
- [ ] TTS 플레이스홀더 → 성우 녹음 교체 여부 결정(슬롯 ID 1:1, 코드 수정 없음)
- [ ] 실기기: 발음 도전(마이크 권한 허용/거부 경로), 샌드박스 결제/복원, 햅틱
