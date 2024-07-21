
import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 0)
class HistoryEntry {
  @HiveField(0)
  String entry;

  @HiveField(1)
  DateTime timestamp;

  HistoryEntry({required this.entry, required this.timestamp});
}