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
            const SizedBox(height: 8),
            const Toolbar(),
            Consumer(
              builder: (context, watch, child) {
                final todoList = watch(todoListFilteredProvider);
                return Column(
                  children: [
                    for (final todo in todoList) ...[
                      ProviderScope(
                        overrides: [
                          todoItemProvider.overrideWithValue(todo),
                        ],
                        child: TodoItem(),
                      ),
                      SizedBox(height: 12),
                    ],
                  ],
                );
              },
            ),
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
final todoListProvider =
    StateNotifierProvider<TodoList, List<Todo>>((_) => TodoList([]));
final todoListFilteredProvider = Provider<List<Todo>>((ref) {
  final filter = ref.watch(toolbarFilterProvider);
  final todoList = ref.watch(todoListProvider);
  switch (filter.state) {
    case TodoFilter.Active:
      return todoList.where((element) => !element.completed).toList();
    case TodoFilter.Completed:
      return todoList.where((element) => element.completed).toList();
    default:
      return todoList.toList();
  }
});

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

class TodoList extends StateNotifier<List<Todo>> {
  TodoList(List<Todo> initData) : super(initData);
  void addTodo(String desc) {
    state = [
      ...state,
      Todo(id: UniqueKey().toString(), description: desc),
    ];
  }

  void toggleTodo(String id) {
    state = [
      for (final todo in state)
        todo.id == id
            ? Todo(
                id: id,
                description: todo.description,
                completed: !todo.completed,
              )
            : todo,
    ];
  }
}

enum TodoFilter { All, Active, Completed }
final toolbarFilterProvider = StateProvider((_) => TodoFilter.All);

class Toolbar extends StatelessWidget {
  const Toolbar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final selectFilter = watch(toolbarFilterProvider).state;

      TextStyle txtStyle(TodoFilter filter) {
        return filter == selectFilter
            ? TextStyle(
                fontSize: 18,
                color: Colors.cyan,
              )
            : TextStyle(
                fontSize: 18,
                color: Colors.black38,
              );
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () {
              context.read(toolbarFilterProvider).state = TodoFilter.All;
            },
            child: Text(
              'All',
              style: txtStyle(TodoFilter.All),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read(toolbarFilterProvider).state = TodoFilter.Active;
            },
            child: Text(
              'Active',
              style: txtStyle(TodoFilter.Active),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read(toolbarFilterProvider).state = TodoFilter.Completed;
            },
            child: Text(
              'Completed',
              style: txtStyle(TodoFilter.Completed),
            ),
          ),
        ],
      );
    });
  }
}

final todoItemProvider = ScopedProvider<Todo>(null);

class TodoItem extends StatelessWidget {
  const TodoItem();
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      child: Consumer(builder: (context, watch, child) {
        final todo = watch(todoItemProvider);
        return ListTile(
          leading: Checkbox(
            onChanged: (bool? value) {
              context.read(todoListProvider.notifier).toggleTodo(todo.id);
            },
            value: todo.completed,
          ),
          title: Text('${todo.description}'),
        );
      }),
    );
  }
}
