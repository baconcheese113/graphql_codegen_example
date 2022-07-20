import 'package:flutter/material.dart';
import 'package:graphql_codegen_example/home/home_screen.dart';
import 'package:graphql_codegen_example/home/users/add_user_screen.dart';
import 'package:graphql_codegen_example/home/users/users_provider.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: ValueNotifier(GraphQLClient(
        cache: GraphQLCache(store: HiveStore()),
        link: HttpLink("https://api.spacex.land/graphql/"),
      )),
      child: ChangeNotifierProvider<UsersProvider>(
        create: (context) => UsersProvider(),
        child: MaterialApp(
          title: "SpaceX DB",
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/add-user':
                return MaterialPageRoute(builder: (_) => const AddUserScreen());
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
              )),
        ),
      ),
    );
  }
}
