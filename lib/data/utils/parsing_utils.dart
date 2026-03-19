/// Normalisiert einen Spielernamen für den Ligainsider-Foto-Lookup.
///
/// Muss identisch zur TypeScript `normalizePlayerName`-Funktion im Scraper sein,
/// damit Dart-Lookup-Keys mit den Firestore-Document-IDs übereinstimmen.
/// Abdeckung: deutsche, kroatische, spanische, französische, türkische,
/// polnische, tschechische und weitere europäische Sonderzeichen.
String normalizeForLigainsider(String name) {
  var s = name.toLowerCase();
  const map = {
    'á': 'a',
    'à': 'a',
    'ä': 'a',
    'â': 'a',
    'ã': 'a',
    'å': 'a',
    'é': 'e',
    'è': 'e',
    'ë': 'e',
    'ê': 'e',
    'í': 'i',
    'ì': 'i',
    'ï': 'i',
    'î': 'i',
    'ó': 'o',
    'ò': 'o',
    'ö': 'o',
    'ô': 'o',
    'õ': 'o',
    'ø': 'o',
    'ú': 'u',
    'ù': 'u',
    'ü': 'u',
    'û': 'u',
    'ñ': 'n',
    'ň': 'n',
    'ç': 'c',
    'č': 'c',
    'ć': 'c',
    'š': 's',
    'ş': 's',
    'ž': 'z',
    'ź': 'z',
    'ż': 'z',
    'đ': 'd',
    'ð': 'd',
    'ß': 'ss',
    'ł': 'l',
    'ľ': 'l',
    'ř': 'r',
    'ť': 't',
    'ď': 'd',
  };
  for (final entry in map.entries) {
    s = s.replaceAll(entry.key, entry.value);
  }
  // Alle verbleibenden Nicht-ASCII-Buchstaben entfernen.
  // Bindestriche (-) und Punkte (.) BLEIBEN erhalten – identisch zum
  // TypeScript normalizePlayerName() im Ligainsider-Scraper, damit die
  // Firestore-Document-IDs (z. B. "a. amaimouni-echghouyab") korrekt
  // als Lookup-Keys erkannt werden.
  s = s.replaceAll(RegExp(r'[^a-z0-9 .\-]'), '');
  s = s.replaceAll(RegExp(r'\s+'), ' ').trim();
  return s;
}

/// Sucht eine Foto-URL in der Ligainsider-Foto-Map.
/// Versucht zuerst den vollständigen Namen, dann Fallback auf Nachname-Endung.
String? lookupLigainsiderPhoto(
  Map<String, String>? photoMap,
  String firstName,
  String lastName,
) {
  if (photoMap == null || photoMap.isEmpty) return null;
  final fullNorm = normalizeForLigainsider('$firstName $lastName'.trim());
  final lastNorm = normalizeForLigainsider(lastName.trim());
  return photoMap[fullNorm] ??
      (lastNorm.isNotEmpty
          ? photoMap.entries
                .where((e) => e.key.endsWith(' $lastNorm'))
                .firstOrNull
                ?.value
          : null);
}

