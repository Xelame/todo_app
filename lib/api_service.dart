import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/todo_model.dart';

class ApiService {
  final String baseUrl = 'https://dummyjson.com/todos';

  Future<TodoResponse> fetchTodos() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return TodoResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load todos');
    }
  }
}
