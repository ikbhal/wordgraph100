import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'node.dart';
import 'node_card.dart';

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
  List<Node> _nodes = [];

  void _addNode(String word, Offset position) async {
    final db = await widget.database;
    final id = await db.insert('nodes', {'word': word});

    setState(() {
      _nodes.add(Node(id: id, word: word, position: position));
    });
  }

  Widget _buildNodeWidgets() {
    return Stack(
      children: _nodes.map((node) {
        return Positioned(
          left: node.position.dx,
          top: node.position.dy,
          child: NodeCard(
            node: node,
            onSave: (updatedNode) {
              // Update node in the list or perform any other operations
            },
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Node')),
      body: GestureDetector(
        onTapUp: (details) {
          final RenderBox box = context.findRenderObject() as RenderBox;
          final Offset position = box.globalToLocal(details.globalPosition);
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('New Node'),
              content: TextField(
                onSubmitted: (value) {
                  _addNode(value, position);
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
        child: _buildNodeWidgets(),
      ),
    );
  }
}

