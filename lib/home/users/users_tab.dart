import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_codegen_example/graphql/__generated__/schema.graphql.dart';
import 'package:graphql_codegen_example/home/users/new_users_chip.dart';
import 'package:graphql_codegen_example/home/users/user_card.dart';
import 'package:graphql_codegen_example/home/users/~graphql/__generated__/users_tab.query.graphql.dart';
import 'package:graphql_codegen_example/utils.dart';

// This widget hierarchy shows how to use graphql_codegen hooks
class UsersTab extends HookWidget {
  const UsersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final limit = useState(100);
    final orderBy = useState([
      Input$users_order_by(timestamp: Enum$order_by.desc_nulls_last),
    ]);

    final usersQuery = useQuery$UsersTab(Options$Query$UsersTab(
      variables: Variables$Query$UsersTab(
        limit: limit.value,
        orderBy: orderBy.value,
      ),
    ));
    final result = usersQuery.result;
    final noDataWidget = validateResult(result);
    if (noDataWidget != null) return noDataWidget;

    final data = result.parsedData!;

    final userLimitOptions = [1, 10, 50, 100]
        .map((limit) => DropdownMenuItem(
              value: limit,
              child: Text("$limit"),
            ))
        .toList();
    final cardList = data.users.map((u) => UserCard(usersFrag: u)).toList();

    return Column(
      children: [
        const NewUsersChip(),
        Row(
          children: [
            const Text("Limit "),
            DropdownButton<int>(
              value: limit.value,
              icon: const Icon(Icons.arrow_downward),
              items: userLimitOptions,
              onChanged: (newLimit) => newLimit != null ? limit.value = newLimit : null,
            ),
          ],
        ),
        Expanded(
            child: RefreshIndicator(
          child: ListView(children: cardList),
          onRefresh: () async {
            await usersQuery.refetch();
          },
        )),
      ],
    );
  }
}
