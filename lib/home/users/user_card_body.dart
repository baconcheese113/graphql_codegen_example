import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graphql_codegen_example/home/users/~graphql/__generated__/users.fragments.graphql.dart';

class UserCardBody extends StatelessWidget {
  final Fragment$userCardBody_users usersFrag;
  const UserCardBody({Key? key, required this.usersFrag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (usersFrag.rocket == null) return const SizedBox();
    return SizedBox(
        height: 150,
        width: 300,
        child: Stack(
          children: [
            if (usersFrag.name != null)
              Positioned(
                top: 30,
                left: 10,
                child: Text("${usersFrag.name!}'s favorite rocket:"),
              ),
            Positioned(
              top: 80,
              left: 50,
              child: Transform.rotate(
                angle: pi * (Random().nextDouble() - .5) * .1,
                child: Text(
                  usersFrag.rocket!,
                  style: TextStyle(
                    fontSize: 24,
                    color: Color.fromARGB(
                      255,
                      Random().nextInt(255),
                      Random().nextInt(255),
                      Random().nextInt(255),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
