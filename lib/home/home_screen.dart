import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_codegen_example/home/launches/launches_tab.dart';
import 'package:graphql_codegen_example/home/~graphql/__generated__/home_screen.query.graphql.dart';

// This widget hierarchy shows how to use graphql_codegen hooks
class HomeScreen extends HookWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);

    final hook = useQuery$HomeScreen();
    final data = hook.result.parsedData;
    if (data == null) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: const Text("SpaceX DB"), centerTitle: true),
      body: [
        LaunchesTab(queryFrag: data, refetch: hook.refetch),
        const SizedBox(),
      ][selectedIndex.value],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.rocket_launch), label: "Launches"),
          BottomNavigationBarItem(icon: Icon(Icons.hourglass_empty), label: "To-Do"),
        ],
        currentIndex: selectedIndex.value,
        onTap: (newIndex) => selectedIndex.value = newIndex,
      ),
    );
  }
}
