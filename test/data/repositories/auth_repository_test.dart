import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kickbasekumpel/data/repositories/auth_repository.dart';
import 'package:kickbasekumpel/data/sources/auth_source.dart';
import 'package:kickbasekumpel/domain/repositories/auth_repository_interface.dart';

import '../../helpers/mock_firebase.dart';

void main() {
  group('AuthRepository', () {
    late AuthRepository repository;
    late MockFirebaseAuth mockFirebaseAuth;
    late AuthSource authSource;
    late MockUser mockUser;

    setUp(() {
      mockUser = MockFirebaseSetup.createMockUser();
      mockFirebaseAuth = MockFirebaseSetup.createMockAuth();
      authSource = AuthSource(firebaseAuth: mockFirebaseAuth);
      repository = AuthRepository(authSource: authSource);
    });

    group('signUp', () {
      test('returns success with user on successful sign up', () async {
        // Arrange
        final email = 'test@example.com';
        final password = 'password123';
        final mockCredential = MockFirebaseSetup.createMockUserCredential(
          mockUser,
        );

        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).thenAnswer((_) async => mockCredential);

        // Act
        final result = await repository.signUp(
          email: email,
          password: password,
        );

        // Assert
        expect(result, isA<AuthSuccess<auth.User>>());
        final success = result as AuthSuccess<auth.User>;
        expect(success.data.uid, mockUser.uid);
        verify(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).called(1);
      });

      test('returns failure on FirebaseAuthException', () async {
        // Arrange
        final email = 'test@example.com';
        final password = 'weak';
        final exception = auth.FirebaseAuthException(code: 'weak-password');

        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).thenThrow(exception);

        // Act
        final result = await repository.signUp(
          email: email,
          password: password,
        );

        // Assert
        expect(result, isA<AuthFailure<auth.User>>());
        final failure = result as AuthFailure<auth.User>;
        expect(failure.code, 'weak-password');
      });
    });

    group('signInWithEmail', () {
      test('returns success with user on successful sign in', () async {
        // Arrange
        final email = 'test@example.com';
        final password = 'password123';
        final mockCredential = MockFirebaseSetup.createMockUserCredential(
          mockUser,
        );

        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).thenAnswer((_) async => mockCredential);

        // Act
        final result = await repository.signIn(
          email: email,
          password: password,
        );

        // Assert
        expect(result, isA<AuthSuccess<auth.User>>());
        final success = result as AuthSuccess<auth.User>;
        expect(success.data.uid, mockUser.uid);
      });

      test('returns failure on invalid credentials', () async {
        // Arrange
        final email = 'test@example.com';
        final password = 'wrong';
        final exception = auth.FirebaseAuthException(code: 'wrong-password');

        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).thenThrow(exception);

        // Act
        final result = await repository.signIn(
          email: email,
          password: password,
        );

        // Assert
        expect(result, isA<AuthFailure<auth.User>>());
        final failure = result as AuthFailure<auth.User>;
        expect(failure.code, 'wrong-password');
      });
    });

    group('signOut', () {
      test('returns success on successful sign out', () async {
        // Arrange
        when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async => {});

        // Act
        final result = await repository.signOut();

        // Assert
        expect(result, isA<AuthSuccess<void>>());
        verify(() => mockFirebaseAuth.signOut()).called(1);
      });

      test('returns failure on exception', () async {
        // Arrange
        final exception = Exception('Network error');
        when(() => mockFirebaseAuth.signOut()).thenThrow(exception);

        // Act
        final result = await repository.signOut();

        // Assert
        expect(result, isA<AuthFailure<void>>());
      });
    });

    group('getCurrentUser', () {
      test('returns current user when signed in', () async {
        // Arrange
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

        // Act
        final result = await repository.getCurrentUser();

        // Assert
        expect(result, isA<AuthSuccess<auth.User?>>());
        final success = result as AuthSuccess<auth.User?>;
        expect(success.data?.uid, mockUser.uid);
      });

      test('returns null when not signed in', () async {
        // Arrange
        when(() => mockFirebaseAuth.currentUser).thenReturn(null);

        // Act
        final result = await repository.getCurrentUser();

        // Assert
        expect(result, isA<AuthSuccess<auth.User?>>());
        final success = result as AuthSuccess<auth.User?>;
        expect(success.data, isNull);
      });
    });

    group('authStateChanges', () {
      test('emits user state changes', () async {
        // Arrange
        final controller = StreamController<auth.User?>();
        when(
          () => mockFirebaseAuth.authStateChanges(),
        ).thenAnswer((_) => controller.stream);

        // Act
        final stream = repository.authStateChanges;

        // Assert
        expectLater(stream, emitsInOrder([isNull, mockUser]));

        controller.add(null);
        controller.add(mockUser);
        await controller.close();
      });
    });

    group('sendPasswordResetEmail', () {
      test('returns success on successful email sent', () async {
        // Arrange
        final email = 'test@example.com';
        when(
          () => mockFirebaseAuth.sendPasswordResetEmail(email: email),
        ).thenAnswer((_) async => {});

        // Act
        final result = await repository.sendPasswordResetEmail(email);

        // Assert
        expect(result, isA<AuthSuccess<void>>());
        verify(
          () => mockFirebaseAuth.sendPasswordResetEmail(email: email),
        ).called(1);
      });

      test('returns failure on invalid email', () async {
        // Arrange
        final email = 'invalid@example.com';
        final exception = auth.FirebaseAuthException(code: 'user-not-found');

        when(
          () => mockFirebaseAuth.sendPasswordResetEmail(email: email),
        ).thenThrow(exception);

        // Act
        final result = await repository.sendPasswordResetEmail(email);

        // Assert
        expect(result, isA<AuthFailure<void>>());
        final failure = result as AuthFailure<void>;
        expect(failure.code, 'user-not-found');
      });
    });
  });
}
