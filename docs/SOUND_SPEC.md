# HangulQuest — 사운드 사양서 (v1.0)

원칙: 모든 오디오는 `AudioAssetManager`의 논리 슬롯으로만 참조한다. 코드에는 파일 경로가 아닌
슬롯 ID만 존재하며, 개발 단계(고품질 TTS 플레이스홀더) → 출시(성우 녹음) 교체는 에셋 매핑
테이블 교체만으로 완료된다.

## 1. 원어민 발음 슬롯 (성우 녹음 전제)

| 슬롯 네임스페이스 | 수량 | 내용 | 녹음 가이드 |
|---|---|---|---|
| `voice/jamo/{jamoId}` | 51 | 자음 19(기본14+쌍5) 명칭+음가(예: "기역, 그"), 모음 21+복합 포함 음가 | 여성 성우 1인, 표준어, 48kHz/24bit, 잔향 없는 드라이 톤 |
| `voice/syllable/{codepoint}` | 커리큘럼 등장 음절(약 320) | 단음절 발음 | 동일 성우, 동일 세션 톤 유지 |
| `voice/word/{wordId}` | 어휘 데이터셋(120) | 자연 억양 단어 발음 | 동일 성우 |
| `voice/ui/{cue}` | 12 | "잘했어요!", "아깝다!" 등 짧은 리액션 | 과장 금지, 따뜻한 톤 |

개발 단계 플레이스홀더: iOS `AVSpeechSynthesizer`(ko-KR) 또는 사전 생성 고품질 TTS wav.
슬롯 ID는 녹음본과 1:1이므로 코드 수정 없음.

## 2. 효과음 (SFX)

| 슬롯 | 트리거 |
|---|---|
| `sfx/tap_correct` / `sfx/tap_wrong` | 자모 사냥 정답/오답 |
| `sfx/combo_{2,3,4}` | 콤보 단계 상승(피치 상승 계열) |
| `sfx/block_pick` / `sfx/block_drop` / `sfx/block_reject` | 2단계 드래그 픽업/장착/거부 |
| `sfx/syllable_complete` | 글자 조립 완성(발음 재생 직전 0.2초 스팅) |
| `sfx/level_up` / `sfx/badge` / `sfx/card_unlock` | 레벨업/뱃지/도감 카드 해금(카드는 홀로그램 샤인음) |
| `sfx/streak` / `sfx/countdown` / `sfx/result_star` | 스트릭 달성/제한시간 3초/결과 별 |

## 3. BGM

| 슬롯 | 장면 | 무드 |
|---|---|---|
| `bgm/home` | 홈 맵 | 로파이 국악 퓨전, 60–70 BPM |
| `bgm/stage1` | 자모 사냥 | 업템포 아케이드 |
| `bgm/stage2` | 글자 조립 | 집중형 퍼즐, 미니멀 |
| `bgm/stage3` | 단어 러시 | 스피드 러시 |
| `bgm/stage4` | 발음 도전 | 발음 중 자동 덕킹(볼륨 -80%) |
| `bgm/result` | 결과 | 짧은 팡파레 후 루프 |

## 4. 설정·믹싱 규칙
- 설정 화면: BGM/SFX/음성 3채널 독립 볼륨 + 전체 음소거.
- 음성(voice) 채널은 항상 최우선 — 재생 시 BGM 자동 덕킹.
- 4단계 녹음 중 BGM·SFX 전체 뮤트(인식 정확도).
- 모든 재생은 `AudioAssetManager.play(slotId)` 경유. 미존재 슬롯은 무음 + 디버그 로그(크래시 금지).
