Map<String, dynamic> normalizePlayerJson(Map<String, dynamic> json) {
  final Map<String, dynamic> copy = Map<String, dynamic>.from(json);

  // Ensure required string fields exist
  copy['id'] = copy['id']?.toString() ?? copy['i']?.toString() ?? '';

  // Names - handle both long format (fn, ln) and squad format (n)
  if ((copy['firstName'] == null || copy['firstName'] == '') &&
      copy['fn'] != null) {
    copy['firstName'] = copy['fn'];
  }
  if ((copy['lastName'] == null || copy['lastName'] == '') &&
      copy['ln'] != null) {
    copy['lastName'] = copy['ln'];
  }

  // If only 'n' (name) exists, split it
  if ((copy['firstName'] == null || copy['firstName'] == '') &&
      copy['n'] != null) {
    final fullName = copy['n'].toString().trim();
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

  // Profile
  if ((copy['profileBigUrl'] == null || copy['profileBigUrl'] == '') &&
      copy['pbu'] != null) {
    copy['profileBigUrl'] = copy['pbu'];
  }
  if ((copy['profileBigUrl'] == null || copy['profileBigUrl'] == '') &&
      copy['pim'] != null) {
    copy['profileBigUrl'] = copy['pim'];
  }
  copy['profileBigUrl'] = (copy['profileBigUrl'] ?? '').toString();

  // Numeric fields - attempt to coerce
  copy['position'] = _toIntSafe(copy['position'] ?? copy['pos']);
  copy['number'] = _toIntSafe(copy['number']);
  copy['averagePoints'] = _toDoubleSafe(copy['averagePoints'] ?? copy['ap']);
  copy['totalPoints'] = _toIntSafe(copy['totalPoints'] ?? copy['p']);
  copy['marketValue'] = _toIntSafe(copy['marketValue'] ?? copy['mv']);
  copy['marketValueTrend'] = _toIntSafe(
    copy['marketValueTrend'] ?? copy['mvt'],
  );
  copy['tfhmvt'] = _toIntSafe(copy['tfhmvt']);
  copy['prlo'] = _toIntSafe(copy['prlo']);
  copy['stl'] = _toIntSafe(copy['stl']);
  copy['status'] = _toIntSafe(copy['status'] ?? copy['st']);

  // userOwnsPlayer boolean

  // userOwnsPlayer boolean
  if (copy['userOwnsPlayer'] is bool) {
    // ok
  } else if (copy['userOwnsPlayer'] != null) {
    final val = copy['userOwnsPlayer'].toString().toLowerCase();
    copy['userOwnsPlayer'] = (val == 'true' || val == '1');
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
