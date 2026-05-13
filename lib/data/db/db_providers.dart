import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database.dart';

final databaseProvider = Provider<NoctosDatabase>((ref) {
  final db = NoctosDatabase();
  ref.onDispose(db.close);
  return db;
});
