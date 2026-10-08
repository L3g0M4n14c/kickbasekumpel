# Endpunkt-Landkarte Kickbase v4

Spalten: **Endpunkt** → **Client-Methode** (`KickbaseAPIClient`) → **Roh-Antwort →
Parsing** → **Provider** → **UI-Konsument**. Spezifikation: `docs/api-endpoints.json`.
„ungenutzt" = Methode/Endpunkt existiert, aber kein Aufrufer.

## Auth & User

| Endpunkt | Methode | Parsing | Provider | UI |
|---|---|---|---|---|
| `POST /v4/user/login` | `login()` | `LoginResponse` (tkn, u, srvl, userId) | `kickbaseAuthProvider`, `initializeAuthProvider` | `signin_page` |
| `GET /v4/user` | `getUser()` | `User` | `UserRepository` (Sync), `kickbase_auth_provider` | – |
| `GET /v4/user/settings` | `getUserSettings()` | Map (ungenutzt) | – | – |

## Liga

| Endpunkt | Methode | Parsing | Provider | UI |
|---|---|---|---|---|
| `GET /v4/leagues/selection` | `getLeagues()` | `List<League>` via `normalizeLeagueJson` | `league_providers`, `kickbase_auth_provider` | Liga-Auswahl |
| `GET /v4/leagues/{id}/overview` | `getLeague()`, `getLeagueOverview()` | `League` / Map (`dt` = Saisonstart) | `leagueSeasonStartDateProvider` (budget_calculation) | – |
| `GET /v4/leagues/{id}/me` | `getLeagueMe()` | Map | `leagueMeProvider` | `home_page` |
| `GET /v4/leagues/{id}/me/budget` | `getMyBudget()` | Map | `myBudgetProvider` | `home_page`, `squad_screen` |
| `GET /v4/leagues/{id}/ranking` | `getLeagueRanking()` | Map (Spieltags-Ranking `mdp`) | `leagueRankingProvider`, `currentLeagueRankingProvider`, `leagueMatchdayDataProvider`, `bid_recommendation_providers` | `league_standings_page` |
| `GET /v4/leagues/{id}/activitiesFeed` | `getLeagueActivitiesFeed()` | Map (ungenutzt, s. Roadmap) | – | – |
| `GET /v4/leagues/{id}/settings` | – | – (Roadmap: echte Liga-Regeln) | – | – |

## Eigener Kader & Aufstellung

| Endpunkt | Methode | Parsing | Provider | UI |
|---|---|---|---|---|
| `GET /v4/leagues/{id}/squad` | `getMySquad()`, `getLeaguePlayers()` (Squad→Market-Fallback) | Map / `List<Player>` via `normalizePlayerJson` | `mySquadProvider`, `leaguePlayersProvider`, `dashboard_providers` | `squad_screen`, `home_page` |
| `GET /v4/leagues/{id}/lineup` | `getLineup()` | `LineupResponse` (`it`) | `player_providers` (Lineup-Fetch), `recommendation_providers` | – |
| `POST /v4/leagues/{id}/lineup` | `updateLineup()` | – (ungenutzt) | – | – |
| `GET /v4/leagues/{id}/teamcenter/myeleven` | `getMyEleven()` | Map (live Punkte) | `myElevenProvider` | `live_screen` |

## Transfermarkt

| Endpunkt | Methode | Parsing | Provider | UI |
|---|---|---|---|---|
| `GET /v4/leagues/{id}/market` | `getMarketAvailable()` | `List<MarketPlayer>` via `normalizeMarketPlayerJson` | `market_providers` (`marketPlayersProvider`), `transfer_planner_provider` | `market_page`, `market_screen` |
| `POST /v4/leagues/{id}/market` | `sellPlayer()` | `BidResponse` (ungenutzt) | – | – |
| `POST .../market/{playerId}/offers` | `buyPlayer()` | `BidResponse` | `buyPlayerProvider` | `buy_player_bottom_sheet` |
| `DELETE .../market/{playerId}` | `removePlayerFromMarket()` | Map | direkt im Screen | `market_screen` |
| `DELETE .../market/{playerId}/sell` | `acceptKickbaseOffer()` | – | direkt im Screen | `market_screen` |
| `DELETE .../offers/{offerId}(/accept|/decline)` | `withdrawOffer()`, `acceptOffer()`, `declineOffer()` | – (ungenutzt) | – | – |

## Spieler-Details

| Endpunkt | Methode | Parsing | Provider | UI |
|---|---|---|---|---|
| `GET .../players/{playerId}` | `getPlayerDetails()` | `PlayerDetailResponse` / Map via `normalizePlayerJson` | `playerDetailsProvider`, `manager_providers`, `budget_calculation_providers`, `dashboard_providers` | `player_detail_screen` |
| `GET .../players/{playerId}/marketvalue/{timeframe}` | `getPlayerMarketValue()` | `MarketValueHistoryResponse` (`it`: `dt`,`mv`) | `playerMarketValueProvider`, `playerMarketValueYearProvider`, `manager_transfer_history_providers`, `budget_calculation_providers` | Player-Detail (Chart) |
| `GET .../players/{playerId}/performance` | `getPlayerStats()` | `PlayerPerformanceResponse` (`it` → Saisons) | `playerPerformanceProvider`, `manager_providers` | Player-Detail |

