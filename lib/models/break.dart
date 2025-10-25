import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum BreakType {inhale, exercise}

class Break {
  Break({
    required this.timestamp,
    required this.type,
    this.exerciseType,
    String? id,
  })
    : id = id ?? uuid.v4();

  final String id;
  final DateTime timestamp;
  final BreakType type;
  final String? exerciseType;
}