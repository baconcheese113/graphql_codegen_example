import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_codegen_example/graphql/__generated__/schema.graphql.dart';
import 'package:graphql_codegen_example/home/users/user_card_body.dart';
import 'package:graphql_codegen_example/home/users/~graphql/__generated__/delete_user.mutation.graphql.dart';
import 'package:graphql_codegen_example/home/users/~graphql/__generated__/users.fragments.graphql.dart';

class UserCard extends HookWidget {
  final Fragment$userCard_users usersFrag;
  const UserCard({Key? key, required this.usersFrag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deleteUser = useMutation$DeleteUser();
    final loading = useState(false);
    final mounted = useIsMounted();

    void handleDelete() async {
      loading.value = true;
      final res = await deleteUser
          .runMutation(
            Variables$Mutation$DeleteUser(
              where: Input$users_bool_exp(
                id: Input$uuid_comparison_exp($_eq: usersFrag.id),
              ),
            ),
          )
          .networkResult;
      loading.value = false;
      if (res!.hasException && mounted()) {
        // FIXME flutter_hooks not playing well with flutter_lints
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("And Error Ocurred")));
      }
    }

    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(usersFrag.name ?? "<No Name>"),
            subtitle: Text(usersFrag.timestamp.toString()),
            trailing: loading.value
                ? const CircularProgressIndicator()
                : IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: handleDelete,
                  ),
          ),
          UserCardBody(usersFrag: usersFrag),
        ],
      ),
    );
  }
}
