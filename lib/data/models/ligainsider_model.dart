import 'package:freezed_annotation/freezed_annotation.dart';

part 'ligainsider_model.freezed.dart';
part 'ligainsider_model.g.dart';

/// Ligainsider Player Model - Verletzungen & Form von ligainsider.de
@freezed
class LigainsiderPlayer with _$LigainsiderPlayer {
  const factory LigainsiderPlayer({
    required String id,
    required String name,
    required String shortName,
    required String teamName,
    required String teamId,
    required int position,
    required String injury_status,
    String? injury_description,
    int? form_rating,
    required DateTime last_update,
    String? status_text,
    DateTime? expected_return,
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
  const factory LigainsiderResponse({
    required List<LigainsiderPlayer> players,
    required DateTime last_update,
    int? total_injured,
    int? total_questionable,
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
