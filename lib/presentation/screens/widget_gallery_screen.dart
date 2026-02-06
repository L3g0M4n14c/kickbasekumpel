import 'package:flutter/material.dart';
import '../widgets/app_bars/custom_app_bar.dart';
import '../widgets/app_bars/search_app_bar.dart';
import '../widgets/app_bars/tabbed_app_bar.dart';
import '../widgets/cards/player_card.dart';
import '../widgets/cards/league_card.dart';
import '../widgets/cards/transfer_card.dart';
import '../widgets/cards/match_card.dart';
import '../widgets/cards/player_list_tile.dart';
import '../widgets/cards/league_list_tile.dart';
import '../widgets/forms/email_input_field.dart';
import '../widgets/forms/password_input_field.dart';
import '../widgets/forms/price_input_field.dart';
import '../widgets/forms/search_field.dart';
import '../widgets/common/loading_widget.dart';
import '../widgets/common/error_widget.dart';
import '../widgets/common/empty_state_widget.dart';
import '../widgets/common/retry_widget.dart';
import '../widgets/charts/position_badge.dart';
import '../widgets/buttons/action_button.dart';
import '../widgets/buttons/floating_action_menu.dart';
import '../widgets/buttons/confirmation_dialog.dart';
import '../../data/models/player_model.dart';
import '../../data/models/league_model.dart';

/// Widget Gallery - Demo Screen für alle wiederverwendbaren Widgets
///
/// Zeigt alle verfügbaren Widgets mit Beispiel-Daten.
class WidgetGalleryScreen extends StatefulWidget {
  const WidgetGalleryScreen({super.key});

  @override
  State<WidgetGalleryScreen> createState() => _WidgetGalleryScreenState();
}

class _WidgetGalleryScreenState extends State<WidgetGalleryScreen> {
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    'AppBars',
    'Cards',
    'Forms',
    'Loading/Error',
    'Buttons',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Widget Gallery', showBackButton: true),
      body: Row(
        children: [
          // Sidebar Navigation
          NavigationRail(
            selectedIndex: _selectedCategoryIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedCategoryIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: _categories.map((category) {
              return NavigationRailDestination(
                icon: Icon(_getCategoryIcon(category)),
                label: Text(category),
              );
            }).toList(),
          ),

          const VerticalDivider(thickness: 1, width: 1),

          // Content Area
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: _buildCategoryContent(),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'AppBars':
        return Icons.web_asset;
      case 'Cards':
        return Icons.credit_card;
      case 'Forms':
        return Icons.edit;
      case 'Loading/Error':
        return Icons.error_outline;
      case 'Buttons':
        return Icons.touch_app;
      default:
        return Icons.widgets;
    }
  }

  List<Widget> _buildCategoryContent() {
    switch (_categories[_selectedCategoryIndex]) {
      case 'AppBars':
        return _buildAppBarsSection();
      case 'Cards':
        return _buildCardsSection();
      case 'Forms':
        return _buildFormsSection();
      case 'Loading/Error':
        return _buildLoadingErrorSection();
      case 'Buttons':
        return _buildButtonsSection();
      default:
        return [];
    }
  }

  List<Widget> _buildAppBarsSection() {
    return [
      _buildSectionTitle('Custom AppBar'),
      const Card(
        child: CustomAppBar(title: 'Meine Liga', showBackButton: true),
      ),
      const SizedBox(height: 24),

      _buildSectionTitle('Search AppBar'),
      Card(
        child: SearchAppBar(
          title: 'Spieler',
          onSearch: (query) => debugPrint('Search: $query'),
        ),
      ),
      const SizedBox(height: 24),

      _buildSectionTitle('Tabbed AppBar'),
      Card(
        child: TabbedAppBar(
          title: 'Statistiken',
          tabs: const ['Punkte', 'Marktwert', 'Trend'],
          onTabChanged: (index) => debugPrint('Tab: $index'),
        ),
      ),
    ];
  }

  List<Widget> _buildCardsSection() {
    final mockPlayer = Player(
      id: '1',
      firstName: 'Max',
      lastName: 'Mustermann',
      profileBigUrl: '',
      teamName: 'FC Bayern München',
      teamId: '1',
      position: 4,
      number: 9,
      averagePoints: 12.5,
      totalPoints: 150,
      marketValue: 5500000,
      marketValueTrend: 500000,
      tfhmvt: 0,
      prlo: 0,
      stl: 0,
      status: 0,
      userOwnsPlayer: true,
    );

    final mockLeague = League(
      i: '1',
      n: 'Meine Super Liga',
      cn: 'Creator',
      an: 'Admin',
      c: 'DE',
      s: 'active',
      md: 12,
      cu: const LeagueUser(
        id: '1',
        name: 'Max',
        teamName: 'FC Awesome',
        budget: 50000000,
        teamValue: 100000000,
        points: 450,
        placement: 2,
        won: 8,
        drawn: 2,
        lost: 2,
        se11: 11,
        ttm: 15,
      ),
    );

    return [
      _buildSectionTitle('Player Card'),
      PlayerCard(
        player: mockPlayer,
        onTap: () => debugPrint('Player tapped'),
        showStats: true,
      ),
      const SizedBox(height: 16),

      _buildSectionTitle('Player Card (Compact)'),
      PlayerCard(
        player: mockPlayer,
        onTap: () => debugPrint('Player tapped'),
        compact: true,
      ),
      const SizedBox(height: 24),

      _buildSectionTitle('League Card'),
      LeagueCard(league: mockLeague, onTap: () => debugPrint('League tapped')),
      const SizedBox(height: 24),

      _buildSectionTitle('Transfer Card'),
      TransferCard(
        playerName: 'Max Mustermann',
        teamName: 'FC Bayern',
        price: 5500000,
        type: TransferType.buy,
        date: DateTime.now().subtract(const Duration(hours: 2)),
        onTap: () => debugPrint('Transfer tapped'),
      ),
      const SizedBox(height: 24),

      _buildSectionTitle('Match Card'),
      const MatchCard(
        homeTeam: 'FC Bayern München',
        awayTeam: 'Borussia Dortmund',
        homeScore: 3,
        awayScore: 1,
        kickoff: null,
        isFinished: true,
      ),
      const SizedBox(height: 16),
      MatchCard(
        homeTeam: 'RB Leipzig',
        awayTeam: 'Bayer Leverkusen',
        kickoff: DateTime.now().add(const Duration(hours: 2)),
        isLive: false,
      ),
      const SizedBox(height: 24),

      _buildSectionTitle('Player List Tile'),
      PlayerListTile(
        player: mockPlayer,
        onTap: () => debugPrint('Player tapped'),
      ),
      const SizedBox(height: 16),

      _buildSectionTitle('League List Tile'),
      LeagueListTile(
        league: mockLeague,
        onTap: () => debugPrint('League tapped'),
      ),
    ];
  }

