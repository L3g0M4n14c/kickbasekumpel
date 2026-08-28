import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:kickbasekumpel/data/models/ligainsider_model.dart';
import 'package:kickbasekumpel/data/models/player_model.dart';
import 'package:kickbasekumpel/data/services/mistral_recommendation_service.dart';
import 'package:kickbasekumpel/domain/repositories/repository_interfaces.dart';

void main() {
  group('MistralRecommendationService', () {
    late MistralRecommendationService service;

    setUp(() {
      service = MistralRecommendationService();
    });

    test(
      'returns local strong-sell recommendation for injured player',
      () async {
        final result = await service.generateRecommendation(
          player: _buildPlayer(status: 1),
        );

        expect(result, isA<Success<MistralRecommendationResult>>());

        final recommendation =
            (result as Success<MistralRecommendationResult>).data;
        expect(recommendation.action, 'strong-sell');
        expect(recommendation.category, 'strong-sell');
        expect(recommendation.reason, contains('verletzt'));
        expect(recommendation.reason, contains('lokal ohne Mistral'));
      },
    );

    test('logs the single-player prompt before calling the proxy', () async {
      final debugLogs = <String>[];

      service = MistralRecommendationService(
        debugLogger: debugLogs.add,
        postRequest: (uri, {headers, body, encoding}) async {
          return http.Response(
            jsonEncode({
              'score': 72,
              'action': 'buy',
              'reason': 'Ø 7,4 Punkte in den letzten drei Spielen.',
              'confidence': 0.84,
              'estimatedValue': 13000000,
              'category': 'buy',
            }),
            200,
          );
        },
      );

      final result = await service.generateRecommendation(
        player: _buildPlayer(status: 0),
      );

      expect(result, isA<Success<MistralRecommendationResult>>());
      expect(
        debugLogs,
        contains('📝 MISTRAL PROMPT [single Max Mustermann] START'),
      );
      expect(
        debugLogs,
        contains('📝 MISTRAL PROMPT [single Max Mustermann] END'),
      );
      expect(
        debugLogs.any(
          (message) =>
              message.contains('=== SPIELER-STAMMDATEN ===') &&
              message.contains('Name: Max Mustermann'),
        ),
        isTrue,
      );
    });

    test(
      'returns local strong-sell recommendation when Ligainsider marks absence',
      () async {
        final result = await service.generateRecommendation(
          player: _buildPlayer(status: 0),
          ligainsiderData: _buildLigainsiderPlayer(statusText: 'Abwesend'),
        );

        expect(result, isA<Success<MistralRecommendationResult>>());

        final recommendation =
            (result as Success<MistralRecommendationResult>).data;
        expect(recommendation.action, 'strong-sell');
        expect(recommendation.reason, contains('abwesend'));
      },
    );

    test(
      'returns only local recommendations in batch for unavailable players',
      () async {
        final result = await service.generateBatchRecommendations(
          players: [
            PlayerAnalysisInput(player: _buildPlayer(id: 'injured', status: 1)),
            PlayerAnalysisInput(
              player: _buildPlayer(id: 'suspended', status: 32),
            ),
            PlayerAnalysisInput(
              player: _buildPlayer(id: 'absent', status: 256),
            ),
          ],
        );

        expect(
          result,
          isA<Success<Map<String, MistralRecommendationResult>>>(),
        );

        final recommendations =
            (result as Success<Map<String, MistralRecommendationResult>>).data;
        expect(
          recommendations.keys,
          containsAll(['injured', 'suspended', 'absent']),
        );
        expect(recommendations['injured']!.reason, contains('verletzt'));
        expect(recommendations['suspended']!.reason, contains('gesperrt'));
        expect(recommendations['absent']!.reason, contains('abwesend'));
      },
    );

    test(
      'excludes local shortcuts from batch prompt and reuses cached results',
      () async {
        final prompts = <String>[];
        var requestCount = 0;

        service = MistralRecommendationService(
          postRequest: (uri, {headers, body, encoding}) async {
            requestCount++;

            final payload = jsonDecode(body! as String) as Map<String, dynamic>;
            prompts.add(payload['prompt'] as String);

            return http.Response(
              jsonEncode({
                'fit-player': {
                  'score': 72,
                  'action': 'buy',
                  'reason': 'Ø 7,4 Punkte in den letzten drei Spielen.',
                  'confidence': 0.84,
                  'estimatedValue': 13000000,
                  'category': 'buy',
                },
              }),
              200,
            );
          },
        );

        final inputs = [
          PlayerAnalysisInput(
            player: _buildPlayer(id: 'local-player', status: 1),
          ),
          PlayerAnalysisInput(
            player: _buildPlayer(
              id: 'fit-player',
              status: 0,
              userOwnsPlayer: false,
            ),
            fixtureContext:
                'Spieltag 28: vs Team A\n'
                'Spieltag 29: @ Team B\n'
                'Spieltag 30: vs Team C',
            nextOpponent: 'Team A',
            nextOpponentTablePosition: 4,
            ownTeamTablePosition: 11,
            nextMatchLocation: 'Heimspiel',
          ),
        ];

        final firstResult = await service.generateBatchRecommendations(
          players: inputs,
        );

        expect(
          firstResult,
          isA<Success<Map<String, MistralRecommendationResult>>>(),
        );

        final firstRecommendations =
            (firstResult as Success<Map<String, MistralRecommendationResult>>)
                .data;
        expect(
          firstRecommendations.keys,
          containsAll(['local-player', 'fit-player']),
        );
        expect(
          firstRecommendations['local-player']!.reason,
          contains('lokal ohne Mistral'),
        );
        expect(firstRecommendations['fit-player']!.action, 'buy');
        expect(requestCount, 1);

        final prompt = prompts.single;
        expect(prompt, contains('"fit-player":{"name":"Max Mustermann"'));
        expect(prompt, isNot(contains('"local-player":{')));
        expect(prompt, isNot(contains('"id":"fit-player"')));
        expect(prompt, isNot(contains('"position":')));
        expect(prompt, isNot(contains('"marketValueTrend":')));
        expect(prompt, isNot(contains('"tfhmvt":')));
        expect(prompt, isNot(contains('"stl":')));
        expect(prompt, isNot(contains('"status":')));
        expect(prompt, contains('"nextOpponent":"Team A"'));
        expect(prompt, contains('"nextOpponentTablePosition":4'));
        expect(prompt, contains('"ownTeamTablePosition":11'));
        expect(prompt, contains('"nextMatchLocation":"Heimspiel"'));
        expect(
          prompt,
          contains('Spieltag 28: vs Team A | Spieltag 29: @ Team B'),
        );
        expect(prompt, isNot(contains('Spieltag 30: vs Team C')));

        final secondResult = await service.generateBatchRecommendations(
          players: inputs,
        );

        expect(
          secondResult,
          isA<Success<Map<String, MistralRecommendationResult>>>(),
        );
        expect(requestCount, 1);
      },
    );

    test(
      'parses batch response when reason contains raw newline characters',
      () async {
        service = MistralRecommendationService(
          postRequest: (uri, {headers, body, encoding}) async {
            return http.Response('''
{
  "fit-player": {
    "score": 72,
    "action": "buy",
    "reason": "Mittelfeld mit Ø 10,2 Punkten
und starkem Trend.",
    "confidence": 0.84,
    "estimatedValue": 13000000,
    "category": "buy"
  }
}
''', 200);
          },
        );

        final result = await service.generateBatchRecommendations(
          players: [
            PlayerAnalysisInput(
              player: _buildPlayer(id: 'fit-player', status: 0),
            ),
          ],
        );

        expect(
          result,
          isA<Success<Map<String, MistralRecommendationResult>>>(),
        );

        final recommendations =
            (result as Success<Map<String, MistralRecommendationResult>>).data;
        expect(recommendations['fit-player']!.action, 'buy');
        expect(
          recommendations['fit-player']!.reason,
          contains('Mittelfeld mit Ø 10,2 Punkten\nund starkem Trend.'),
        );
      },
    );

    test(
      'parses batch response when reason starts on next line and contains quotes',
      () async {
        service = MistralRecommendationService(
          postRequest: (uri, {headers, body, encoding}) async {
            return http.Response('''
{
  "2988": {
    "score": 80,
    "action": "strong-buy",
    "reason": "
Starker Trend trotz "angeschlagener" Konkurrenz
und sicherem Stammplatz.",
    "confidence": 0.91,
    "estimatedValue": 15000000,
    "category": "strong-buy"
  }
}
''', 200);
          },
        );

        final result = await service.generateBatchRecommendations(
          players: [
            PlayerAnalysisInput(player: _buildPlayer(id: '2988', status: 0)),
          ],
        );

        expect(
          result,
          isA<Success<Map<String, MistralRecommendationResult>>>(),
        );

        final recommendations =
            (result as Success<Map<String, MistralRecommendationResult>>).data;
        expect(recommendations['2988']!.action, 'strong-buy');
        expect(
          recommendations['2988']!.reason,
          contains(
            '\nStarker Trend trotz "angeschlagener" Konkurrenz\nund sicherem Stammplatz.',
          ),
        );
      },
    );

    test('parses batch response without confidence field', () async {
      service = MistralRecommendationService(
        postRequest: (uri, {headers, body, encoding}) async {
          return http.Response(
            jsonEncode({
              'fit-player': {
                'score': 72,
                'action': 'buy',
                'reason': 'Ø 7,4 Punkte in den letzten drei Spielen.',
                'estimatedValue': 13000000,
                'category': 'buy',
              },
            }),
            200,
          );
        },
      );

      final result = await service.generateBatchRecommendations(
        players: [
          PlayerAnalysisInput(
            player: _buildPlayer(id: 'fit-player', status: 0),
          ),
        ],
      );

      expect(result, isA<Success<Map<String, MistralRecommendationResult>>>());

      final recommendations =
          (result as Success<Map<String, MistralRecommendationResult>>).data;
      expect(recommendations['fit-player']!.action, 'buy');
      expect(recommendations['fit-player']!.confidence, 0.5);
    });

    test(
      'splits uncached batch requests into chunks of at most 10 players and merges results',
      () async {
        final prompts = <String>[];

        service = MistralRecommendationService(
          postRequest: (uri, {headers, body, encoding}) async {
            final payload = jsonDecode(body! as String) as Map<String, dynamic>;
            final prompt = payload['prompt'] as String;
            prompts.add(prompt);
            final ids = _extractPlayerIdsFromPrompt(prompt);

            return http.Response(
              jsonEncode({
                for (final id in ids)
                  id: {
                    'score': 60 + ids.indexOf(id),
                    'action': 'buy',
                    'reason': 'Batch-Ergebnis für $id',
                    'confidence': 0.8,
                    'estimatedValue': 10000000 + ids.indexOf(id),
                    'category': 'buy',
                  },
              }),
              200,
            );
          },
        );

        final players = List<PlayerAnalysisInput>.generate(
          12,
          (index) => PlayerAnalysisInput(
            player: _buildPlayer(
              id: 'player-$index',
              status: 0,
              userOwnsPlayer: index.isEven,
            ),
          ),
        );

        final result = await service.generateBatchRecommendations(
          players: players,
        );

        expect(
          result,
          isA<Success<Map<String, MistralRecommendationResult>>>(),
        );

        final recommendations =
            (result as Success<Map<String, MistralRecommendationResult>>).data;
        expect(recommendations, hasLength(12));
        expect(prompts, hasLength(2));
        expect(
          prompts.every(
            (prompt) => _extractPlayerIdsFromPrompt(prompt).length <= 10,
          ),
          isTrue,
        );
        expect(
          recommendations['player-0']!.reason,
          'Batch-Ergebnis für player-0',
        );
        expect(
          recommendations['player-11']!.reason,
          'Batch-Ergebnis für player-11',
        );
      },
    );

    test(
      'batches only uncached players when cached and local shortcut players are present',
      () async {
        final prompts = <String>[];
        var requestCount = 0;

        service = MistralRecommendationService(
          postRequest: (uri, {headers, body, encoding}) async {
            requestCount++;

            final payload = jsonDecode(body! as String) as Map<String, dynamic>;
            final prompt = payload['prompt'] as String;
            prompts.add(prompt);
            final ids = _extractPlayerIdsFromPrompt(prompt);

            return http.Response(
              jsonEncode({
                for (final id in ids)
                  id: {
                    'score': 70 + ids.indexOf(id),
                    'action': 'buy',
                    'reason': 'Batch-Ergebnis für $id',
                    'confidence': 0.8,
                    'estimatedValue': 10000000 + ids.indexOf(id),
                    'category': 'buy',
                  },
              }),
              200,
            );
          },
        );

        final cachedPlayer = PlayerAnalysisInput(
          player: _buildPlayer(id: 'cached-player', status: 0),
        );

        final primingResult = await service.generateBatchRecommendations(
          players: [cachedPlayer],
        );
        expect(
          primingResult,
          isA<Success<Map<String, MistralRecommendationResult>>>(),
        );

        prompts.clear();
        requestCount = 0;

        final freshPlayers = List<PlayerAnalysisInput>.generate(
          11,
          (index) => PlayerAnalysisInput(
            player: _buildPlayer(id: 'fresh-player-$index', status: 0),
          ),
        );
        final inputs = [
          PlayerAnalysisInput(
            player: _buildPlayer(id: 'local-player', status: 1),
          ),
          cachedPlayer,
          ...freshPlayers,
        ];

        final result = await service.generateBatchRecommendations(
          players: inputs,
        );

        expect(
          result,
          isA<Success<Map<String, MistralRecommendationResult>>>(),
        );

        final recommendations =
            (result as Success<Map<String, MistralRecommendationResult>>).data;
        final batchedIds = prompts.expand(_extractPlayerIdsFromPrompt).toList();

        expect(recommendations, hasLength(13));
        expect(requestCount, 2);
        expect(
          prompts.every(
            (prompt) => _extractPlayerIdsFromPrompt(prompt).length <= 10,
          ),
          isTrue,
        );
        expect(batchedIds, hasLength(11));
        expect(
          batchedIds,
          containsAll([for (final input in freshPlayers) input.player.id]),
        );
        expect(batchedIds, isNot(contains('cached-player')));
        expect(batchedIds, isNot(contains('local-player')));
        expect(
          recommendations['local-player']!.reason,
          contains('lokal ohne Mistral'),
        );
        expect(
          recommendations['cached-player']!.reason,
          'Batch-Ergebnis für cached-player',
        );
        expect(
          recommendations['fresh-player-10']!.reason,
          'Batch-Ergebnis für fresh-player-10',
        );
      },
    );

    test(
      'keeps complete batch entries when response ends unexpectedly',
      () async {
        service = MistralRecommendationService(
          postRequest: (uri, {headers, body, encoding}) async {
            return http.Response('''
{
  "fit-player": {
    "score": 72,
    "action": "buy",
    "reason": "Ø 7,4 Punkte in den letzten drei Spielen.",
    "confidence": 0.84,
    "estimatedValue": 13000000,
    "category": "buy"
  },
  "broken-player": {
    "score": 41,
    "action": "hold",
    "reason": "Marktwert stabil, aber Analyse abgeschnitten.",
    "confidence": 0.61,
    "estimatedValue": 27052460,''', 200);
          },
        );

        final result = await service.generateBatchRecommendations(
          players: [
            PlayerAnalysisInput(
              player: _buildPlayer(id: 'fit-player', status: 0),
            ),
            PlayerAnalysisInput(
              player: _buildPlayer(id: 'broken-player', status: 0),
            ),
          ],
        );

        expect(
          result,
          isA<Success<Map<String, MistralRecommendationResult>>>(),
        );

        final recommendations =
            (result as Success<Map<String, MistralRecommendationResult>>).data;
        expect(recommendations.keys, contains('fit-player'));
        expect(recommendations.keys, isNot(contains('broken-player')));
        expect(recommendations['fit-player']!.action, 'buy');
      },
    );
  });
}

