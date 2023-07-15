import 'package:flutter/material.dart';

class NodeCard extends StatefulWidget {
  final String word;
  final Function(String) onSave;

  const NodeCard({required this.word, required this.onSave});

  @override
  _NodeCardState createState() => _NodeCardState();
}

class _NodeCardState extends State<NodeCard> {
  late TextEditingController _textEditingController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.word);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveWord() {
    final updatedWord = _textEditingController.text;
    widget.onSave(updatedWord);
    _toggleEditMode();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _isEditing
            ? TextField(
          controller: _textEditingController,
          onSubmitted: (_) => _saveWord(),
        )
            : GestureDetector(
          onTap: _toggleEditMode,
          child: Text(widget.word),
        ),
      ),
    );
  }
}
