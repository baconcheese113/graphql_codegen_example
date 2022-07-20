import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_codegen_example/home/users/user_card.dart';
import 'package:graphql_codegen_example/home/users/users_provider.dart';
import 'package:graphql_codegen_example/home/users/~graphql/__generated__/users_tab.query.graphql.dart';
import 'package:graphql_codegen_example/utils.dart';
import 'package:provider/provider.dart';

// This widget hierarchy shows how to use graphql_codegen hooks
class UsersTab extends HookWidget {
  const UsersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context);
    print(">>> usersProvider.limit ${usersProvider.limit}");

    final usersQuery = useQuery$UsersTab(Options$Query$UsersTab(
      variables: Variables$Query$UsersTab(
        limit: usersProvider.limit,
        orderBy: usersProvider.orderBy,
      ),
    ));
    final result = usersQuery.result;
    final noDataWidget = validateResult(result);
    if (noDataWidget != null) return noDataWidget;

    final data = result.parsedData!;

    final userLimitOptions = [1, 10, 50, 100]
        .map((opt) => DropdownMenuItem(
              value: opt,
              child: Text("$opt"),
            ))
        .toList();
    final cardList = data.users.map((u) => UserCard(usersFrag: u)).toList();

    return Column(
      children: [
        // const NewUsersChip(), // Sub doesn't work in this schema
        Row(
          children: [
            const Text("Limit "),
            DropdownButton<int>(
              value: usersProvider.limit,
              icon: const Icon(Icons.arrow_downward),
              items: userLimitOptions,
              onChanged: (newLimit) => newLimit != null ? usersProvider.setLimit(newLimit) : null,
            ),
          ],
        ),
        Expanded(
          child: RefreshIndicator(
            child: ListView(children: cardList),
            onRefresh: () async {
              await usersQuery.refetch();
            },
          ),
        ),
      ],
    );
  }
}
