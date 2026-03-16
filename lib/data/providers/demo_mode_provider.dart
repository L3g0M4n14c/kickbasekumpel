import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _demoModeKey = 'is_demo_mode';

/// Gibt zurück, ob die App aktuell im Demo-Modus läuft.
///
/// `true` → Demo-Zugangsdaten wurden verwendet, keine echten Kickbase-Calls.
/// `false` → normaler Betrieb mit echten Zugangsdaten.
///
/// Der Zustand wird in [SharedPreferences] gespeichert, damit ein
/// App-Neustart den Demo-Nutzer nicht abmeldet.
class DemoModeNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setDemoMode(bool value) {
    state = value;
  }
}

final demoModeProvider = NotifierProvider<DemoModeNotifier, bool>(
  DemoModeNotifier.new,
);

/// Liest den gespeicherten Demo-Flag aus SharedPreferences.
/// Wird beim App-Start in [_checkAuthStatus] gerufen.
Future<bool> loadDemoModeFlag() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_demoModeKey) ?? false;
}

/// Schreibt den Demo-Flag in SharedPreferences.
Future<void> saveDemoModeFlag({required bool value}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_demoModeKey, value);
}
