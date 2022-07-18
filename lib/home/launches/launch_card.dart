import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphql_codegen_example/home/launches/~graphql/__generated__/launches.fragments.graphql.dart';

class LaunchCard extends StatefulWidget {
  final Fragment$launchCard_launch launchFrag;
  const LaunchCard({Key? key, required this.launchFrag}) : super(key: key);

  @override
  State<LaunchCard> createState() => _LaunchCardState();
}

class _LaunchCardState extends State<LaunchCard> {
  int _imageIdx = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final numImages = widget.launchFrag.links?.flickr_images?.length ?? 0;
    if (numImages > 1) {
      _timer = Timer.periodic(
          const Duration(seconds: 5), (timer) => setState(() => _imageIdx = (_imageIdx + 1) % numImages));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final launchFrag = widget.launchFrag;
    String getLaunchTime() {
      final launchTime = launchFrag.launch_date_utc;
      if (launchTime != null) return "${launchTime.year}-${launchTime.month}-${launchTime.day}";
      return "";
    }

    IconData getSuccessIcon() {
      if (launchFrag.launch_success == null) return Icons.question_mark;
      return launchFrag.launch_success! ? Icons.check_circle : Icons.error;
    }

    Color getSuccessColor() {
      if (launchFrag.launch_success == null) return Colors.white;
      return launchFrag.launch_success! ? Colors.green : Colors.red;
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
                    // child: Text("Super long mission name", overflow: TextOverflow.ellipsis),
                    child: Text(
                      launchFrag.mission_name!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  // Expanded(child: Text("BIG OL Name Of Rocket", )),
                  Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        launchFrag.rocket?.rocket_name ?? "N/A",
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
            if (launchFrag.links?.flickr_images?.isNotEmpty ?? false)
              Image.network(
                launchFrag.links!.flickr_images![_imageIdx]!,
                height: 200,
              ),
            if (launchFrag.details != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(launchFrag.details!),
              ),
            if (launchFrag.rocket?.second_stage?.payloads?.isNotEmpty ?? false)
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      "Payloads",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...launchFrag.rocket!.second_stage!.payloads!.map((p) {
                    if (p == null) return const SizedBox();
                    return Column(
                      children: [
                        Text(p.nationality!),
                        Text(p.manufacturer!),
                        Text(p.payload_type!),
                        Text("${p.payload_mass_kg!}kg")
                      ],
                    );
                  }).toList(),
                ],
              )
          ],
        ),
      ),
    );
  }
}
