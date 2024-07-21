

import 'package:calculator/calculator.dart';
import 'package:calculator/model/historyentryy.dart';

import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
   await Hive.initFlutter();
  Hive.registerAdapter(HistoryEntryAdapter());
  await Hive.openBox<HistoryEntry>('historyBox'); // Open Hive box for history
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     
      home: calculator(),
    );
  }
}
class HistoryEntryAdapter extends TypeAdapter<HistoryEntry> {
  @override
  final int typeId = 0;

  @override
  HistoryEntry read(BinaryReader reader) {
    return HistoryEntry(
      entry: reader.readString(),
      timestamp: DateTime.parse(reader.readString()),
    );
  }

  @override
  void write(BinaryWriter writer, HistoryEntry obj) {
    writer.writeString(obj.entry);
    writer.writeString(obj.timestamp.toIso8601String());
  }
}