Map<String, dynamic> normalizePlayerJson(Map<String, dynamic> json) {
  final Map<String, dynamic> copy = Map<String, dynamic>.from(json);

  // Ensure required string fields exist
  // 'pi' is the player ID in manager-squad endpoint responses
  copy['id'] =
      copy['id']?.toString() ??
      copy['pi']?.toString() ??
      copy['i']?.toString() ??
      '';

  // Names - handle both long format (fn, ln) and squad format (n / pn)
  if ((copy['firstName'] == null || copy['firstName'] == '') &&
      copy['fn'] != null) {
    copy['firstName'] = copy['fn'];
  }
  if ((copy['lastName'] == null || copy['lastName'] == '') &&
      copy['ln'] != null) {
    copy['lastName'] = copy['ln'];
  }

  // If only 'n' (name) exists, split it.
  // A single-word display name (e.g. "Baumgartner") is the family/last name.
  // Multiple words (e.g. "Thomas Müller") → first word = first name, rest = last name.
  if ((copy['firstName'] == null || copy['firstName'] == '') &&
      copy['n'] != null) {
    final fullName = copy['n'].toString().trim();
    final parts = fullName.split(' ');
    if (parts.length >= 2) {
      copy['firstName'] = parts.first;
      copy['lastName'] = parts.skip(1).join(' ');
    } else if (parts.isNotEmpty && parts.first.isNotEmpty) {
      // Single word → this is the last/family name; first name is unknown
      copy['firstName'] = '';
      copy['lastName'] = parts.first;
    }
  }

  // Squad endpoint liefert fn (Vorname) + n (Nachname) getrennt – aber kein ln.
  // Falls firstName bereits via fn gesetzt, lastName aber noch leer ist, n als lastName verwenden.
  if ((copy['lastName'] == null || copy['lastName'] == '') &&
      copy['n'] != null) {
    copy['lastName'] = copy['n'].toString().trim();
  }

  // 'pn' = player name in manager-squad endpoint (full name in one field)
  if ((copy['firstName'] == null || copy['firstName'] == '') &&
      copy['pn'] != null) {
    final fullName = copy['pn'].toString().trim();
    final parts = fullName.split(' ');
    if (parts.isNotEmpty) {
      copy['firstName'] = parts.first;
      copy['lastName'] = parts.length > 1 ? parts.skip(1).join(' ') : '';
    }
  }

  copy['firstName'] = (copy['firstName'] ?? '').toString();
  copy['lastName'] = (copy['lastName'] ?? '').toString();

  // Team
  if ((copy['teamName'] == null || copy['teamName'] == '') &&
      copy['tn'] != null) {
    copy['teamName'] = copy['tn'];
  }
  if ((copy['teamId'] == null || copy['teamId'] == '') &&
      copy['team'] != null) {
    copy['teamId'] = copy['team'];
  }
  if ((copy['teamId'] == null || copy['teamId'] == '') && copy['tid'] != null) {
    copy['teamId'] = copy['tid'].toString();
  }
  copy['teamName'] = (copy['teamName'] ?? '').toString();
  copy['teamId'] = (copy['teamId'] ?? '').toString();

  // Profile – try pbu, pim, plpt (player profile thumbnail), i (image)
  if ((copy['profileBigUrl'] == null || copy['profileBigUrl'] == '') &&
      copy['pbu'] != null) {
    copy['profileBigUrl'] = copy['pbu'];
  }
  if ((copy['profileBigUrl'] == null || copy['profileBigUrl'] == '') &&
      copy['pim'] != null) {
    copy['profileBigUrl'] = copy['pim'];
  }
  if ((copy['profileBigUrl'] == null || copy['profileBigUrl'] == '') &&
      copy['plpt'] != null) {
    copy['profileBigUrl'] = copy['plpt'];
  }
  // 'i' can be image URL in player-detail response
  if ((copy['profileBigUrl'] == null || copy['profileBigUrl'] == '') &&
      copy['i'] != null &&
      copy['i'].toString().startsWith('http')) {
    copy['profileBigUrl'] = copy['i'];
  }
  copy['profileBigUrl'] = (copy['profileBigUrl'] ?? '').toString();

  // Numeric fields - attempt to coerce
  copy['position'] = _toIntSafe(copy['position'] ?? copy['pos']);
  // 'shn' = shirt/jersey number in player-detail responses
  copy['number'] = _toIntSafe(copy['number'] ?? copy['shn']);
  copy['averagePoints'] = _toDoubleSafe(copy['averagePoints'] ?? copy['ap']);
  // 'tp' = total points in player-detail responses; 'p' is a fallback
  copy['totalPoints'] = _toIntSafe(
    copy['totalPoints'] ?? copy['tp'] ?? copy['p'],
  );
  copy['marketValue'] = _toIntSafe(copy['marketValue'] ?? copy['mv']);
  copy['marketValueTrend'] = _toIntSafe(
    copy['marketValueTrend'] ?? copy['mvt'],
  );
  copy['tfhmvt'] = _toIntSafe(copy['tfhmvt']);
  copy['prlo'] = _toIntSafe(copy['prlo']);
  copy['stl'] = _toIntSafe(copy['stl']);
  copy['status'] = _toIntSafe(copy['status'] ?? copy['st']);

  // userOwnsPlayer boolean – 'sl' = self-listed / owned in player-detail
  if (copy['userOwnsPlayer'] is bool) {
    // ok
  } else if (copy['userOwnsPlayer'] != null) {
    final val = copy['userOwnsPlayer'].toString().toLowerCase();
    copy['userOwnsPlayer'] = (val == 'true' || val == '1');
  } else if (copy['sl'] is bool) {
    copy['userOwnsPlayer'] = copy['sl'];
  } else {
    copy['userOwnsPlayer'] = false;
  }

  return copy;
}

