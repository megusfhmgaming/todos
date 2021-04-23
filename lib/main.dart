import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'todoapp.dart';

void main() {
  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('MainApp/build');
    return MaterialApp(
      title: 'todos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoApp(),
    );
  }
}