Player _buildPlayer({
  String id = 'player-1',
  int status = 0,
  bool userOwnsPlayer = true,
}) {
  return Player(
    id: id,
    firstName: 'Max',
    lastName: 'Mustermann',
    profileBigUrl: 'https://example.com/player.png',
    teamName: 'FC Test',
    teamId: 'team-1',
    position: 3,
    number: 10,
    averagePoints: 5.5,
    totalPoints: 88,
    marketValue: 12000000,
    marketValueTrend: 1,
    tfhmvt: 250000,
    prlo: 0,
    stl: 3,
    status: status,
    userOwnsPlayer: userOwnsPlayer,
  );
}

LigainsiderPlayer _buildLigainsiderPlayer({String? statusText}) {
  return LigainsiderPlayer(
    id: 'player-1',
    name: 'Max Mustermann',
    shortName: 'M. Mustermann',
    teamName: 'FC Test',
    teamId: 'team-1',
    position: 3,
    injuryStatus: InjuryStatus.fit,
    lastUpdate: DateTime(2026, 2, 1),
    statusText: statusText,
  );
}

List<String> _extractPlayerIdsFromPrompt(String prompt) {
  final playerData = _extractPlayerDataFromPrompt(prompt);
  return playerData.keys.toList();
}

Map<String, dynamic> _extractPlayerDataFromPrompt(String prompt) {
  const marker = '=== SPIELER-DATEN (als Objekt nach Spieler-ID) ===';
  final markerIndex = prompt.indexOf(marker);
  if (markerIndex == -1) {
    return const {};
  }

  final jsonStart = prompt.indexOf('{', markerIndex);
  final jsonEndMarker = '\n\nAnalysiere JEDEN Spieler individuell';
  final jsonEnd = prompt.indexOf(jsonEndMarker, jsonStart);
  if (jsonStart == -1 || jsonEnd == -1) {
    return const {};
  }

  return Map<String, dynamic>.from(
    jsonDecode(prompt.substring(jsonStart, jsonEnd)) as Map<String, dynamic>,
  );
}
