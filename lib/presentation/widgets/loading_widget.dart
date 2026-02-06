import 'package:flutter/material.dart';

/// Loading Widget
///
/// Zeigt einen zentrierten CircularProgressIndicator an.
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
