import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_codegen_example/home/launches/launches_tab.dart';
import 'package:graphql_codegen_example/home/users/users_tab.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);

    final handleAddUser = useCallback(() {
      Navigator.pushNamed(context, '/add-user');
    }, []);

    return Scaffold(
      appBar: AppBar(title: const Text("SpaceX DB"), centerTitle: true),
      body: [
        const LaunchesTab(),
        const UsersTab(),
      ][selectedIndex.value],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.rocket_launch), label: "Launches"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Users"),
        ],
        currentIndex: selectedIndex.value,
        onTap: (newIndex) => selectedIndex.value = newIndex,
      ),
      floatingActionButton: selectedIndex.value == 1
          ? FloatingActionButton.extended(
              icon: const Icon(Icons.add),
              label: const Text("Add User"),
              onPressed: handleAddUser,
            )
          : null,
    );
  }
}
