/// Barrel file for all Riverpod providers
/// Import this file to access all providers in your app
///
/// Example:
/// ```dart
/// import 'package:kickbasekumpel/data/providers/providers.dart';
/// ```
library;

// API & Service Providers
export 'kickbase_api_provider.dart';
export 'ligainsider_provider.dart';

// Repository Providers
export 'repository_providers.dart';

// Domain Providers
export 'user_providers.dart';
export 'league_providers.dart';
export 'player_providers.dart';
export 'transfer_providers.dart';
export 'recommendation_providers.dart';

// New Providers - Schritt 5 (Migration Plan)
export 'league_detail_providers.dart';
export 'player_detail_providers.dart';
export 'manager_providers.dart';
export 'live_providers.dart';
export 'scouted_players_providers.dart';
export 'competition_providers.dart';

// Presentation Providers
export '../../presentation/providers/market_providers.dart';
