import 'package:calculator/model/historyentryy.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';


class HistoryScreen extends StatelessWidget {
  final Box<HistoryEntry> history;
  final Function(int) onDelete;

  HistoryScreen({required this.history, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('History'),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back),
          ),
          backgroundColor: const Color.fromARGB(255, 183, 77, 112),
        ),
        body: ValueListenableBuilder(
          valueListenable: history.listenable(),
          builder: (context, Box<HistoryEntry> box, _) {
            if (box.isEmpty) {
              return Center(
                child: Text(
                  'History Cleared',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25),
                ),
              );
            }

            return ListView.separated(
              itemCount: box.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final entry = box.getAt(index);
                return ListTile(
                  title: Text(entry!.entry, style: TextStyle(fontSize: 20)),
                  subtitle: Text('Time -'
                    '${DateFormat( ' kk:mm').format(entry.timestamp)}',
                    style: TextStyle(fontSize: 15),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      onDelete(index);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