## Manager (fremde User)

| Endpunkt | Methode | Parsing | Provider | UI |
|---|---|---|---|---|
| `GET .../managers/{userId}/dashboard` | `getManagerDashboard()` | Map | `managerDashboardProvider` | `manager_detail_screen` |
| `GET .../managers/{userId}/performance` | `getManagerPerformance()` | Map | `managerPerformanceProvider` | `manager_detail_screen` |
| `GET .../managers/{userId}/squad` | `getManagerSquad()` | Map via `normalizePlayerJson` | `managerSquadProvider`, `managerSquadEnrichedProvider`, `managerLineup*Provider` | `manager_detail_screen` |

## Achievements, Bonus & Live

| Endpunkt | Methode | Parsing | Provider | UI |
|---|---|---|---|---|
| `GET .../user/achievements` | `getUserAchievements()` | `List<Map>` | `myLeagueAchievementsProvider`, `leagueDerivedAchievementEventsProvider` | Achievements-UI |
| `GET .../user/achievements/{type}` | `getUserAchievementByType()` | Map (`ac` × `er` = Budget-Anteil) | `achievementApiRewardsByNameProvider` | – |
| `GET /v4/bonus/collect` | `collectBonus()` | Map | `collectBonusProvider` | `settings_page` |
| `GET /v4/live/eventtypes` | `getLiveEventTypes()` | Map | `liveEventTypesProvider` | `live_screen` |

## Scouted Players (Watchlist)

| Endpunkt | Methode | Parsing | Provider | UI |
|---|---|---|---|---|
| `GET .../scoutedplayers` | `getScoutedPlayers()` | Map | `scoutedPlayersProvider`, `market_providers` | `market_screen` |
| `POST/DELETE .../scoutedplayers/{playerId}` | `addScoutedPlayer()`, `removeScoutedPlayer()` | – | direkt in UI | `buy_player_bottom_sheet`, `market_screen` |

## Wettbewerb (echte Liga-Stats, competitionId meist „1")

| Endpunkt | Methode | Parsing | Provider | UI |
|---|---|---|---|---|
| `GET /v4/competitions/{id}/table` | `getCompetitionTable()` | Map | `competitionTableProvider`, `bundesligaTableProvider`, `recommendation_providers` | `league_table_screen` |
| `GET /v4/competitions/{id}/matchdays` | `getCompetitionMatchdays()` | Map | `competitionMatchdaysProvider`, `recommendation_providers` | – |
| `GET /v4/competitions/{id}/playercenter/{playerId}` | `getPlayerEventHistory()` | Map | `playerEventHistoryProvider`, `currentPlayerEventHistoryProvider` | – |


## Transferhistorie

| Endpunkt | Methode | Parsing | Provider | UI |
|---|---|---|---|---|
| `GET .../managers/{userId}/transfer` | `getTransfers()` | `List<Transfer>` | `transfer_providers` (via `TransferRepository`) | Transfers-Screen |
| `GET .../managers/{userId}/transfer` (paged) | `getManagerTransferHistory()`, `getManagerTransferHistoryPaged()` | Map → `ManagerTransferHistoryEntry` (Service) | `managerTransferHistoryProvider` | – |
| `GET .../players/{playerId}/transferHistory` | `getPlayerTransferHistory()` | Map | `playerTransferHistoryProvider`, `currentPlayerTransferHistoryProvider` | Player-Detail |
| `GET .../players/{playerId}/transfers` | `getPlayerTransfers()` | Map | `playerTransfersProvider` | Player-Detail |

## Noch ungenutzte Endpunkte (Swagger) – vor Neuentwicklung prüfen!

| Endpunkt(en) | Möglicher Nutzen |
|---|---|
| `GET /v4/leagues/{id}/settings` + `/settings/managers` | Echte Liga-Regeln (Steuersatz, Mindestgebot, 250er-Regel) statt hartkodierter Annahmen – Roadmap #1 (`Ideen.md`) |
| `GET /v4/leagues/{id}/activitiesFeed(/{id}/comments)` | Social-Feed, Mitbieter-Identifikation (Lücke BidRecommendationService) – Roadmap #2 |
| `GET /v4/matches/{matchId}/details`, `/betlink` | Live-Spielereignisse – Roadmap #3 |
| `GET /v4/config`, `GET /v4/base/overview` | Globale Konfiguration/Basisdaten |
| `GET /v4/challenges/*` (14 Endpunkte) | Challenges-Feature komplett unangetastet |
| `GET /v4/chat/*` | Chat-Token/-Selektion |
| `GET /v4/competitions/{id}/players(/search)`, `.../players/{id}/marketvalue|performance`, `.../ranking`, `.../overview` | Wettbewerbs-Spielerkatalog/-MW (Parallel zu league-Varianten) |
| `GET /v4/competitions/{id}/teams/{teamId}/teamcenter|teamprofile`, `GET /v4/leagues/{id}/teams/{teamId}/teamprofile/`, `GET /v4/leagues/{id}/users/{userId}/teamcenter` | Team-/Kaderprofile |
| `GET /v4/leagues/{id}/battles/{type}/users` | Battle-Rankings |

