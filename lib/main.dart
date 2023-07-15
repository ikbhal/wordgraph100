import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'node_cart.dart';

// import './node_card.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = openDatabase(
    join(await getDatabasesPath(), 'graph.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE nodes(id INTEGER PRIMARY KEY, word TEXT)',
      );
    },
    version: 1,
  );

  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final Future<Database> database;

  const MyApp({required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Open World Graph',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NodeCreationScreen(database: database),
    );
  }
}

class NodeCreationScreen extends StatefulWidget {
  final Future<Database> database;

  const NodeCreationScreen({required this.database});

  @override
  _NodeCreationScreenState createState() => _NodeCreationScreenState();
}

class _NodeCreationScreenState extends State<NodeCreationScreen> {
  List<String> _nodes = [];

  void _addNode(String word) async {
    final db = await widget.database;
    final id = await db.insert('nodes', {'word': word});
    setState(() {
      _nodes.add(word);
    });
    print('Node added with ID: $id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Node')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _nodes.length,
              itemBuilder: (ctx, index) => NodeCard(
                word: _nodes[index],
                onSave: (_) {},
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('New Node'),
                    content: TextField(
                      onSubmitted: (value) {
                        _addNode(value);
                        Navigator.of(ctx).pop();
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Add Node'),
            ),
          ),
        ],
      ),
    );
  }
}
