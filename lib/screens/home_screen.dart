import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _textController = TextEditingController();
  int _selectedIndex = 0;

  final List<String> _listTypes = ['Задачи', 'Покупки', 'Заметки'];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _addItem() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      context.read<TodoProvider>().addItem(text);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои списки'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Добавить новый элемент',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addItem,
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<TodoProvider>(
              builder: (context, todoProvider, child) {
                final items = todoProvider.items;
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Dismissible(
                      key: Key(item.id),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16.0),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        todoProvider.deleteItem(item.id);
                      },
                      child: ListTile(
                        leading: Checkbox(
                          value: item.isCompleted,
                          onChanged: (bool? value) {
                            todoProvider.toggleItem(item.id);
                          },
                        ),
                        title: Text(
                          item.title,
                          style: TextStyle(
                            decoration: item.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          context
              .read<TodoProvider>()
              .setListType(_listTypes[index].toLowerCase());
        },
        destinations: _listTypes.map((type) {
          return NavigationDestination(
            icon: Icon(_getIconForListType(type)),
            label: type,
          );
        }).toList(),
      ),
    );
  }

  IconData _getIconForListType(String type) {
    switch (type.toLowerCase()) {
      case 'задачи':
        return Icons.task;
      case 'покупки':
        return Icons.shopping_cart;
      case 'заметки':
        return Icons.note;
      default:
        return Icons.list;
    }
  }
}
