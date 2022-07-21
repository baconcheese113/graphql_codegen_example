import 'package:flutter/material.dart';
import 'package:graphql_codegen_example/home/launches/launch_card_body.dart';
import 'package:graphql_codegen_example/home/launches/launch_card_title.dart';
import 'package:graphql_codegen_example/home/launches/~graphql/__generated__/launches.fragments.graphql.dart';

class LaunchCard extends StatelessWidget {
  final Fragment$launchCard_launch launchFrag;
  const LaunchCard({Key? key, required this.launchFrag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String getLaunchTime() {
      final launchTime = launchFrag.launch_date_utc;
      if (launchTime != null) return "${launchTime.year}-${launchTime.month}-${launchTime.day}";
      return "";
    }

    final success = launchFrag.launch_success;
    IconData getSuccessIcon() {
      if (success == null) return Icons.question_mark;
      return success ? Icons.check_circle : Icons.error;
    }

    Color getSuccessColor() {
      if (success == null) return Colors.white;
      return success ? Colors.green : Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: LaunchCardTitle(launchFrag: launchFrag),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(getLaunchTime()),
                  Text(launchFrag.launch_site?.site_name_long ?? ""),
                ],
              ),
              trailing: Icon(getSuccessIcon(), color: getSuccessColor()),
            ),
            LaunchCardBody(launchFrag: launchFrag),
          ],
        ),
      ),
    );
  }
}