  List<Widget> _buildFormsSection() {
    return [
      _buildSectionTitle('Email Input Field'),
      const EmailInputField(labelText: 'E-Mail Adresse'),
      const SizedBox(height: 24),

      _buildSectionTitle('Password Input Field'),
      const PasswordInputField(
        labelText: 'Passwort',
        showStrengthIndicator: true,
      ),
      const SizedBox(height: 24),

      _buildSectionTitle('Price Input Field'),
      const PriceInputField(labelText: 'Kaufpreis', maxValue: 50000000),
      const SizedBox(height: 24),

      _buildSectionTitle('Search Field'),
      SearchField(
        hintText: 'Spieler suchen...',
        onSearch: (query) => debugPrint('Search: $query'),
      ),
    ];
  }

  List<Widget> _buildLoadingErrorSection() {
    return [
      _buildSectionTitle('Loading Widget'),
      const LoadingWidget(message: 'Lade Spieler...', size: LoadingSize.medium),
      const SizedBox(height: 24),

      _buildSectionTitle('Inline Loading'),
      const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: InlineLoadingWidget(message: 'Wird geladen...'),
        ),
      ),
      const SizedBox(height: 24),

      _buildSectionTitle('Error Widget'),
      AppErrorWidget(
        message: 'Fehler beim Laden',
        details: 'Die Spieler konnten nicht geladen werden.',
        onRetry: () => debugPrint('Retry'),
      ),
      const SizedBox(height: 24),

      _buildSectionTitle('Empty State'),
      const EmptyStateWidget(
        message: 'Keine Spieler gefunden',
        icon: Icons.people_outline,
      ),
      const SizedBox(height: 24),

      _buildSectionTitle('No Results'),
      NoResultsWidget(
        searchQuery: 'Ronaldo',
        onClear: () => debugPrint('Clear search'),
      ),
      const SizedBox(height: 24),

      _buildSectionTitle('Retry Widget'),
      RetryWidget(
        message: 'Laden fehlgeschlagen',
        onRetry: () => debugPrint('Retry'),
      ),
      const SizedBox(height: 24),

      _buildSectionTitle('Position Badges'),
      Row(
        children: [
          const PositionBadge(position: 1, size: PositionBadgeSize.small),
          const SizedBox(width: 8),
          const PositionBadge(position: 2, size: PositionBadgeSize.medium),
          const SizedBox(width: 8),
          const PositionBadge(position: 3, size: PositionBadgeSize.large),
          const SizedBox(width: 8),
          const PositionBadge(position: 4, size: PositionBadgeSize.medium),
        ],
      ),
    ];
  }

  List<Widget> _buildButtonsSection() {
    return [
      _buildSectionTitle('Action Buttons'),
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          ActionButton(
            label: 'Filled',
            onPressed: () => debugPrint('Pressed'),
            style: ActionButtonStyle.filled,
          ),
          ActionButton(
            label: 'Outlined',
            onPressed: () => debugPrint('Pressed'),
            style: ActionButtonStyle.outlined,
          ),
          ActionButton(
            label: 'Text',
            onPressed: () => debugPrint('Pressed'),
            style: ActionButtonStyle.text,
          ),
          ActionButton(
            label: 'Tonal',
            onPressed: () => debugPrint('Pressed'),
            style: ActionButtonStyle.tonal,
          ),
        ],
      ),
      const SizedBox(height: 24),

      _buildSectionTitle('Action Buttons with Icons'),
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          ActionButton(
            label: 'Kaufen',
            icon: Icons.shopping_cart,
            onPressed: () => debugPrint('Pressed'),
            style: ActionButtonStyle.filled,
          ),
          ActionButton(
            label: 'Verkaufen',
            icon: Icons.sell,
            onPressed: () => debugPrint('Pressed'),
            style: ActionButtonStyle.outlined,
          ),
        ],
      ),
      const SizedBox(height: 24),

      _buildSectionTitle('Loading Button'),
      ActionButton(
        label: 'Wird geladen...',
        onPressed: () => debugPrint('Pressed'),
        isLoading: true,
      ),
      const SizedBox(height: 24),

      _buildSectionTitle('Confirmation Dialog'),
      ActionButton(
        label: 'Dialog öffnen',
        onPressed: () async {
          final result = await showConfirmationDialog(
            context: context,
            title: 'Spieler verkaufen?',
            message: 'Möchtest du Max Mustermann wirklich verkaufen?',
            confirmText: 'Verkaufen',
            isDangerous: true,
          );
          debugPrint('Dialog result: $result');
        },
      ),
    ];
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
