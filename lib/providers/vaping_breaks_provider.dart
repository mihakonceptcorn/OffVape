import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

import 'package:off_vape/models/break.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'inhale.db'),
    onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE inhale_sessions(
          id TEXT PRIMARY KEY,
          timestamp INTEGER NOT NULL,
          type TEXT NOT NULL,
          exercise_type TEXT
        )
      ''');
    },
    version: 1,
  );

  return db;
}

Future<void> clearTable() async {
  final db = await _getDatabase();
  await db.delete('inhale_sessions');
}

Future<List<Break>> getBreaksByDays(int days) async {
  final db = await _getDatabase();

    var start = DateTime.now().subtract(Duration(days: days));
    var end = DateTime.now();

    final startDate = DateTime(start.year, start.month, start.day).millisecondsSinceEpoch;
    final endDate = DateTime(end.year, end.month, end.day).millisecondsSinceEpoch;

    final data = await db.query(
      'inhale_sessions',
      where: 'timestamp BETWEEN ? AND ?',
      whereArgs: [startDate, endDate],
      orderBy: 'timestamp ASC',
    );

    final results = data.map(
      (r) => Break(
        timestamp: DateTime.fromMillisecondsSinceEpoch(r['timestamp'] as int),
        type: BreakType.values.firstWhere((e) => e.name == r['type'] as String),
        exerciseType: r['exercise_type'] as String?,
        id: r['id'] as String
      )
    ).toList();

    return results;
}

class VapingBreaksNotifier extends Notifier<List<Break>> {
  @override
  List<Break> build() {
    return [];
  }

  void addVapeBreak() async {
    final db = await _getDatabase();
    var newBreak = Break(timestamp: DateTime.now(), type: BreakType.inhale, exerciseType: null);

    db.insert('inhale_sessions', {
      'id': newBreak.id,
      'timestamp': newBreak.timestamp.millisecondsSinceEpoch,
      'type': newBreak.type.name,
      'exercise_type': newBreak.exerciseType,
    });

    state = [...state, newBreak];
  }

  void addSubstitute(String exercise) async {
    final db = await _getDatabase();
    var newBreak = Break(timestamp: DateTime.now(), type: BreakType.exercise, exerciseType: exercise);

    db.insert('inhale_sessions', {
      'id': newBreak.id,
      'timestamp': newBreak.timestamp.millisecondsSinceEpoch,
      'type': newBreak.type.name,
      'exercise_type': newBreak.exerciseType,
    });

    state = [...state, newBreak];
  }

  Future<void> getCurrentBreaks() async {
    final db = await _getDatabase();

    final date = DateTime.now();

    final startOfDay = DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999).millisecondsSinceEpoch;

    final data = await db.query(
      'inhale_sessions',
      where: 'timestamp BETWEEN ? AND ?',
      whereArgs: [startOfDay, endOfDay],
      orderBy: 'timestamp ASC',
    );

    final results = data.map(
      (r) => Break(
        timestamp: DateTime.fromMillisecondsSinceEpoch(r['timestamp'] as int),
        type: BreakType.values.firstWhere((e) => e.name == r['type'] as String),
        exerciseType: r['exercise_type'] as String?,
        id: r['id'] as String
      )
    ).toList();

    state = results;
  }
}

final vapingBreaksProvider = NotifierProvider<VapingBreaksNotifier, List<Break>>(
  VapingBreaksNotifier.new,
);