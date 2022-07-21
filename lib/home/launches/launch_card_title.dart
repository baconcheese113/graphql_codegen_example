import 'package:flutter/material.dart';
import 'package:graphql_codegen_example/home/launches/~graphql/__generated__/launches.fragments.graphql.dart';

class LaunchCardTitle extends StatelessWidget {
  final Fragment$launchCardTitle_launch launchFrag;
  const LaunchCardTitle({Key? key, required this.launchFrag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
