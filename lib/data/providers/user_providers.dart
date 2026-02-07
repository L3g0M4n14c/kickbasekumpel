import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../../domain/repositories/repository_interfaces.dart';
import 'repository_providers.dart';
import 'kickbase_auth_provider.dart';

// ============================================================================
// AUTH STATE PROVIDERS
// ============================================================================

/// Current Kickbase User ID
/// Synchronous access to current Kickbase user ID
/// Returns null if not authenticated
final currentAuthUserIdProvider = Provider<String?>((ref) {
  return ref.watch(kickbaseUserIdProvider);
});

// ============================================================================
// USER DATA PROVIDERS
// ============================================================================

/// Current User Data Provider
/// Provides current Kickbase user data from auth state
/// Wrapped in AsyncValue for consistency with UI widgets
final currentUserProvider = FutureProvider<User?>((ref) async {
  final user = ref.watch(currentKickbaseUserProvider);
  return user;
});

/// User Data by ID Provider Family
/// Fetches specific user data by ID
/// Useful for displaying other users' profiles
final userDataProvider = FutureProvider.family<User, String>((
  ref,
  userId,
) async {
  final userRepo = ref.watch(userRepositoryProvider);
  final result = await userRepo.getById(userId);

  if (result is Success<User>) {
    return result.data;
  } else if (result is Failure<User>) {
    throw Exception((result).message);
  }
  throw Exception('Unknown error fetching user');
});

/// Current User Data (synchronous access)
/// Provides synchronous access to current user data
/// Returns null if not authenticated
final currentUserDataProvider = Provider<User?>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  return userAsync.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );
});

/// User Settings Provider
/// For future user settings/preferences implementation
/// Currently uses User model, can be extended with UserSettings model
final userSettingsProvider = FutureProvider<User?>((ref) async {
  final userId = ref.watch(currentAuthUserIdProvider);

  if (userId == null) {
    return null;
  }

  final userRepo = ref.watch(userRepositoryProvider);
  final result = await userRepo.getById(userId);

  if (result is Success<User>) {
    return result.data;
  } else if (result is Failure<User>) {
    throw Exception((result).message);
  }
  throw Exception('Unknown error fetching user settings');
});

// ============================================================================
// USER SEARCH PROVIDERS
// ============================================================================

/// Search Users by Name Provider
/// Family provider for searching users by name query
final searchUsersProvider = FutureProvider.family<List<User>, String>((
  ref,
  query,
) async {
  if (query.isEmpty) {
    return [];
  }

  final userRepo = ref.watch(userRepositoryProvider);
  final result = await userRepo.searchByName(query);

  if (result is Success<List<User>>) {
    return result.data;
  } else if (result is Failure<List<User>>) {
    throw Exception((result).message);
  }
  throw Exception('Unknown error searching users');
});

/// User by Email Provider
/// Fetches user by email address
final userByEmailProvider = FutureProvider.family<User, String>((
  ref,
  email,
) async {
  final userRepo = ref.watch(userRepositoryProvider);
  final result = await userRepo.getByEmail(email);

  if (result is Success<User>) {
    return result.data;
  } else if (result is Failure<User>) {
    throw Exception((result).message);
  }
  throw Exception('Unknown error fetching user by email');
});

// ============================================================================
// USAGE EXAMPLES
// ============================================================================

/*
/// Example 1: Display current user data in a widget
class UserProfileWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return Text('Not logged in');
        }
        return Column(
          children: [
            Text('Name: ${user.n}'),
            Text('Team: ${user.tn}'),
            Text('Budget: ${user.b}€'),
            Text('Points: ${user.p}'),
          ],
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}

/// Example 2: Access user data synchronously for logic
class UserBudgetChecker extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserDataProvider);
    
    if (user == null) {
      return Text('Loading...');
    }
    
    final hasBudget = user.b >= 1000000;
    return Text(hasBudget ? 'Can buy player' : 'Insufficient budget');
  }
}

/// Example 3: Search users
class UserSearchWidget extends ConsumerWidget {
  final String searchQuery;

  const UserSearchWidget({required this.searchQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchAsync = ref.watch(searchUsersProvider(searchQuery));

    return searchAsync.when(
      data: (users) => ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text(user.n),
            subtitle: Text(user.tn),
          );
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}

/// Example 4: View another user's profile
class OtherUserProfileWidget extends ConsumerWidget {
  final String userId;

  const OtherUserProfileWidget({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userDataProvider(userId));

    return userAsync.when(
      data: (user) => Column(
        children: [
          Text('Name: ${user.n}'),
          Text('Team: ${user.tn}'),
          Text('Points: ${user.p}'),
        ],
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}

/// Example 5: Listen to auth changes for navigation
class AuthHandler extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<String?>>(
      authUserStreamProvider,
      (previous, next) {
        next.when(
          data: (userId) {
            if (userId == null) {
              // Navigate to login
              Navigator.of(context).pushReplacementNamed('/login');
            } else {
              // Navigate to home
              Navigator.of(context).pushReplacementNamed('/home');
            }
          },
          loading: () {},
          error: (error, stack) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Auth error: $error')),
            );
          },
        );
      },
    );
    
    return Container();
  }
}
*/
