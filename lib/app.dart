import 'package:flutter/material.dart';
import 'package:graphql_codegen_example/home/home_screen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
        client: ValueNotifier(GraphQLClient(
          cache: GraphQLCache(store: HiveStore()),
          link: HttpLink("https://api.spacex.land/graphql/"),
        )),
        child: MaterialApp(
          title: "SpaceX DB",
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
              default:
                return MaterialPageRoute(builder: (_) => const HomeScreen());
            }
          },
          theme: ThemeData.from(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
          ),
        ));
  }
}
