import 'package:freezed_annotation/freezed_annotation.dart';

part 'ligainsider_model.freezed.dart';
part 'ligainsider_model.g.dart';

/// Ligainsider Player Model - Verletzungen & Form von ligainsider.de
@freezed
class LigainsiderPlayer with _$LigainsiderPlayer {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory LigainsiderPlayer({
    required String id,
    required String name,
    required String shortName,
    required String teamName,
    required String teamId,
    required int position,
    required String injuryStatus,
    String? injuryDescription,
    int? formRating,
    required DateTime lastUpdate,
    String? statusText,
    DateTime? expectedReturn,
    String? alternative, // Name der Alternative (für Lineup-Status)
    String? ligainsiderId, // Ligainsider ID (z.B. "nikola-vasilj_13866")
    String? imageUrl, // URL zum Profilbild
  }) = _LigainsiderPlayer;

  factory LigainsiderPlayer.fromJson(Map<String, dynamic> json) =>
      _$LigainsiderPlayerFromJson(json);
}

/// Injury Status Enum
class InjuryStatus {
  static const String fit = 'fit';
  static const String questionable = 'fraglich';
  static const String doubtful = 'doubtful';
  static const String outRisk = 'ausfallrisiko';
  static const String out = 'verletzt';
  static const String unknown = 'unknown';
}

/// Form Rating Enum
class FormRating {
  static const int excellent = 5;
  static const int good = 4;
  static const int average = 3;
  static const int poor = 2;
  static const int veryPoor = 1;
  static const int unknown = 0;
}

/// Ligainsider Player Status - Status Übersicht
@freezed
class LigainsiderStatus with _$LigainsiderStatus {
  const factory LigainsiderStatus({
    required String playerId,
    required String playerName,
    required String statusCategory,
    required String statusReason,
    required DateTime lastUpdate,
  }) = _LigainsiderStatus;

  factory LigainsiderStatus.fromJson(Map<String, dynamic> json) =>
      _$LigainsiderStatusFromJson(json);
}

/// Ligainsider Response - Liste von Spielern mit Status
@freezed
class LigainsiderResponse with _$LigainsiderResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory LigainsiderResponse({
    required List<LigainsiderPlayer> players,
    required DateTime lastUpdate,
    int? totalInjured,
    int? totalQuestionable,
  }) = _LigainsiderResponse;

  factory LigainsiderResponse.fromJson(Map<String, dynamic> json) =>
      _$LigainsiderResponseFromJson(json);
}

/// Injury Report - Detaillierter Verletzungsbericht
@freezed
class InjuryReport with _$InjuryReport {
  const factory InjuryReport({
    required String playerId,
    required String playerName,
    required String injuryType,
    required String severity,
    required DateTime injuryDate,
    DateTime? expectedReturnDate,
    required String source,
    required String status,
  }) = _InjuryReport;

  factory InjuryReport.fromJson(Map<String, dynamic> json) =>
      _$InjuryReportFromJson(json);
}

/// Ligainsider Player Status Enum
enum LigainsiderPlayerStatus {
  likelyStart, // S11 ohne Alternative
  startWithAlternative, // S11 mit Alternative (1. Option)
  isAlternative, // Ist die Alternative (2. Option)
  bench, // Auf der Bank / im Kader aber nicht in S11
  out, // Nicht im Kader / nicht gefunden
}

/// Extension to get icon and color for status
extension LigainsiderPlayerStatusExtension on LigainsiderPlayerStatus {
  String get icon {
    switch (this) {
      case LigainsiderPlayerStatus.likelyStart:
        return '✓';
      case LigainsiderPlayerStatus.startWithAlternative:
        return '1';
      case LigainsiderPlayerStatus.isAlternative:
        return '2';
      case LigainsiderPlayerStatus.bench:
        return '−';
      case LigainsiderPlayerStatus.out:
        return '✗';
    }
  }

  String get description {
    switch (this) {
      case LigainsiderPlayerStatus.likelyStart:
        return 'Wahrscheinlich in Startelf';
      case LigainsiderPlayerStatus.startWithAlternative:
        return 'In Startelf mit Alternative';
      case LigainsiderPlayerStatus.isAlternative:
        return 'Alternative';
      case LigainsiderPlayerStatus.bench:
        return 'Auf der Bank';
      case LigainsiderPlayerStatus.out:
        return 'Nicht im Kader';
    }
  }
}
