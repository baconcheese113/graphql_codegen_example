import 'package:flutter/material.dart';
import 'package:graphql_codegen_example/app.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() async {
  await initHiveForFlutter();
  runApp(const App());
}
