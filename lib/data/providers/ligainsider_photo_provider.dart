import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/firestore_repositories.dart';
import '../../domain/repositories/repository_interfaces.dart';

/// FutureProvider zum Triggern der Cloud Function für Ligainsider Photo-Updates
///
/// Triggert die Google Cloud Function, die automatisch Spielerfotos von
/// ligainsider.de scraped und in Firestore speichert.
///
/// Die Cloud Function läuft auch automatisch täglich um 02:00 UTC via Cloud Scheduler.
///
/// Verwendung:
/// ```dart
/// final updatePhotosAsync = ref.watch(triggerLigainsiderPhotoUpdateProvider);
/// updatePhotosAsync.when(
///   loading: () => CircularProgressIndicator(),
///   error: (error, stack) => Text('Error: $error'),
///   data: (_) => Text('✅ Photo update triggered!'),
/// );
/// ```
///
/// Oder für manuellen Trigger:
/// ```dart
/// FloatingActionButton(
///   onPressed: () async {
///     await ref.read(triggerLigainsiderPhotoUpdateProvider.future);
///   },
///   child: Icon(Icons.refresh),
/// )
/// ```
final triggerLigainsiderPhotoUpdateProvider = FutureProvider<void>((ref) async {
  final playerRepository = ref.watch(playerRepositoryProvider);
  final result = await playerRepository.triggerCloudFunctionPhotoUpdate();

  if (result is Failure) {
    throw Exception(result.message);
  }
});

/// Lädt eine Karte von Spieler-ID → ligainsiderPhotoUrl aus Firestore.
///
/// Wird beim App-Start einmal geladen und cacht die URLs im Arbeitsspeicher,
/// damit der Live-Screen für jeden Spieler keine einzelne Firestore-Anfrage
/// stellen muss.
///
/// Funktioniert auch im Web, da die Daten aus Firestore kommen (kein CORS).
final ligainsiderPhotoMapProvider = FutureProvider<Map<String, String>>((
  ref,
) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('players')
      .where('ligainsiderPhotoUrl', isNotEqualTo: '')
      .get();

  return {
    for (final doc in snapshot.docs)
      doc.id: (doc.data()['ligainsiderPhotoUrl'] as String? ?? ''),
  };
});
