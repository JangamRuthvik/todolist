import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/homepage.dart';

void main() {
  runApp(const MaterialApp(
    home: ProviderScope(child: Todolist()),
  ));
}

