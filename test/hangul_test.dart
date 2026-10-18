import 'package:flutter_test/flutter_test.dart';
import 'package:hangul_quest/core/hangul/hangul.dart';

void main() {
  group('compose', () {
    test('ㄱ+ㅏ = 가', () {
      expect(compose(0, 0).char, '가');
    });
    test('ㄱ+ㅏ+ㅇ = 강', () {
      expect(compose(0, 0, 21).char, '강');
    });
    test('ㅎ+ㅣ+ㅎ = 힣 (last syllable)', () {
      expect(compose(18, 20, 27).char, '힣');
      expect(compose(18, 20, 27).codePoint, 0xD7A3);
    });
    test('한/글', () {
      // 한 = ㅎ(18) + ㅏ(0) + ㄴ(4), 글 = ㄱ(0) + ㅡ(18) + ㄹ(8)
      expect(compose(18, 0, 4).char, '한');
      expect(compose(0, 18, 8).char, '글');
    });
    test('rejects out-of-range indices', () {
      expect(() => compose(19, 0), throwsRangeError);
      expect(() => compose(0, 21), throwsRangeError);
      expect(() => compose(0, 0, 28), throwsRangeError);
      expect(() => compose(-1, 0), throwsRangeError);
    });
  });

  group('decompose', () {
    test('강 → ㄱ, ㅏ, ㅇ받침', () {
      final s = decompose('강'.runes.first);
      expect(s.choseongJamo.char, 'ㄱ');
      expect(s.jungseongJamo.char, 'ㅏ');
      expect(s.jongseongJamo!.char, 'ㅇ');
      expect(s.hasBatchim, isTrue);
    });
    test('가 has no batchim', () {
      final s = decompose('가'.runes.first);
      expect(s.jongseong, 0);
      expect(s.jongseongJamo, isNull);
    });
    test('rejects non-syllable code points', () {
      expect(() => decompose(0x41), throwsArgumentError); // 'A'
      expect(() => decompose(0x3131), throwsArgumentError); // 'ㄱ' jamo
      expect(() => decompose(syllableBase - 1), throwsArgumentError);
      expect(() => decompose(syllableBase + syllableCount), throwsArgumentError);
    });
  });

  test('roundtrip over all 11,172 syllables', () {
    var count = 0;
    for (var c = 0; c < choseongCount; c++) {
      for (var v = 0; v < jungseongCount; v++) {
        for (var f = 0; f < jongseongCount; f++) {
          final s = compose(c, v, f);
          final back = decompose(s.codePoint);
          expect(back, s);
          count++;
        }
      }
    }
    expect(count, syllableCount);
    expect(count, 11172);
  });

  group('layout classification', () {
    test('vertical vowels', () {
      expect(decompose('가'.runes.first).layout, SyllableLayout.vertical);
      expect(decompose('비'.runes.first).layout, SyllableLayout.vertical);
    });
    test('horizontal vowels', () {
      expect(decompose('고'.runes.first).layout, SyllableLayout.horizontal);
      expect(decompose('무'.runes.first).layout, SyllableLayout.horizontal);
      expect(decompose('그'.runes.first).layout, SyllableLayout.horizontal);
    });
    test('mixed/compound vowels', () {
      expect(decompose('과'.runes.first).layout, SyllableLayout.mixed);
      expect(decompose('귀'.runes.first).layout, SyllableLayout.mixed);
      expect(decompose('의'.runes.first).layout, SyllableLayout.mixed);
    });
  });

  group('table integrity', () {
    test('table sizes match Unicode composition math', () {
      expect(choseongTable.length, 19);
      expect(jungseongTable.length, 21);
      expect(jongseongTable.length, 27); // 28 minus the "none" slot
    });
    test('indices are self-consistent', () {
      for (var i = 0; i < choseongTable.length; i++) {
        expect(choseongTable[i].index, i);
      }
      for (var i = 0; i < jungseongTable.length; i++) {
        expect(jungseongTable[i].index, i);
      }
      for (var i = 0; i < jongseongTable.length; i++) {
        expect(jongseongTable[i].index, i + 1);
      }
    });
    test('jamoById covers all tables with unique ids', () {
      expect(jamoById.length,
          choseongTable.length + jungseongTable.length + jongseongTable.length);
    });
  });

  test('jamoIdsInWord: 김치 → ㄱㅣㅁ ㅊㅣ', () {
    expect(jamoIdsInWord('김치'),
        ['c_giyeok', 'v_i', 'f_mieum', 'c_chieut', 'v_i']);
  });

  test('decomposeText passes through non-Hangul', () {
    final out = decomposeText('가A나');
    expect(out[0], isNotNull);
    expect(out[1], isNull);
    expect(out[2], isNotNull);
  });
}
