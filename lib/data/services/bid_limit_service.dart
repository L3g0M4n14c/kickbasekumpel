/// Kickbase-„33 %-Regel" für das maximal erlaubte Minus beim Bieten.
///
/// Quelle: Kickbase-Hilfe „Wie weit darf ich ins Minus?"
/// (https://help.kickbase.com/help/wie-weit-darf-ich-ins-minus):
///
/// ```text
/// Untergrenze Kontostand = −⅓ × (Teamwert + min(Kontostand, 0))
/// ```
///
/// Beispiel der Hilfe: Teamwert 100 Mio €, Konto −10 Mio € → Basis 90 Mio €
/// → das Konto darf nicht unter −30 Mio € fallen. Die Hilfe schreibt „33 %",
/// ihr Rechenbeispiel geht aber exakt mit ⅓ auf (90 / 3 = 30), daher ⅓.
///
/// Geprüft wird nicht das einzelne Gebot, sondern der Kontostand „nach
/// Annahme aller Gebote" – alle eigenen offenen Gebote fließen also mit ein.
/// Ein erneutes Gebot auf denselben Spieler ersetzt das alte (Upsert), dessen
/// Betrag wird deshalb nicht doppelt gezählt (siehe [BidLimitService]).
class BidLimit {
  /// Aktueller Kontostand (`b` aus `GET /v4/leagues/{id}/me/budget`).
  final int budget;

  /// Teamwert/Kaderwert = Summe der Marktwerte des eigenen Kaders.
  final int teamValue;

  /// Summe der eigenen offenen Gebote (ohne den Spieler, auf den gerade
  /// geboten wird).
  final int pendingOffers;

  /// Erlaubte Untergrenze des Kontostands (≤ 0).
  final int minBalance;

  /// Höchstes Gebot, das für einen neuen/geänderten Bieter noch erlaubt ist
  /// (nie negativ).
  final int maxBid;

  const BidLimit({
    required this.budget,
    required this.teamValue,
    required this.pendingOffers,
    required this.minBalance,
    required this.maxBid,
  });

  /// Erlaubter Überziehungsrahmen (≥ 0) = −[minBalance].
  int get overdraftAllowance => -minBalance;

  /// Kontostand, wenn alle offenen Gebote angenommen würden.
  int get balanceAfterPendingOffers => budget - pendingOffers;

  /// Kontostand nach Annahme aller offenen Gebote plus [bid].
  int balanceAfterBid(int bid) => balanceAfterPendingOffers - bid;

  /// Ob [bid] innerhalb des erlaubten Rahmens liegt.
  bool allows(int bid) => bid <= maxBid;
}

/// Reine Berechnung der Gebotsgrenze (ohne IO, gut testbar).
class BidLimitService {
  /// Anteil des Teamwerts, um den das Konto überzogen werden darf.
  static const double overdraftRate = 1 / 3;

  const BidLimitService();

  BidLimit calculate({
    required int budget,
    required int teamValue,
    int pendingOffers = 0,
  }) {
    // Ein bereits negativer Kontostand verkleinert die Bemessungsgrundlage
    // (Beispiel der Hilfe: 100 Mio + (−10 Mio)), ein positiver erhöht sie nicht.
    final base = teamValue + (budget < 0 ? budget : 0);
    // ceil auf negativer Zahl = konservativ: lieber 1 € zu wenig Rahmen.
    final minBalance = base > 0 ? (-overdraftRate * base).ceil() : 0;
    final available = budget - pendingOffers - minBalance;
    return BidLimit(
      budget: budget,
      teamValue: teamValue,
      pendingOffers: pendingOffers,
      minBalance: minBalance,
      maxBid: available > 0 ? available : 0,
    );
  }

  /// Summe der eigenen offenen Gebote aus der Marktliste. Der Spieler
  /// [excludePlayerId] wird ausgelassen – ein neues Gebot auf ihn ersetzt das
  /// bestehende.
  int sumOpenOffers(
    Iterable<({String playerId, int? ownOfferPrice})> market, {
    String? excludePlayerId,
  }) {
    var sum = 0;
    for (final entry in market) {
      if (entry.playerId == excludePlayerId) continue;
      sum += entry.ownOfferPrice ?? 0;
    }
    return sum;
  }
}
