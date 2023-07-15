import 'package:flutter/material.dart';

class NodeCard extends StatefulWidget {
  final Node node;
  final Function(Node) onSave;

  const NodeCard({required this.node, required this.onSave});

  @override
  _NodeCardState createState() => _NodeCardState();
}

class _NodeCardState extends State<NodeCard> {
  late TextEditingController _textEditingController;
  late FocusNode _textFocusNode;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.node.word);
    _textFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        FocusScope.of(context).requestFocus(_textFocusNode);
      }
    });
  }

  void _saveWord() {
    final updatedWord = _textEditingController.text;
    final updatedNode = Node(
      id: widget.node.id,
      word: updatedWord,
      position: widget.node.position,
    );
    widget.onSave(updatedNode);
    _toggleEditMode();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.node.position.dx,
      top: widget.node.position.dy,
      child: GestureDetector(
        onTap: _toggleEditMode,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _isEditing
                ? TextField(
              controller: _textEditingController,
              focusNode: _textFocusNode,
              onSubmitted: (_) => _saveWord(),
            )
                : Text(widget.node.word),
          ),
        ),
      ),
    );
  }
}
