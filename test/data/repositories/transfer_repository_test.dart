import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kickbasekumpel/data/repositories/firestore_repositories.dart';
import '../../helpers/matchers.dart';
import '../../helpers/test_data.dart';
import '../../helpers/result_extension.dart';
import '../../helpers/mock_firebase.dart';

void main() {
  group('TransferRepository', () {
    late FakeFirebaseFirestore fakeFirestore;
    late MockKickbaseAPIClient mockApiClient;
    late TransferRepository repository;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      mockApiClient = MockKickbaseAPIClient();
      repository = TransferRepository(
        firestore: fakeFirestore,
        apiClient: mockApiClient,
      );
    });

    group('getByLeague', () {
      test('returns all transfers for specific league', () async {
        // Arrange
        final transfer1 = TestData.createTestTransfer(
          id: 'transfer-1',
          leagueId: 'league-1',
        );
        final transfer2 = TestData.createTestTransfer(
          id: 'transfer-2',
          leagueId: 'league-1',
        );
        final transfer3 = TestData.createTestTransfer(
          id: 'transfer-3',
          leagueId: 'league-2',
        );

        await fakeFirestore
            .collection('transfers')
            .doc('transfer-1')
            .set(repository.toFirestore(transfer1));
        await fakeFirestore
            .collection('transfers')
            .doc('transfer-2')
            .set(repository.toFirestore(transfer2));
        await fakeFirestore
            .collection('transfers')
            .doc('transfer-3')
            .set(repository.toFirestore(transfer3));

        // Act
        final result = await repository.getByLeague('league-1');

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) {
            expect(data, hasLength(2));
            expect(data.every((t) => t.leagueId == 'league-1'), isTrue);
          },
          failure: (_) => fail('Should not fail'),
        );
      });
    });

    group('getByUser', () {
      test('returns transfers where user is involved', () async {
        // Arrange
        final transfer1 = TestData.createTestTransfer(
          id: 'transfer-1',
          fromUserId: 'user-1',
          toUserId: 'user-2',
        );
        final transfer2 = TestData.createTestTransfer(
          id: 'transfer-2',
          fromUserId: 'user-3',
          toUserId: 'user-1',
        );
        final transfer3 = TestData.createTestTransfer(
          id: 'transfer-3',
          fromUserId: 'user-2',
          toUserId: 'user-3',
        );

        await fakeFirestore
            .collection('transfers')
            .doc('transfer-1')
            .set(repository.toFirestore(transfer1));
        await fakeFirestore
            .collection('transfers')
            .doc('transfer-2')
            .set(repository.toFirestore(transfer2));
        await fakeFirestore
            .collection('transfers')
            .doc('transfer-3')
            .set(repository.toFirestore(transfer3));

        // Act
        final result = await repository.getByUser('user-1');

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) {
            expect(data, hasLength(2));
            expect(
              data.every(
                (t) => t.fromUserId == 'user-1' || t.toUserId == 'user-1',
              ),
              isTrue,
            );
          },
          failure: (_) => fail('Should not fail'),
        );
      });
    });

    group('getByPlayer', () {
      test('returns all transfers for specific player', () async {
        // Arrange
        final transfer1 = TestData.createTestTransfer(
          id: 'transfer-1',
          playerId: 'player-123',
        );
        final transfer2 = TestData.createTestTransfer(
          id: 'transfer-2',
          playerId: 'player-123',
        );
        final transfer3 = TestData.createTestTransfer(
          id: 'transfer-3',
          playerId: 'player-456',
        );

        await fakeFirestore
            .collection('transfers')
            .doc('transfer-1')
            .set(repository.toFirestore(transfer1));
        await fakeFirestore
            .collection('transfers')
            .doc('transfer-2')
            .set(repository.toFirestore(transfer2));
        await fakeFirestore
            .collection('transfers')
            .doc('transfer-3')
            .set(repository.toFirestore(transfer3));

        // Act
        final result = await repository.getByPlayer('player-123');

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) {
            expect(data, hasLength(2));
            expect(data.every((t) => t.playerId == 'player-123'), isTrue);
          },
          failure: (_) => fail('Should not fail'),
        );
      });
    });

    group('createTransfer', () {
      test('successfully creates transfer', () async {
        // Arrange - Create required documents
        await fakeFirestore.collection('users').doc('user-1').set({
          'name': 'User 1',
          'budget': 20000000,
        });
        await fakeFirestore.collection('users').doc('user-2').set({
          'name': 'User 2',
          'budget': 30000000,
        });
        await fakeFirestore.collection('players').doc('player-123').set({
          'firstName': 'Test',
          'lastName': 'Player',
        });
        await fakeFirestore
            .collection('leagues')
            .doc('league-1')
            .collection('ownedPlayers')
            .doc('player-123')
            .set({'ownerId': 'user-1'});

        // Act
        final result = await repository.createTransfer(
          leagueId: 'league-1',
          fromUserId: 'user-1',
          toUserId: 'user-2',
          playerId: 'player-123',
          price: 15000000,
          marketValue: 14000000,
        );

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) {
            expect(data.leagueId, 'league-1');
            expect(data.fromUserId, 'user-1');
            expect(data.toUserId, 'user-2');
            expect(data.playerId, 'player-123');
            expect(data.price, 15000000);
          },
          failure: (_) => fail('Should not fail'),
        );

        // Verify transfer was created
        final snapshot = await fakeFirestore.collection('transfers').get();
        expect(snapshot.docs, isNotEmpty);
      });
    });

    group('validateTransfer', () {
      test('validates transfer successfully', () async {
        // Arrange - Setup user budgets and player ownership
        final userRepo = UserRepository(
          firestore: fakeFirestore,
          apiClient: mockApiClient,
        );
        final playerRepo = PlayerRepository(
          firestore: fakeFirestore,
          apiClient: mockApiClient,
        );

        final fromUser = TestData.createTestUser(
          id: 'user-1',
          budget: 50000000,
        );
        final toUser = TestData.createTestUser(
          id: 'user-2',
          budget: 20000000, // Not enough budget
        );
        final player = TestData.createTestPlayer(
          id: 'player-123',
          marketValue: 15000000,
        );

        await fakeFirestore
            .collection('users')
            .doc('user-1')
            .set(userRepo.toFirestore(fromUser));
        await fakeFirestore
            .collection('users')
            .doc('user-2')
            .set(userRepo.toFirestore(toUser));
        await fakeFirestore
            .collection('players')
            .doc('player-123')
            .set(playerRepo.toFirestore(player));

        // Act
        final result = await repository.validateTransfer(
          leagueId: 'league-1',
          fromUserId: 'user-1',
          toUserId: 'user-2',
          playerId: 'player-123',
          price: 15000000,
        );

        // Assert - Should succeed (basic validation)
        expect(result, ResultMatchers.isSuccess());
      });
    });

    group('getRecentTransfers', () {
      test('returns recent transfers with limit', () async {
        // Arrange
        for (int i = 0; i < 10; i++) {
          final transfer = TestData.createTestTransfer(
            id: 'transfer-$i',
            leagueId: 'league-1',
          );
          await fakeFirestore
              .collection('transfers')
              .doc('transfer-$i')
              .set(repository.toFirestore(transfer));
        }

        // Act
        final result = await repository.getRecentTransfers(
          leagueId: 'league-1',
          limit: 5,
        );

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) => expect(data.length, lessThanOrEqualTo(5)),
          failure: (_) => fail('Should not fail'),
        );
      });
    });

    group('getTransferStats', () {
      test('returns statistics for league transfers', () async {
        // Arrange
        final transfer1 = TestData.createTestTransfer(
          id: 'transfer-1',
          leagueId: 'league-1',
          price: 10000000,
        );
        final transfer2 = TestData.createTestTransfer(
          id: 'transfer-2',
          leagueId: 'league-1',
          price: 20000000,
        );
        final transfer3 = TestData.createTestTransfer(
          id: 'transfer-3',
          leagueId: 'league-1',
          price: 15000000,
        );

        await fakeFirestore
            .collection('transfers')
            .doc('transfer-1')
            .set(repository.toFirestore(transfer1));
        await fakeFirestore
            .collection('transfers')
            .doc('transfer-2')
            .set(repository.toFirestore(transfer2));
        await fakeFirestore
            .collection('transfers')
            .doc('transfer-3')
            .set(repository.toFirestore(transfer3));

        // Act
        final result = await repository.getTransferStats('league-1');

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) {
            expect(data['totalTransfers'], 3);
            expect(data['totalVolume'], 45000000);
            expect(data['averagePrice'], 15000000);
          },
          failure: (_) => fail('Should not fail'),
        );
      });
    });

    group('updateStatus', () {
      test('successfully updates transfer status', () async {
        // Arrange
        final transfer = TestData.createTestTransfer(id: 'transfer-1');
        await fakeFirestore
            .collection('transfers')
            .doc('transfer-1')
            .set(repository.toFirestore(transfer));

        // Act
        final result = await repository.updateStatus(
          transferId: 'transfer-1',
          status: 'cancelled',
        );

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) => expect(data.status, 'cancelled'),
          failure: (_) => fail('Should not fail'),
        );
      });
    });

    group('fromFirestore and toFirestore', () {
      test('correctly serializes and deserializes transfer', () async {
        // Arrange
        final transfer = TestData.createTestTransfer(
          id: 'transfer-1',
          leagueId: 'league-1',
          fromUserId: 'user-1',
          toUserId: 'user-2',
          playerId: 'player-123',
          price: 15000000,
        );

        // Act
        final json = repository.toFirestore(transfer);
        await fakeFirestore.collection('transfers').doc('transfer-1').set(json);
        final doc = await fakeFirestore
            .collection('transfers')
            .doc('transfer-1')
            .get();
        final deserialized = repository.fromFirestore(doc);

        // Assert
        expect(deserialized.id, transfer.id);
        expect(deserialized.leagueId, transfer.leagueId);
        expect(deserialized.fromUserId, transfer.fromUserId);
        expect(deserialized.toUserId, transfer.toUserId);
        expect(deserialized.playerId, transfer.playerId);
        expect(deserialized.price, transfer.price);
      });
    });
  });
}
