import 'package:kickbasekumpel/data/models/player_model.dart';

String formatTransferCurrency(int value) {
  final sign = value < 0 ? '-' : '';
  final abs = value.abs();
  final raw = abs.toString();
  final buffer = StringBuffer();

  for (var i = 0; i < raw.length; i++) {
    final reverseIndex = raw.length - i;
    buffer.write(raw[i]);
    if (reverseIndex > 1 && reverseIndex % 3 == 1) {
      buffer.write('.');
    }
  }

  return '$sign${buffer.toString()} €';
}

String formatPlayerName(Player player) =>
    '${player.firstName} ${player.lastName}';
