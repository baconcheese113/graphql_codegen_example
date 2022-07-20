import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_codegen_example/graphql/__generated__/schema.graphql.dart';
import 'package:graphql_codegen_example/home/users/add_user_graphic.dart';
import 'package:graphql_codegen_example/home/users/~graphql/__generated__/add_user.mutation.graphql.dart';

class AddUserScreen extends HookWidget {
  const AddUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = useState("");
    final rocket = useState("");
    final exception = useState("");
    final mounted = useIsMounted();

    final addUser = useMutation$AddUser();
    final canSubmit = name.value.isNotEmpty && rocket.value.isNotEmpty;

    void handleSubmit() async {
      final res = await addUser
          .runMutation(Variables$Mutation$AddUser(
            user: Input$users_insert_input(
              name: name.value,
              rocket: rocket.value,
              twitter: "https://twitter.com/VerminSupreme",
            ),
          ))
          .networkResult;
      if (res == null || res.hasException) {
        exception.value = res?.exception?.graphqlErrors[0].message ?? "Error occurred";
      } else {
        name.value = "";
        rocket.value = "";
        // FIXME flutter_hooks not playing well with flutter_lints
        // ignore: use_build_context_synchronously
        if (mounted()) Navigator.pop(context);
      }
    }

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Add User")),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AddUserGraphic(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ColoredBox(
                      color: const Color.fromRGBO(0, 0, 0, .1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          children: [
                            Row(children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Text("Name"),
                              ),
                              Expanded(
                                child: TextField(onChanged: (newName) => name.value = newName),
                              ),
                            ]),
                            Row(children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Text("Favorite Rocket"),
                              ),
                              Expanded(
                                child: TextField(onChanged: (newRocket) => rocket.value = newRocket),
                              ),
                            ]),
                            Text(
                              exception.value,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Positioned(
              bottom: 0,
              child: TextButton(
                onPressed: canSubmit ? handleSubmit : null,
                child: const Text("Submit"),
              )),
        ],
      ),
    );
  }
}
