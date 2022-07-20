import 'package:flutter/material.dart';
import 'package:graphql_codegen_example/home/launches/launch_card.dart';
import 'package:graphql_codegen_example/home/launches/~graphql/__generated__/launches_tab.query.graphql.dart';
import 'package:graphql_codegen_example/utils.dart';

// This widget hierarchy shows how to use regular graphql_codegen operation widgets
class LaunchesTab extends StatelessWidget {
  const LaunchesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query$LaunchesTab$Widget(builder: (result, {fetchMore, refetch}) {
      final noDataWidget = validateResult(result);
      if (noDataWidget != null) return noDataWidget;

      final data = result.parsedData!;

      data.launches?.removeWhere((l) => l == null);
      final cardList = data.launches?.map((l) => LaunchCard(launchFrag: l!)).toList();
      if (cardList?.isEmpty ?? true) {
        return const Center(child: Text("No Launches"));
      }
      return RefreshIndicator(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: cardList!,
          ),
          onRefresh: () async {
            await refetch!();
          });
    });
  }
}
