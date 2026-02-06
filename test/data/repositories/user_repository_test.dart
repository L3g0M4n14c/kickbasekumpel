import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kickbasekumpel/data/repositories/firestore_repositories.dart';
import '../../helpers/matchers.dart';
import '../../helpers/test_data.dart';
import '../../helpers/result_extension.dart';
import '../../helpers/mock_firebase.dart';

void main() {
  group('UserRepository', () {
    late FakeFirebaseFirestore fakeFirestore;
    late MockKickbaseAPIClient mockApiClient;
    late UserRepository repository;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      mockApiClient = MockKickbaseAPIClient();
      repository = UserRepository(
        firestore: fakeFirestore,
        apiClient: mockApiClient,
      );
    });

    group('getByEmail', () {
      test('returns user when email exists', () async {
        // Arrange
        final user = TestData.createTestUser(
          id: 'user-1',
          email: 'test@example.com',
        );
        await fakeFirestore
            .collection('users')
            .doc('user-1')
            .set(repository.toFirestore(user));

        // Act
        final result = await repository.getByEmail('test@example.com');

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) => expect(data.em, 'test@example.com'),
          failure: (_) => fail('Should not fail'),
        );
      });

      test('returns failure when email does not exist', () async {
        // Act
        final result = await repository.getByEmail('nonexistent@example.com');

        // Assert
        expect(result, ResultMatchers.isFailure());
        expect(result, ResultMatchers.isFailureWith('User not found'));
      });

      test('handles case-insensitive email search', () async {
        // Arrange
        final user = TestData.createTestUser(
          id: 'user-1',
          email: 'test@example.com',
        );
        await fakeFirestore
            .collection('users')
            .doc('user-1')
            .set(repository.toFirestore(user));

        // Act
        final result = await repository.getByEmail('TEST@EXAMPLE.COM');

        // Assert
        expect(result, ResultMatchers.isSuccess());
      });
    });

    group('getByAuthUid', () {
      test('returns user when UID exists', () async {
        // Arrange
        final user = TestData.createTestUser(id: 'auth-uid-123');
        await fakeFirestore
            .collection('users')
            .doc('auth-uid-123')
            .set(repository.toFirestore(user));

        // Act
        final result = await repository.getByAuthUid('auth-uid-123');

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) => expect(data.i, 'auth-uid-123'),
          failure: (_) => fail('Should not fail'),
        );
      });

      test('returns failure when UID does not exist', () async {
        // Act
        final result = await repository.getByAuthUid('non-existent-uid');

        // Assert
        expect(result, ResultMatchers.isFailure());
      });
    });

    group('updateProfile', () {
      test('updates user name', () async {
        // Arrange
        final user = TestData.createTestUser(id: 'user-1', name: 'Old Name');
        await fakeFirestore
            .collection('users')
            .doc('user-1')
            .set(repository.toFirestore(user));

        // Act
        final result = await repository.updateProfile(
          id: 'user-1',
          name: 'New Name',
        );

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) => expect(data.n, 'New Name'),
          failure: (_) => fail('Should not fail'),
        );
      });

      test('updates team name', () async {
        // Arrange
        final user = TestData.createTestUser(
          id: 'user-1',
          teamName: 'Old Team',
        );
        await fakeFirestore
            .collection('users')
            .doc('user-1')
            .set(repository.toFirestore(user));

        // Act
        final result = await repository.updateProfile(
          id: 'user-1',
          teamName: 'New Team',
        );

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) => expect(data.tn, 'New Team'),
          failure: (_) => fail('Should not fail'),
        );
      });

      test('updates email', () async {
        // Arrange
        final user = TestData.createTestUser(
          id: 'user-1',
          email: 'old@example.com',
        );
        await fakeFirestore
            .collection('users')
            .doc('user-1')
            .set(repository.toFirestore(user));

        // Act
        final result = await repository.updateProfile(
          id: 'user-1',
          email: 'new@example.com',
        );

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) => expect(data.em, 'new@example.com'),
          failure: (_) => fail('Should not fail'),
        );
      });

      test('updates multiple fields at once', () async {
        // Arrange
        final user = TestData.createTestUser(
          id: 'user-1',
          name: 'Old Name',
          teamName: 'Old Team',
        );
        await fakeFirestore
            .collection('users')
            .doc('user-1')
            .set(repository.toFirestore(user));

        // Act
        final result = await repository.updateProfile(
          id: 'user-1',
          name: 'New Name',
          teamName: 'New Team',
        );

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) {
            expect(data.n, 'New Name');
            expect(data.tn, 'New Team');
          },
          failure: (_) => fail('Should not fail'),
        );
      });
    });

    group('updateStats', () {
      test('updates budget', () async {
        // Arrange
        final user = TestData.createTestUser(id: 'user-1', budget: 50000000);
        await fakeFirestore
            .collection('users')
            .doc('user-1')
            .set(repository.toFirestore(user));

        // Act
        final result = await repository.updateStats(
          id: 'user-1',
          budget: 60000000,
        );

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) => expect(data.b, 60000000),
          failure: (_) => fail('Should not fail'),
        );
      });

      test('updates team value', () async {
        // Arrange
        final user = TestData.createTestUser(id: 'user-1', teamValue: 45000000);
        await fakeFirestore
            .collection('users')
            .doc('user-1')
            .set(repository.toFirestore(user));

        // Act
        final result = await repository.updateStats(
          id: 'user-1',
          teamValue: 50000000,
        );

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) => expect(data.tv, 50000000),
          failure: (_) => fail('Should not fail'),
        );
      });

      test('updates points and placement', () async {
        // Arrange
        final user = TestData.createTestUser(
          id: 'user-1',
          points: 500,
          placement: 5,
        );
        await fakeFirestore
            .collection('users')
            .doc('user-1')
            .set(repository.toFirestore(user));

        // Act
        final result = await repository.updateStats(
          id: 'user-1',
          points: 600,
          placement: 3,
        );

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) {
            expect(data.p, 600);
            expect(data.pl, 3);
          },
          failure: (_) => fail('Should not fail'),
        );
      });

      test('updates all stats', () async {
        // Arrange
        final user = TestData.createTestUser(id: 'user-1');
        await fakeFirestore
            .collection('users')
            .doc('user-1')
            .set(repository.toFirestore(user));

        // Act
        final result = await repository.updateStats(
          id: 'user-1',
          budget: 70000000,
          teamValue: 65000000,
          points: 800,
          placement: 1,
        );

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) {
            expect(data.b, 70000000);
            expect(data.tv, 65000000);
            expect(data.p, 800);
            expect(data.pl, 1);
          },
          failure: (_) => fail('Should not fail'),
        );
      });
    });

    group('searchByName', () {
      test('returns users matching search query', () async {
        // Arrange
        final user1 = TestData.createTestUser(
          id: 'user-1',
          name: 'Max Mustermann',
        );
        final user2 = TestData.createTestUser(id: 'user-2', name: 'Max Power');
        final user3 = TestData.createTestUser(id: 'user-3', name: 'John Doe');
        await fakeFirestore
            .collection('users')
            .doc('user-1')
            .set(repository.toFirestore(user1));
        await fakeFirestore
            .collection('users')
            .doc('user-2')
            .set(repository.toFirestore(user2));
        await fakeFirestore
            .collection('users')
            .doc('user-3')
            .set(repository.toFirestore(user3));

        // Act
        final result = await repository.searchByName('Max');

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) {
            expect(data.length, greaterThanOrEqualTo(1));
            expect(data.every((u) => u.n.startsWith('Max')), isTrue);
          },
          failure: (_) => fail('Should not fail'),
        );
      });

      test('returns empty list when no matches', () async {
        // Arrange
        final user = TestData.createTestUser(id: 'user-1', name: 'John Doe');
        await fakeFirestore
            .collection('users')
            .doc('user-1')
            .set(repository.toFirestore(user));

        // Act
        final result = await repository.searchByName('NonExistent');

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) => expect(data, isEmpty),
          failure: (_) => fail('Should not fail'),
        );
      });

      test('limits results to 20', () async {
        // Arrange
        for (int i = 0; i < 25; i++) {
          final user = TestData.createTestUser(
            id: 'user-$i',
            name: 'Test User $i',
          );
          await fakeFirestore
              .collection('users')
              .doc('user-$i')
              .set(repository.toFirestore(user));
        }

        // Act
        final result = await repository.searchByName('Test');

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) => expect(data.length, lessThanOrEqualTo(20)),
          failure: (_) => fail('Should not fail'),
        );
      });
    });

    group('fromFirestore and toFirestore', () {
      test('correctly serializes and deserializes user', () async {
        // Arrange
        final user = TestData.createTestUser(
          id: 'user-1',
          name: 'Test User',
          teamName: 'Test Team',
          email: 'test@example.com',
          budget: 50000000,
          teamValue: 45000000,
          points: 500,
          placement: 1,
        );

        // Act
        final json = repository.toFirestore(user);
        await fakeFirestore.collection('users').doc('user-1').set(json);
        final doc = await fakeFirestore.collection('users').doc('user-1').get();
        final deserialized = repository.fromFirestore(doc);

        // Assert
        expect(deserialized.i, user.i);
        expect(deserialized.n, user.n);
        expect(deserialized.tn, user.tn);
        expect(deserialized.em, user.em);
        expect(deserialized.b, user.b);
        expect(deserialized.tv, user.tv);
        expect(deserialized.p, user.p);
        expect(deserialized.pl, user.pl);
      });
    });
  });
}
