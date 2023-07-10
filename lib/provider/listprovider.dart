import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/item_mode.dart';
import 'package:http/http.dart' as http;

class ListProviderNotifier extends StateNotifier<List<ItemModel>> {
  ListProviderNotifier() : super([]);
  void addtoList(ItemModel model) async {
    final url =
        Uri.parse('https://github.com/JangamRuthvik/todobackend.git/post');
    http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': model.name, 'isChecked': model.isChecked}));
    state = [...state, model];
  }

  Future<void> getList() async {
    final url =
        Uri.parse("https://github.com/JangamRuthvik/todobackend.git/getList");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decResp = json.decode(response.body);
      // print(decResp);
      // print(decResp.length);
      List<ItemModel> items = [];
      for (var ele in decResp) {
        items.add(ItemModel(
            id: ele["_id"], name: ele["name"], isChecked: ele["ischecked"]));
        // print('object');
      }
      state = items;
    }
  }

  void deleteItem(ItemModel model) async {
    // int idx = state.indexOf(model);
    final url =
        Uri.parse("https://github.com/JangamRuthvik/todobackend.git/delete");
    // print('hey hi');
    http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': model.id,
      }),
    );
    List<ItemModel> a = state;
    a.remove(model);
    state = a;
  }
}

final listProvider =
    StateNotifierProvider<ListProviderNotifier, List<ItemModel>>(
        (ref) => ListProviderNotifier());
