import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/screen_size.dart';
import '../../screens/ligainsider/ligainsider_screen.dart';

/// Ligainsider Page - Standalone page without tabs
class LigainsiderPage extends ConsumerWidget {
  const LigainsiderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const LigainsiderScreen();
  }
}