Map<String, dynamic> normalizeLeagueJson(Map<String, dynamic> json) {
  final Map<String, dynamic> copy = Map<String, dynamic>.from(json);

  // Normalize 'cu' (current user) fields if present
  if (copy['cu'] is Map<String, dynamic>) {
    final cu = Map<String, dynamic>.from(copy['cu']);

    if ((cu['budget'] == null) && cu['b'] != null) {
      cu['budget'] = _toIntSafe(cu['b']);
    }
    if ((cu['teamValue'] == null) && cu['tv'] != null) {
      cu['teamValue'] = _toIntSafe(cu['tv']);
    }
    if ((cu['points'] == null) && cu['p'] != null) {
      cu['points'] = _toIntSafe(cu['p']);
    }
    if ((cu['placement'] == null) && cu['pl'] != null) {
      cu['placement'] = _toIntSafe(cu['pl']);
    }

    // Ensure required fields exist with defaults handled later by model
    copy['cu'] = cu;
  }

  // Map short keys for league itself if needed
  if ((copy['n'] == null || copy['n'] == '') && copy['name'] != null) {
    copy['n'] = copy['name'];
  }

  return copy;
}

/// Normalisiert einen Market-Spieler von der Kickbase API.
/// Die API liefert abgekürzte Keys (i, fn, n, pos, mv, prc, …) und
/// kein vollständiges seller-Objekt; diese Funktion ergänzt alles, was
/// [MarketPlayer.fromJson] benötigt.
Map<String, dynamic> normalizeMarketPlayerJson(Map<String, dynamic> json) {
  final copy = Map<String, dynamic>.from(json);

  // id
  copy['id'] = copy['id']?.toString() ?? copy['i']?.toString() ?? '';

  // Names
  if (copy['firstName'] == null && copy['fn'] != null) {
    copy['firstName'] = copy['fn'];
  }
  if (copy['lastName'] == null && copy['ln'] != null) {
    copy['lastName'] = copy['ln'];
  }
  // 'n' = last name in market response
  if (copy['lastName'] == null || copy['lastName'] == '') {
    copy['lastName'] = (copy['n'] ?? '').toString();
  }
  copy['firstName'] = (copy['firstName'] ?? '').toString();
  copy['lastName'] = (copy['lastName'] ?? '').toString();

  // Team
  copy['teamId'] = (copy['teamId'] ?? copy['tid'] ?? '').toString();
  copy['teamName'] = (copy['teamName'] ?? copy['tn'] ?? '').toString();

  // Profile
  copy['profileBigUrl'] =
      (copy['profileBigUrl'] ?? copy['pbu'] ?? copy['pim'] ?? '').toString();

  // Numerics
  copy['position'] = _toIntSafe(copy['position'] ?? copy['pos']);
  copy['number'] = _toIntSafe(copy['number']);
  copy['averagePoints'] = _toDoubleSafe(copy['averagePoints'] ?? copy['ap']);
  copy['totalPoints'] = _toIntSafe(copy['totalPoints'] ?? copy['p']);
  copy['marketValue'] = _toIntSafe(copy['marketValue'] ?? copy['mv']);
  copy['marketValueTrend'] = _toIntSafe(
    copy['marketValueTrend'] ?? copy['mvt'],
  );
  // price: 'prc' in market list, 'price' in other contexts
  copy['price'] = _toIntSafe(copy['price'] ?? copy['prc']);

  // exs = Sekunden bis zum Ablauf des Angebots (ab jetzt).
  // Daraus berechnen wir den absoluten Ablaufzeitpunkt.
  copy['exs'] = _toIntSafe(copy['exs']);
  final exsSeconds = copy['exs'] as int;
  if (exsSeconds > 0) {
    copy['expiry'] = DateTime.now()
        .add(Duration(seconds: exsSeconds))
        .toIso8601String();
  } else {
    // Fallback: dt-Feld (Einstellungszeitpunkt) – bereits abgelaufen
    copy['expiry'] = (copy['expiry'] ?? copy['dt'] ?? '').toString();
  }
  copy['offers'] = _toIntSafe(copy['offers'] ?? copy['ofc']);
  copy['status'] = _toIntSafe(copy['status'] ?? copy['st']);
  copy['stl'] = _toIntSafe(copy['stl']);
  copy['prlo'] = copy['prlo'] != null ? _toIntSafe(copy['prlo']) : null;

  // seller: construct from 'uoid' (user-offer-id = seller's user id) when absent
  if (copy['seller'] == null) {
    final sellerId = (copy['uoid'] ?? '').toString();
    copy['seller'] = {'id': sellerId, 'name': ''};
  }

  // owner: optional, keep as-is or null
  copy['owner'] = copy['owner'] ?? copy['u'];

  return copy;
}

int _toIntSafe(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  final s = value.toString();
  return int.tryParse(s) ?? (double.tryParse(s)?.toInt() ?? 0);
}

double _toDoubleSafe(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  final s = value.toString();
  return double.tryParse(s) ?? 0.0;
}
