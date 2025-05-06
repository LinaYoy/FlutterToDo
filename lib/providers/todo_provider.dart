import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_item.dart';

class TodoProvider with ChangeNotifier {
  List<TodoItem> _items = [];
  String _currentListType = 'tasks';

  List<TodoItem> get items =>
      _items.where((item) => item.listType == _currentListType).toList();
  String get currentListType => _currentListType;

  TodoProvider() {
    _loadItems();
  }

  void setListType(String type) {
    _currentListType = type;
    notifyListeners();
  }

  Future<void> _loadItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final itemsJson = prefs.getStringList('todo_items') ?? [];
      _items = itemsJson
          .map((item) => TodoItem.fromJson(json.decode(item)))
          .toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Ошибка при загрузке данных: $e');
      _items = [];
    }
  }

  Future<void> _saveItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final itemsJson =
          _items.map((item) => json.encode(item.toJson())).toList();
      await prefs.setStringList('todo_items', itemsJson);
    } catch (e) {
      debugPrint('Ошибка при сохранении данных: $e');
    }
  }

  Future<void> addItem(String title) async {
    final newItem = TodoItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      createdAt: DateTime.now(),
      listType: _currentListType,
    );
    _items.add(newItem);
    await _saveItems();
    notifyListeners();
  }

  Future<void> toggleItem(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index].isCompleted = !_items[index].isCompleted;
      await _saveItems();
      notifyListeners();
    }
  }

  Future<void> deleteItem(String id) async {
    _items.removeWhere((item) => item.id == id);
    await _saveItems();
    notifyListeners();
  }
}
