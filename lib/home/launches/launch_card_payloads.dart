import 'package:flutter/material.dart';
import 'package:graphql_codegen_example/home/launches/~graphql/__generated__/launches.fragments.graphql.dart';

class LaunchCardPayloads extends StatelessWidget {
  final Fragment$launchCardPayloads_rocket rocketFrag;
  const LaunchCardPayloads({Key? key, required this.rocketFrag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final payloads = rocketFrag.second_stage?.payloads ?? [];
    payloads.removeWhere((p) => p == null);

    if (payloads.isEmpty) return const SizedBox();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            "${rocketFrag.rocket_name ?? ""} Payload${payloads.length > 1 ? "s" : ""}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Wrap(
            alignment: WrapAlignment.spaceEvenly,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 20,
            spacing: 10,
            children: payloads.map((p) {
              return Column(
                children: [
                  if (p!.nationality != null) Text(p.nationality!),
                  if (p.manufacturer != null) Text(p.manufacturer!, overflow: TextOverflow.ellipsis),
                  if (p.payload_type != null) Text(p.payload_type!),
                  if (p.payload_mass_kg != null) Text("${p.payload_mass_kg!}kg")
                ],
              );
            }).toList())
      ],
    );
  }
}
