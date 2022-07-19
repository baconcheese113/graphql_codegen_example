import 'package:flutter/material.dart';
import 'package:graphql_codegen_example/home/launches/launch_card_body.dart';
import 'package:graphql_codegen_example/home/launches/~graphql/__generated__/launches.fragments.graphql.dart';

class LaunchCard extends StatefulWidget {
  final Fragment$launchCard_launch launchFrag;
  const LaunchCard({Key? key, required this.launchFrag}) : super(key: key);

  @override
  State<LaunchCard> createState() => _LaunchCardState();
}

class _LaunchCardState extends State<LaunchCard> {
  @override
  Widget build(BuildContext context) {
    final launchFrag = widget.launchFrag;

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
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      launchFrag.mission_name!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        launchFrag.rocket?.rocketName ?? "N/A",
                        overflow: TextOverflow.ellipsis,
                      )),
                ],
              ),
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
