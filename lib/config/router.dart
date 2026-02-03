import 'package:go_router/go_router.dart';
import '../presentation/pages/home_page.dart';

final goRouterProvider = GoRouter(
  routes: [GoRoute(path: '/', builder: (context, state) => const HomePage())],
);
