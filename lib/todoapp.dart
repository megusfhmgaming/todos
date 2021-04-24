import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'bottombar.dart';

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 18, horizontal: 36),
          children: [
            const Title(),
            const Input(),
            const Toolbar(),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}

class Title extends StatelessWidget {
  const Title({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      'todos',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 100,
        fontWeight: FontWeight.w100,
        color: Color.fromARGB(37, 47, 47, 247),
      ),
    );
  }
}

final _inputController = TextEditingController();
final todoListProvider = StateNotifierProvider((_) => TodoList([]));

class Input extends StatelessWidget {
  const Input({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
      ),
      controller: _inputController,
      onSubmitted: (value) {
        context.read(todoListProvider.notifier).addTodo(value);
        _inputController.clear();
      },
    );
  }
}

class Todo {
  Todo({required this.id, required this.description, this.completed = false});
  String id;
  String description;
  bool completed;
}

class TodoList extends StateNotifier {
  TodoList(List<Todo> initData) : super(initData);
  void addTodo(String desc) {
    state = [
      ...state,
      Todo(id: UniqueKey().toString(), description: desc),
    ];
  }
}

enum TodoFilter { All, Active, COmpleted }
class Toolbar extends StatelessWidget {
  const Toolbar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: () {},
          child: Text('All'),
        ),
      ],
    );
  }
}

final toolbarFilterProvider = StateProvider((_) => TodoFilter.All);
