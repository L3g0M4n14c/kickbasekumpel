import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kickbasekumpel/data/repositories/firestore_repositories.dart';
import '../../helpers/matchers.dart';
import '../../helpers/test_data.dart';
import '../../helpers/result_extension.dart';

void main() {
  group('PlayerRepository', () {
    late FakeFirebaseFirestore fakeFirestore;
    late PlayerRepository repository;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      repository = PlayerRepository(firestore: fakeFirestore);
    });

    group('getByTeam', () {
      test('returns all players from specific team', () async {
        // Arrange
        final player1 = TestData.createTestPlayer(
          id: 'player-1',
          teamName: 'Bayern München',
        );
        final player2 = TestData.createTestPlayer(
          id: 'player-2',
          teamName: 'Bayern München',
        );
        final player3 = TestData.createTestPlayer(
          id: 'player-3',
          teamName: 'Borussia Dortmund',
        );

        final player1Data = repository.toFirestore(player1);
        player1Data['teamId'] = 'team-bayern';
        final player2Data = repository.toFirestore(player2);
        player2Data['teamId'] = 'team-bayern';
        final player3Data = repository.toFirestore(player3);
        player3Data['teamId'] = 'team-dortmund';

        await fakeFirestore
            .collection('players')
            .doc('player-1')
            .set(player1Data);
        await fakeFirestore
            .collection('players')
            .doc('player-2')
            .set(player2Data);
        await fakeFirestore
            .collection('players')
            .doc('player-3')
            .set(player3Data);

        // Act
        final result = await repository.getByTeam('team-bayern');

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) {
            expect(data, hasLength(2));
            expect(data.every((p) => p.teamId == 'team-bayern'), isTrue);
          },
          failure: (_) => fail('Should not fail'),
        );
      });
    });

    group('getByPosition', () {
      test('returns all players at specific position', () async {
        // Arrange
        final player1 = TestData.createTestPlayer(
          id: 'player-1',
          position: 1,
        ); // Torwart
        final player2 = TestData.createTestPlayer(
          id: 'player-2',
          position: 2,
        ); // Abwehr
        final player3 = TestData.createTestPlayer(
          id: 'player-3',
          position: 1,
        ); // Torwart

        await fakeFirestore
            .collection('players')
            .doc('player-1')
            .set(repository.toFirestore(player1));
        await fakeFirestore
            .collection('players')
            .doc('player-2')
            .set(repository.toFirestore(player2));
        await fakeFirestore
            .collection('players')
            .doc('player-3')
            .set(repository.toFirestore(player3));

        // Act
        final result = await repository.getByPosition(1);

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) {
            expect(data, hasLength(2));
            expect(data.every((p) => p.position == 1), isTrue);
          },
          failure: (_) => fail('Should not fail'),
        );
      });
    });

    group('searchByName', () {
      test('returns players matching search query', () async {
        // Arrange
        final player1 = TestData.createTestPlayer(
          id: 'player-1',
          firstName: 'Thomas',
          lastName: 'Müller',
        );
        final player2 = TestData.createTestPlayer(
          id: 'player-2',
          firstName: 'Thomas',
          lastName: 'Schmidt',
        );
        final player3 = TestData.createTestPlayer(
          id: 'player-3',
          firstName: 'Manuel',
          lastName: 'Neuer',
        );

        await fakeFirestore.collection('players').doc('player-1').set({
          ...repository.toFirestore(player1),
          'searchName':
              '${player1.firstName.toLowerCase()} ${player1.lastName.toLowerCase()}',
        });
        await fakeFirestore.collection('players').doc('player-2').set({
          ...repository.toFirestore(player2),
          'searchName':
              '${player2.firstName.toLowerCase()} ${player2.lastName.toLowerCase()}',
        });
        await fakeFirestore.collection('players').doc('player-3').set({
          ...repository.toFirestore(player3),
          'searchName':
              '${player3.firstName.toLowerCase()} ${player3.lastName.toLowerCase()}',
        });

        // Act
        final result = await repository.searchByName('Thomas');

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) {
            expect(data.length, greaterThanOrEqualTo(1));
          },
          failure: (_) => fail('Should not fail'),
        );
      });
    });

    group('getTopPlayers', () {
      test('returns top players by average points', () async {
        // Arrange
        final player1 = TestData.createTestPlayer(id: 'player-1');
        final player2 = TestData.createTestPlayer(id: 'player-2');
        final player3 = TestData.createTestPlayer(id: 'player-3');

        final player1Data = repository.toFirestore(player1);
        player1Data['averagePoints'] = 9.5;
        final player2Data = repository.toFirestore(player2);
        player2Data['averagePoints'] = 8.0;
        final player3Data = repository.toFirestore(player3);
        player3Data['averagePoints'] = 7.5;

        await fakeFirestore
            .collection('players')
            .doc('player-1')
            .set(player1Data);
        await fakeFirestore
            .collection('players')
            .doc('player-2')
            .set(player2Data);
        await fakeFirestore
            .collection('players')
            .doc('player-3')
            .set(player3Data);

        // Act
        final result = await repository.getTopPlayers(
          limit: 10,
          orderBy: 'averagePoints',
        );

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) {
            expect(data, hasLength(3));
            // Top player should be first
            expect(
              data[0].averagePoints,
              greaterThanOrEqualTo(data[1].averagePoints),
            );
          },
          failure: (_) => fail('Should not fail'),
        );
      });

      test('limits result count', () async {
        // Arrange
        for (int i = 0; i < 20; i++) {
          final player = TestData.createTestPlayer(id: 'player-$i');
          await fakeFirestore
              .collection('players')
              .doc('player-$i')
              .set(repository.toFirestore(player));
        }

        // Act
        final result = await repository.getTopPlayers(limit: 5);

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) => expect(data.length, lessThanOrEqualTo(5)),
          failure: (_) => fail('Should not fail'),
        );
      });
    });

    group('filterPlayers', () {
      test('filters by position', () async {
        // Arrange
        final player1 = TestData.createTestPlayer(id: 'player-1', position: 1);
        final player2 = TestData.createTestPlayer(id: 'player-2', position: 2);
        final player3 = TestData.createTestPlayer(id: 'player-3', position: 1);

        await fakeFirestore
            .collection('players')
            .doc('player-1')
            .set(repository.toFirestore(player1));
        await fakeFirestore
            .collection('players')
            .doc('player-2')
            .set(repository.toFirestore(player2));
        await fakeFirestore
            .collection('players')
            .doc('player-3')
            .set(repository.toFirestore(player3));

        // Act
        final result = await repository.filterPlayers(position: 1);

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) {
            expect(data, hasLength(2));
            expect(data.every((p) => p.position == 1), isTrue);
          },
          failure: (_) => fail('Should not fail'),
        );
      });

      test('filters by team', () async {
        // Arrange
        final player1 = TestData.createTestPlayer(id: 'player-1');
        final player2 = TestData.createTestPlayer(id: 'player-2');

        final player1Data = repository.toFirestore(player1);
        player1Data['teamId'] = 'team-bayern';
        final player2Data = repository.toFirestore(player2);
        player2Data['teamId'] = 'team-dortmund';

        await fakeFirestore
            .collection('players')
            .doc('player-1')
            .set(player1Data);
        await fakeFirestore
            .collection('players')
            .doc('player-2')
            .set(player2Data);

        // Act
        final result = await repository.filterPlayers(teamId: 'team-bayern');

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) {
            expect(data, hasLength(1));
            expect(data[0].teamId, 'team-bayern');
          },
          failure: (_) => fail('Should not fail'),
        );
      });

      test('filters by market value range', () async {
        // Arrange
        final player1 = TestData.createTestPlayer(
          id: 'player-1',
          marketValue: 10000000,
        );
        final player2 = TestData.createTestPlayer(
          id: 'player-2',
          marketValue: 20000000,
        );
        final player3 = TestData.createTestPlayer(
          id: 'player-3',
          marketValue: 30000000,
        );

        await fakeFirestore
            .collection('players')
            .doc('player-1')
            .set(repository.toFirestore(player1));
        await fakeFirestore
            .collection('players')
            .doc('player-2')
            .set(repository.toFirestore(player2));
        await fakeFirestore
            .collection('players')
            .doc('player-3')
            .set(repository.toFirestore(player3));

        // Act
        final result = await repository.filterPlayers(
          minMarketValue: 15000000,
          maxMarketValue: 25000000,
        );

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) {
            expect(data, hasLength(1));
            expect(data[0].marketValue, 20000000);
          },
          failure: (_) => fail('Should not fail'),
        );
      });
    });

    group('updateMarketValue', () {
      test('successfully updates player market value', () async {
        // Arrange
        final player = TestData.createTestPlayer(
          id: 'player-1',
          marketValue: 15000000,
        );
        await fakeFirestore
            .collection('players')
            .doc('player-1')
            .set(repository.toFirestore(player));

        // Act
        final result = await repository.updateMarketValue(
          playerId: 'player-1',
          newMarketValue: 20000000,
          trend: 1, // Aufwärtstrend
        );

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) {
            expect(data.marketValue, 20000000);
            expect(data.marketValueTrend, 1);
          },
          failure: (_) => fail('Should not fail'),
        );
      });
    });

    group('batchUpdate', () {
      test('updates multiple players at once', () async {
        // Arrange
        final player1 = TestData.createTestPlayer(id: 'player-1');
        final player2 = TestData.createTestPlayer(id: 'player-2');
        await fakeFirestore
            .collection('players')
            .doc('player-1')
            .set(repository.toFirestore(player1));
        await fakeFirestore
            .collection('players')
            .doc('player-2')
            .set(repository.toFirestore(player2));

        final updatedPlayer1 = TestData.createTestPlayer(
          id: 'player-1',
          marketValue: 25000000,
        );
        final updatedPlayer2 = TestData.createTestPlayer(
          id: 'player-2',
          marketValue: 18000000,
        );

        // Act
        final result = await repository.batchUpdate([
          updatedPlayer1,
          updatedPlayer2,
        ]);

        // Assert
        expect(result, ResultMatchers.isSuccess());

        // Verify updates
        final doc1 = await fakeFirestore
            .collection('players')
            .doc('player-1')
            .get();
        final doc2 = await fakeFirestore
            .collection('players')
            .doc('player-2')
            .get();
        expect(doc1.data()!['marketValue'], 25000000);
        expect(doc2.data()!['marketValue'], 18000000);
      });
    });

    group('fromFirestore and toFirestore', () {
      test('correctly serializes and deserializes player', () async {
        // Arrange
        final player = TestData.createTestPlayer(
          id: 'player-1',
          firstName: 'Max',
          lastName: 'Mustermann',
          position: 1,
          marketValue: 15000000,
        );

        // Act
        final json = repository.toFirestore(player);
        await fakeFirestore.collection('players').doc('player-1').set(json);
        final doc = await fakeFirestore
            .collection('players')
            .doc('player-1')
            .get();
        final deserialized = repository.fromFirestore(doc);

        // Assert
        expect(deserialized.id, player.id);
        expect(deserialized.firstName, player.firstName);
        expect(deserialized.lastName, player.lastName);
        expect(deserialized.position, player.position);
        expect(deserialized.marketValue, player.marketValue);
      });
    });
  });
}
