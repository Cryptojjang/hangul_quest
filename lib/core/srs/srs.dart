/// Spaced-repetition scheduler (SM-2 derivative, tuned for short jamo items).
///
/// Pure Dart, injectable clock for testability. Persisted as part of the
/// progress state tree.
library;

class SrsCard {
  SrsCard({
    required this.itemId,
    this.easiness = 2.5,
    this.repetitions = 0,
    this.intervalDays = 0,
    this.dueAt,
    this.lapses = 0,
  });

  /// Jamo id (`c_giyeok`), syllable (`syl_44032`), or word id (`w_kimchi`).
  final String itemId;
  double easiness;
  int repetitions;
  double intervalDays;
  DateTime? dueAt;
  int lapses;

  Map<String, dynamic> toJson() => {
        'itemId': itemId,
        'easiness': easiness,
        'repetitions': repetitions,
        'intervalDays': intervalDays,
        'dueAt': dueAt?.toIso8601String(),
        'lapses': lapses,
      };

  factory SrsCard.fromJson(Map<String, dynamic> json) => SrsCard(
        itemId: json['itemId'] as String,
        easiness: (json['easiness'] as num).toDouble(),
        repetitions: json['repetitions'] as int,
        intervalDays: (json['intervalDays'] as num).toDouble(),
        dueAt: json['dueAt'] == null
            ? null
            : DateTime.parse(json['dueAt'] as String),
        lapses: json['lapses'] as int? ?? 0,
      );
}

/// Review quality. Mapped from in-game answers: instant correct = good,
/// slow/hesitant correct = hard, wrong = again.
enum ReviewGrade { again, hard, good, easy }

class SrsScheduler {
  SrsScheduler({DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  /// Interval ceiling: a jamo mastered for a year needs no further spacing.
  static const double maxIntervalDays = 365;

  final DateTime Function() _clock;
  final Map<String, SrsCard> _cards = {};

  Iterable<SrsCard> get cards => _cards.values;

  SrsCard cardFor(String itemId) =>
      _cards.putIfAbsent(itemId, () => SrsCard(itemId: itemId));

  /// Applies a review and reschedules the card. Returns the new interval.
  double review(String itemId, ReviewGrade grade) {
    final card = cardFor(itemId);
    final now = _clock();

    if (grade == ReviewGrade.again) {
      card.repetitions = 0;
      card.lapses += 1;
      card.intervalDays = 0; // relearn today
      card.easiness = (card.easiness - 0.2).clamp(1.3, 2.8);
      card.dueAt = now.add(const Duration(minutes: 10));
      return card.intervalDays;
    }

    final q = switch (grade) {
      ReviewGrade.hard => 3,
      ReviewGrade.good => 4,
      ReviewGrade.easy => 5,
      ReviewGrade.again => 0,
    };
    card.easiness = (card.easiness +
            (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02)))
        .clamp(1.3, 2.8);

    card.repetitions += 1;
    if (card.repetitions == 1) {
      card.intervalDays = 1;
    } else if (card.repetitions == 2) {
      card.intervalDays = 3;
    } else {
      card.intervalDays = card.intervalDays * card.easiness;
    }
    if (grade == ReviewGrade.hard) {
      card.intervalDays = card.intervalDays.clamp(1, double.infinity) * 0.8;
    }
    card.intervalDays = card.intervalDays.clamp(0, maxIntervalDays);
    card.dueAt = now.add(Duration(
        minutes: (card.intervalDays * Duration.minutesPerDay).round()));
    return card.intervalDays;
  }

  /// Cards due now, most overdue first.
  List<SrsCard> dueCards() {
    final now = _clock();
    final due = _cards.values
        .where((c) => c.dueAt == null || !c.dueAt!.isAfter(now))
        .toList();
    due.sort((a, b) {
      final ad = a.dueAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bd = b.dueAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return ad.compareTo(bd);
    });
    return due;
  }

  /// Builds a personalized ~5-minute review session (default 20 items):
  /// due cards first, then the weakest cards (most lapses / lowest easiness),
  /// topped up with [fallbackPool] items not yet tracked.
  List<String> buildSession({
    int size = 20,
    List<String> fallbackPool = const [],
  }) {
    final picked = <String>[];
    for (final c in dueCards()) {
      if (picked.length >= size) break;
      picked.add(c.itemId);
    }
    if (picked.length < size) {
      final weak = _cards.values
          .where((c) => !picked.contains(c.itemId))
          .toList()
        ..sort((a, b) {
          final byLapse = b.lapses.compareTo(a.lapses);
          if (byLapse != 0) return byLapse;
          return a.easiness.compareTo(b.easiness);
        });
      for (final c in weak) {
        if (picked.length >= size) break;
        picked.add(c.itemId);
      }
    }
    for (final id in fallbackPool) {
      if (picked.length >= size) break;
      if (!picked.contains(id)) picked.add(id);
    }
    return picked;
  }

  Map<String, dynamic> toJson() =>
      {'cards': _cards.values.map((c) => c.toJson()).toList()};

  void loadJson(Map<String, dynamic> json) {
    _cards.clear();
    for (final c in (json['cards'] as List? ?? const [])) {
      final card = SrsCard.fromJson(Map<String, dynamic>.from(c as Map));
      _cards[card.itemId] = card;
    }
  }
}
