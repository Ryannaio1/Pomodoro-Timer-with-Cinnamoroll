import 'package:flutter/material.dart';
import 'dart:async';
import 'todaylist.dart';
import 'src.dart';
import 'fontstyle.dart';
import 'main.dart';
import 'finished task.dart';

final List<TodoItem> _finishedItems = [];

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final List<TodoItem> _items = [];
  final TextEditingController _controller = TextEditingController();

  void _addItem(String title) {
    setState(() {
      _items.add(TodoItem(title: title));
    });
    _controller.clear();
  }

  void _handleTaskCompletion(TodoItem item) {
    setState(() {
      _items.remove(item);
      _finishedItems.add(item);
    });
    _navigateToFinishedTasks(context);
  }

  void _navigateToFinishedTasks(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => FinishedTasksPage(finishedItems: _finishedItems),
    )).then((deletedItem) {
      if (deletedItem != null) {
        setState(() {
          _finishedItems.remove(deletedItem);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('待辦列表',style: TextStyle(fontFamily: 'Font',color: Colors.blue)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              onSubmitted: _addItem,
              decoration: InputDecoration(
                labelText: '待辦事項',
                labelStyle: TextStyle(fontFamily: 'Font',color: Colors.blue),
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _addItem(_controller.text),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return ListTile(
                  title: Text(item.title),
                  leading: IconButton(
                    icon: Icon(Icons.check, color: item.isDone ? Colors.green : Colors.grey),
                    onPressed: () => _handleTaskCompletion(item),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _items.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
