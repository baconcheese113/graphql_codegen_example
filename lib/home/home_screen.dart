import 'package:flutter/material.dart';
import 'package:graphql_codegen_example/home/launches/launches_tab.dart';
import 'package:graphql_codegen_example/home/~graphql/__generated__/home_screen.query.graphql.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // FIXME useContext error when using hooks
    // final hook = useQuery$HomeScreen();
    // FIXME widget no longer building
    return Query$HomeScreen$Widget(builder: (result, {fetchMore, refetch}) {
      if (result.data?.isEmpty ?? true) return const Center(child: CircularProgressIndicator());
      final data = Query$HomeScreen.fromJson(result.data!);
      return Scaffold(
        appBar: AppBar(title: const Text("SpaceX DB")),
        body: [
          LaunchesTab(queryFrag: data, refetch: refetch!),
          const SizedBox(),
        ][_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.rocket_launch), label: "Launches"),
            BottomNavigationBarItem(icon: Icon(Icons.hourglass_empty), label: "To-Do"),
          ],
          currentIndex: _selectedIndex,
          onTap: (newIndex) => setState(() => _selectedIndex = newIndex),
        ),
      );
    });
  }
}
