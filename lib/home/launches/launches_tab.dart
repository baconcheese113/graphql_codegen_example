import 'package:flutter/material.dart';
import 'package:graphql_codegen_example/home/launches/launch_card.dart';
import 'package:graphql_codegen_example/home/launches/~graphql/__generated__/launches.fragments.graphql.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class LaunchesTab extends StatelessWidget {
  final Fragment$launchesTab_query queryFrag;
  final Refetch refetch;
  const LaunchesTab({Key? key, required this.queryFrag, required this.refetch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    queryFrag.launches?.removeWhere((l) => l == null);
    final cardList = queryFrag.launches?.map((l) => LaunchCard(launchFrag: l!)).toList();
    if (cardList?.isEmpty ?? true) {
      return const Center(child: Text("No Launches"));
    }

    return RefreshIndicator(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: cardList!,
        ),
        onRefresh: () async {
          await refetch();
        });
  }
}
