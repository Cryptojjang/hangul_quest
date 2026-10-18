/// Mistake tracking + adaptive question weighting.
///
/// Jamo the player misses often get a higher sampling weight in later rounds;
/// five consecutive correct answers decay the weight back toward baseline.
library;

import 'dart:math';

class ItemStats {
  ItemStats({this.correct = 0, this.wrong = 0, this.streak = 0});

  int correct;
  int wrong;

  /// Current consecutive-correct streak.
  int streak;

  int get seen => correct + wrong;
  double get errorRate => seen == 0 ? 0 : wrong / seen;

  Map<String, dynamic> toJson() =>
      {'correct': correct, 'wrong': wrong, 'streak': streak};

  factory ItemStats.fromJson(Map<String, dynamic> json) => ItemStats(
        correct: json['correct'] as int? ?? 0,
        wrong: json['wrong'] as int? ?? 0,
        streak: json['streak'] as int? ?? 0,
      );
}

class ErrorTracker {
  ErrorTracker({Random? random}) : _random = random ?? Random();

  static const double errorWeightFactor = 3.0;
  static const int decayStreak = 5;

  final Random _random;
  final Map<String, ItemStats> _stats = {};

  ItemStats statsFor(String itemId) =>
      _stats.putIfAbsent(itemId, () => ItemStats());

  void recordCorrect(String itemId) {
    final s = statsFor(itemId);
    s.correct += 1;
    s.streak += 1;
  }

  void recordWrong(String itemId) {
    final s = statsFor(itemId);
    s.wrong += 1;
    s.streak = 0;
  }

  /// Sampling weight: baseline 1.0, boosted by error rate, decayed once the
  /// player has answered [decayStreak] in a row correctly.
  double weightFor(String itemId) {
    final s = _stats[itemId];
    if (s == null || s.seen == 0) return 1.0;
    var w = 1.0 + s.errorRate * errorWeightFactor;
    if (s.streak >= decayStreak) {
      w = 1.0 + (w - 1.0) * 0.25;
    }
    return w;
  }

  /// Item ids sorted weakest-first — feeds the smart-review fallback pool.
  List<String> weakestItems({int limit = 10}) {
    final entries = _stats.entries.where((e) => e.value.wrong > 0).toList()
      ..sort((a, b) => b.value.errorRate.compareTo(a.value.errorRate));
    return entries.take(limit).map((e) => e.key).toList();
  }

  /// Weighted sample of [count] distinct items from [pool].
  List<String> sample(List<String> pool, int count) {
    final remaining = List<String>.from(pool);
    final picked = <String>[];
    while (picked.length < count && remaining.isNotEmpty) {
      final weights = remaining.map(weightFor).toList();
      final total = weights.fold<double>(0, (a, b) => a + b);
      var roll = _random.nextDouble() * total;
      var idx = 0;
      for (var i = 0; i < weights.length; i++) {
        roll -= weights[i];
        if (roll <= 0) {
          idx = i;
          break;
        }
      }
      picked.add(remaining.removeAt(idx));
    }
    return picked;
  }

  Map<String, dynamic> toJson() =>
      {for (final e in _stats.entries) e.key: e.value.toJson()};

  void loadJson(Map<String, dynamic> json) {
    _stats.clear();
    json.forEach((k, v) {
      _stats[k] = ItemStats.fromJson(Map<String, dynamic>.from(v as Map));
    });
  }
}
