import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kickbasekumpel/data/models/models_barrel.dart';
import 'package:kickbasekumpel/data/repositories/base_repository.dart';
import 'package:kickbasekumpel/domain/repositories/repository_interfaces.dart';
import '../../helpers/matchers.dart';
import '../../helpers/test_data.dart';
import '../../helpers/result_extension.dart';

// Concrete implementation for testing BaseRepository
class TestUserRepository extends BaseRepository<User> {
  TestUserRepository({required super.firestore})
    : super(collectionPath: 'users');

  @override
  User fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return User.fromJson(data);
  }

  @override
  Map<String, dynamic> toFirestore(User item) {
    return item.toJson();
  }
}

void main() {
  group('BaseRepository', () {
    late FakeFirebaseFirestore fakeFirestore;
    late TestUserRepository repository;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      repository = TestUserRepository(firestore: fakeFirestore);
    });

    group('getAll', () {
      test('returns empty list when collection is empty', () async {
        // Act
        final result = await repository.getAll();

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) => expect(data, isEmpty),
          failure: (_) => fail('Should not fail'),
        );
      });

      test('returns all documents from collection', () async {
        // Arrange
        final user1 = TestData.createTestUser(id: 'user-1');
        final user2 = TestData.createTestUser(id: 'user-2', name: 'User 2');
        await fakeFirestore
            .collection('users')
            .doc('user-1')
            .set(user1.toJson());
        await fakeFirestore
            .collection('users')
            .doc('user-2')
            .set(user2.toJson());

        // Act
        final result = await repository.getAll();

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) {
            expect(data, hasLength(2));
            expect(data.map((u) => u.i), containsAll(['user-1', 'user-2']));
          },
          failure: (_) => fail('Should not fail'),
        );
      });
    });

    group('getById', () {
      test('returns document when it exists', () async {
        // Arrange
        final user = TestData.createTestUser(id: 'user-123');
        await fakeFirestore
            .collection('users')
            .doc('user-123')
            .set(user.toJson());

        // Act
        final result = await repository.getById('user-123');

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) {
            expect(data.i, 'user-123');
            expect(data.n, user.n);
          },
          failure: (_) => fail('Should not fail'),
        );
      });

      test('returns failure when document does not exist', () async {
        // Act
        final result = await repository.getById('non-existent');

        // Assert
        expect(result, ResultMatchers.isFailure());
        expect(result, ResultMatchers.isFailureWith('Document not found'));
      });
    });

    group('create', () {
      test('creates new document with auto-generated ID', () async {
        // Arrange
        final user = TestData.createTestUser(id: 'auto-id');

        // Act
        final result = await repository.create(user);

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) {
            expect(data.n, user.n);
            expect(data.em, user.em);
          },
          failure: (_) => fail('Should not fail'),
        );

        // Verify document was created
        final snapshot = await fakeFirestore.collection('users').get();
        expect(snapshot.docs, hasLength(1));
      });
    });

    group('createWithId', () {
      test('creates document with custom ID', () async {
        // Arrange
        final user = TestData.createTestUser(id: 'custom-id');

        // Act
        final result = await repository.createWithId('custom-id', user);

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) {
            expect(data.i, 'custom-id');
            expect(data.n, user.n);
          },
          failure: (_) => fail('Should not fail'),
        );

        // Verify document exists with correct ID
        final doc = await fakeFirestore
            .collection('users')
            .doc('custom-id')
            .get();
        expect(doc.exists, isTrue);
      });

      test('overwrites existing document with same ID', () async {
        // Arrange
        final user1 = TestData.createTestUser(id: 'same-id', name: 'First');
        final user2 = TestData.createTestUser(id: 'same-id', name: 'Second');
        await repository.createWithId('same-id', user1);

        // Act
        final result = await repository.createWithId('same-id', user2);

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) => expect(data.n, 'Second'),
          failure: (_) => fail('Should not fail'),
        );
      });
    });

    group('update', () {
      test('updates existing document', () async {
        // Arrange
        final original = TestData.createTestUser(
          id: 'user-1',
          name: 'Original',
        );
        await fakeFirestore
            .collection('users')
            .doc('user-1')
            .set(original.toJson());

        final updated = TestData.createTestUser(id: 'user-1', name: 'Updated');

        // Act
        final result = await repository.update('user-1', updated);

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) => expect(data.n, 'Updated'),
          failure: (_) => fail('Should not fail'),
        );
      });

      test('returns failure when document does not exist', () async {
        // Arrange
        final user = TestData.createTestUser(id: 'non-existent');

        // Act
        final result = await repository.update('non-existent', user);

        // Assert
        expect(result, ResultMatchers.isFailure());
      });
    });

    group('updateFields', () {
      test('updates specific fields only', () async {
        // Arrange
        final user = TestData.createTestUser(
          id: 'user-1',
          name: 'Original',
          budget: 50000000,
        );
        await fakeFirestore
            .collection('users')
            .doc('user-1')
            .set(user.toJson());

        // Act
        final result = await repository.updateFields('user-1', {
          'n': 'Updated Name',
          'b': 60000000,
        });

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) {
            expect(data.n, 'Updated Name');
            expect(data.b, 60000000);
            expect(data.em, user.em); // Unchanged field
          },
          failure: (_) => fail('Should not fail'),
        );
      });
    });

    group('delete', () {
      test('deletes existing document', () async {
        // Arrange
        final user = TestData.createTestUser(id: 'user-1');
        await fakeFirestore
            .collection('users')
            .doc('user-1')
            .set(user.toJson());

        // Act
        final result = await repository.delete('user-1');

        // Assert
        expect(result, ResultMatchers.isSuccess());

        // Verify document was deleted
        final doc = await fakeFirestore.collection('users').doc('user-1').get();
        expect(doc.exists, isFalse);
      });

      test('succeeds even when document does not exist', () async {
        // Act
        final result = await repository.delete('non-existent');

        // Assert - FakeFirebaseFirestore allows delete of non-existent docs
        expect(result, ResultMatchers.isSuccess());
      });
    });

    group('watchAll', () {
      test('streams all documents', () async {
        // Arrange
        final user1 = TestData.createTestUser(id: 'user-1');
        final user2 = TestData.createTestUser(id: 'user-2');
        await fakeFirestore
            .collection('users')
            .doc('user-1')
            .set(user1.toJson());
        await fakeFirestore
            .collection('users')
            .doc('user-2')
            .set(user2.toJson());

        // Act & Assert
        await expectLater(
          repository.watchAll(),
          emits(
            predicate<Result<List<User>>>((result) {
              return result.when(
                success: (data) => data.length == 2,
                failure: (_) => false,
              );
            }),
          ),
        );
      });

      test('emits updates when documents change', () async {
        // Arrange
        final user = TestData.createTestUser(id: 'user-1', name: 'Original');
        await fakeFirestore
            .collection('users')
            .doc('user-1')
            .set(user.toJson());

        // Act & Assert
        final stream = repository.watchAll();

        // First emission: original data
        await expectLater(
          stream,
          emits(
            predicate<Result<List<User>>>((result) {
              return result.when(
                success: (data) => data.first.n == 'Original',
                failure: (_) => false,
              );
            }),
          ),
        );

        // Update document
        await fakeFirestore.collection('users').doc('user-1').update({
          'n': 'Updated',
        });

        // Should emit updated data
        await expectLater(
          stream,
          emits(
            predicate<Result<List<User>>>((result) {
              return result.when(
                success: (data) => data.first.n == 'Updated',
                failure: (_) => false,
              );
            }),
          ),
        );
      });
    });

    group('watchById', () {
      test('streams single document', () async {
        // Arrange
        final user = TestData.createTestUser(id: 'user-1');
        await fakeFirestore
            .collection('users')
            .doc('user-1')
            .set(user.toJson());

        // Act & Assert
        await expectLater(
          repository.watchById('user-1'),
          emits(
            predicate<Result<User>>((result) {
              return result.when(
                success: (data) => data.i == 'user-1',
                failure: (_) => false,
              );
            }),
          ),
        );
      });

      test('emits failure when document does not exist', () async {
        // Act & Assert
        await expectLater(
          repository.watchById('non-existent'),
          emits(ResultMatchers.isFailure()),
        );
      });
    });

    group('queryWhere', () {
      test('returns documents matching query', () async {
        // Arrange
        final user1 = TestData.createTestUser(
          id: 'user-1',
          email: 'test1@example.com',
        );
        final user2 = TestData.createTestUser(
          id: 'user-2',
          email: 'test2@example.com',
        );
        final user3 = TestData.createTestUser(
          id: 'user-3',
          email: 'test1@example.com',
        );
        await fakeFirestore
            .collection('users')
            .doc('user-1')
            .set(user1.toJson());
        await fakeFirestore
            .collection('users')
            .doc('user-2')
            .set(user2.toJson());
        await fakeFirestore
            .collection('users')
            .doc('user-3')
            .set(user3.toJson());

        // Act
        final result = await repository.queryWhere(
          field: 'em',
          value: 'test1@example.com',
        );

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) {
            expect(data, hasLength(2));
            expect(data.every((u) => u.em == 'test1@example.com'), isTrue);
          },
          failure: (_) => fail('Should not fail'),
        );
      });

      test('returns empty list when no matches', () async {
        // Act
        final result = await repository.queryWhere(
          field: 'em',
          value: 'nonexistent@example.com',
        );

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) => expect(data, isEmpty),
          failure: (_) => fail('Should not fail'),
        );
      });

      test('respects limit parameter', () async {
        // Arrange
        for (int i = 0; i < 5; i++) {
          final user = TestData.createTestUser(
            id: 'user-$i',
            email: 'test@example.com',
          );
          await fakeFirestore
              .collection('users')
              .doc('user-$i')
              .set(user.toJson());
        }

        // Act
        final result = await repository.queryWhere(
          field: 'em',
          value: 'test@example.com',
          limit: 3,
        );

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) => expect(data, hasLength(3)),
          failure: (_) => fail('Should not fail'),
        );
      });
    });

    group('queryOrderBy', () {
      test('returns documents ordered by field', () async {
        // Arrange
        final user1 = TestData.createTestUser(id: 'user-1', points: 100);
        final user2 = TestData.createTestUser(id: 'user-2', points: 300);
        final user3 = TestData.createTestUser(id: 'user-3', points: 200);
        await fakeFirestore
            .collection('users')
            .doc('user-1')
            .set(user1.toJson());
        await fakeFirestore
            .collection('users')
            .doc('user-2')
            .set(user2.toJson());
        await fakeFirestore
            .collection('users')
            .doc('user-3')
            .set(user3.toJson());

        // Act
        final result = await repository.queryOrderBy(
          field: 'p',
          descending: true,
        );

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) {
            expect(data, hasLength(3));
            expect(data[0].p, 300); // Highest first
            expect(data[1].p, 200);
            expect(data[2].p, 100);
          },
          failure: (_) => fail('Should not fail'),
        );
      });
    });

    group('timestamp helpers', () {
      test('timestampToDateTime converts Timestamp to DateTime', () {
        // Arrange
        final timestamp = Timestamp.now();

        // Act
        final dateTime = repository.timestampToDateTime(timestamp);

        // Assert
        expect(dateTime, isNotNull);
        expect(dateTime, isA<DateTime>());
      });

      test('timestampToDateTime returns null for null input', () {
        // Act
        final dateTime = repository.timestampToDateTime(null);

        // Assert
        expect(dateTime, isNull);
      });

      test('dateTimeToTimestamp converts DateTime to Timestamp', () {
        // Arrange
        final dateTime = DateTime.now();

        // Act
        final timestamp = repository.dateTimeToTimestamp(dateTime);

        // Assert
        expect(timestamp, isNotNull);
        expect(timestamp, isA<Timestamp>());
      });

      test('dateTimeToTimestamp returns null for null input', () {
        // Act
        final timestamp = repository.dateTimeToTimestamp(null);

        // Assert
        expect(timestamp, isNull);
      });
    });
  });
}
