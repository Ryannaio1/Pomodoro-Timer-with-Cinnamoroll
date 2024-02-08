import 'package:flutter/material.dart';
import 'dart:async';
import 'todaylist.dart';
import 'src.dart';
import 'fontstyle.dart';
import 'main.dart';

class FinishedTasksPage extends StatelessWidget {
  final List<TodoItem> finishedItems;
  FinishedTasksPage({Key? key, required this.finishedItems}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('已完成的任務',style:TextStyle(fontFamily: 'Font',color: Colors.blue)),
      ),
      body: ListView.builder(
        itemCount: finishedItems.length,
        itemBuilder: (context, index) {
          final item = finishedItems[index];
          return ListTile(
            title: Text(item.title, style: TextStyle(decoration: TextDecoration.lineThrough,fontFamily: 'Font',color: Colors.blue)),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // 由於此頁面為 StatelessWidget，需要通過某種方式通知上一頁刪除此項目，例如使用 Navigator.pop()
                Navigator.of(context).pop(item);
              },
            ),
          );
        },
      ),
    );
  }
}
