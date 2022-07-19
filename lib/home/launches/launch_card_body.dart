import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_codegen_example/home/launches/launch_card_payloads.dart';
import 'package:graphql_codegen_example/home/launches/~graphql/__generated__/launches.fragments.graphql.dart';

class LaunchCardBody extends HookWidget {
  final Fragment$launchCardBody_launch launchFrag;
  const LaunchCardBody({Key? key, required this.launchFrag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageIdx = useState(0);
    final timer = useState<Timer?>(null);
    final numImages = launchFrag.links?.flickr_images?.length ?? 0;
    final rocket = launchFrag.rocket;

    useEffect(() {
      if (numImages > 1) {
        timer.value = Timer.periodic(
          const Duration(seconds: 5),
          (timer) => imageIdx.value = (imageIdx.value + 1) % numImages,
        );
      }
      return () {
        timer.value?.cancel();
      };
    }, []);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(children: [
        if (numImages > 0)
          Image.network(
            launchFrag.links!.flickr_images![imageIdx.value]!,
            height: 200,
          ),
        if (launchFrag.details != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(launchFrag.details!),
          ),
        if (rocket != null) LaunchCardPayloads(rocketFrag: rocket),
      ]),
    );
  }
}
