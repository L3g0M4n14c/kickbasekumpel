import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kickbasekumpel/data/repositories/firestore_repositories.dart';
import '../../helpers/matchers.dart';
import '../../helpers/test_data.dart';
import '../../helpers/result_extension.dart';
import '../../helpers/mock_firebase.dart';

void main() {
  group('LeagueRepository', () {
    late FakeFirebaseFirestore fakeFirestore;
    late MockKickbaseAPIClient mockApiClient;
    late LeagueRepository repository;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      mockApiClient = MockKickbaseAPIClient();
      repository = LeagueRepository(
        firestore: fakeFirestore,
        apiClient: mockApiClient,
      );
    });

    group('getByUserId', () {
      test('returns leagues where user is a member', () async {
        // Arrange
        final league1 = TestData.createTestLeague(
          id: 'league-1',
          name: 'League 1',
        );
        final league2 = TestData.createTestLeague(
          id: 'league-2',
          name: 'League 2',
        );
        final league3 = TestData.createTestLeague(
          id: 'league-3',
          name: 'League 3',
        );

        final league1Data = repository.toFirestore(league1);
        league1Data['members'] = ['user-1', 'user-2'];
        final league2Data = repository.toFirestore(league2);
        league2Data['members'] = ['user-1', 'user-3'];
        final league3Data = repository.toFirestore(league3);
        league3Data['members'] = ['user-2', 'user-3'];

        await fakeFirestore
            .collection('leagues')
            .doc('league-1')
            .set(league1Data);
        await fakeFirestore
            .collection('leagues')
            .doc('league-2')
            .set(league2Data);
        await fakeFirestore
            .collection('leagues')
            .doc('league-3')
            .set(league3Data);

        // Act
        final result = await repository.getByUserId('user-1');

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) {
            expect(data, hasLength(2));
            expect(data.map((l) => l.i), containsAll(['league-1', 'league-2']));
          },
          failure: (_) => fail('Should not fail'),
        );
      });

      test('returns empty list when user has no leagues', () async {
        // Act
        final result = await repository.getByUserId('user-without-leagues');

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) => expect(data, isEmpty),
          failure: (_) => fail('Should not fail'),
        );
      });
    });

    group('searchByName', () {
      test('returns leagues matching search query', () async {
        // Arrange
        final league1 = TestData.createTestLeague(
          id: 'league-1',
          name: 'Bundesliga Masters',
        );
        final league2 = TestData.createTestLeague(
          id: 'league-2',
          name: 'Bundesliga Pro',
        );
        final league3 = TestData.createTestLeague(
          id: 'league-3',
          name: 'Champions League',
        );

        await fakeFirestore
            .collection('leagues')
            .doc('league-1')
            .set(repository.toFirestore(league1));
        await fakeFirestore
            .collection('leagues')
            .doc('league-2')
            .set(repository.toFirestore(league2));
        await fakeFirestore
            .collection('leagues')
            .doc('league-3')
            .set(repository.toFirestore(league3));

        // Act
        final result = await repository.searchByName('Bundesliga');

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) {
            expect(data.length, greaterThanOrEqualTo(1));
            expect(data.every((l) => l.n.startsWith('Bundesliga')), isTrue);
          },
          failure: (_) => fail('Should not fail'),
        );
      });
    });

    group('getActiveLeagues', () {
      test('returns leagues with matchday greater than 0', () async {
        // Arrange
        final league1 = TestData.createTestLeague(id: 'league-1');
        final league2 = TestData.createTestLeague(id: 'league-2');
        final league3 = TestData.createTestLeague(id: 'league-3');

        final league1Data = repository.toFirestore(league1);
        league1Data['active'] = true;
        final league2Data = repository.toFirestore(league2);
        league2Data['active'] = false;
        final league3Data = repository.toFirestore(league3);
        league3Data['active'] = true;

        await fakeFirestore
            .collection('leagues')
            .doc('league-1')
            .set(league1Data);
        await fakeFirestore
            .collection('leagues')
            .doc('league-2')
            .set(league2Data);
        await fakeFirestore
            .collection('leagues')
            .doc('league-3')
            .set(league3Data);

        // Act
        final result = await repository.getActiveLeagues();

        // Assert
        expect(result, ResultMatchers.isSuccess());
        result.when(
          success: (data) {
            expect(data, hasLength(2));
            // League 1 and 3 should be active
          },
          failure: (_) => fail('Should not fail'),
        );
      });
    });

    group('addMember', () {
      test('successfully adds member to league', () async {
        // Arrange
        final league = TestData.createTestLeague(id: 'league-1');
        final leagueData = repository.toFirestore(league);
        leagueData['members'] = ['user-1'];
        await fakeFirestore
            .collection('leagues')
            .doc('league-1')
            .set(leagueData);

        // Act
        final result = await repository.addMember(
          leagueId: 'league-1',
          userId: 'user-2',
        );

        // Assert
        expect(result, ResultMatchers.isSuccess());

        // Verify member was added
        final doc = await fakeFirestore
            .collection('leagues')
            .doc('league-1')
            .get();
        final members = List<String>.from(doc.data()!['members'] ?? []);
        expect(members, contains('user-2'));
      });

      test('does not add duplicate member', () async {
        // Arrange
        final league = TestData.createTestLeague(id: 'league-1');
        final leagueData = repository.toFirestore(league);
        leagueData['members'] = ['user-1'];
        await fakeFirestore
            .collection('leagues')
            .doc('league-1')
            .set(leagueData);

        // Act - Try to add same user twice
        await repository.addMember(leagueId: 'league-1', userId: 'user-1');
        final result = await repository.addMember(
          leagueId: 'league-1',
          userId: 'user-1',
        );

        // Assert
        expect(result, ResultMatchers.isSuccess());

        // Verify no duplicate
        final doc = await fakeFirestore
            .collection('leagues')
            .doc('league-1')
            .get();
        final members = List<String>.from(doc.data()!['members'] ?? []);
        expect(members.where((id) => id == 'user-1'), hasLength(1));
      });
    });

    group('removeMember', () {
      test('successfully removes member from league', () async {
        // Arrange
        final league = TestData.createTestLeague(id: 'league-1');
        final leagueData = repository.toFirestore(league);
        leagueData['members'] = ['user-1', 'user-2', 'user-3'];
        await fakeFirestore
            .collection('leagues')
            .doc('league-1')
            .set(leagueData);

        // Act
        final result = await repository.removeMember(
          leagueId: 'league-1',
          userId: 'user-2',
        );

        // Assert
        expect(result, ResultMatchers.isSuccess());

        // Verify member was removed
        final doc = await fakeFirestore
            .collection('leagues')
            .doc('league-1')
            .get();
        final members = List<String>.from(doc.data()!['members'] ?? []);
        expect(members, isNot(contains('user-2')));
        expect(members, hasLength(2));
      });
    });

    group('fromFirestore and toFirestore', () {
      test('correctly serializes and deserializes league', () async {
        // Arrange
        final league = TestData.createTestLeague(
          id: 'league-1',
          name: 'Test League',
        );

        // Act
        final json = repository.toFirestore(league);
        await fakeFirestore.collection('leagues').doc('league-1').set(json);
        final doc = await fakeFirestore
            .collection('leagues')
            .doc('league-1')
            .get();
        final deserialized = repository.fromFirestore(doc);

        // Assert
        expect(deserialized.i, league.i);
        expect(deserialized.n, league.n);
        expect(deserialized.cn, league.cn);
        expect(deserialized.s, league.s);
        expect(deserialized.md, league.md);
      });
    });
  });
}
