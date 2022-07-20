import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_codegen_example/home/users/~graphql/__generated__/new_users_chip.subscription.graphql.dart';
import 'package:graphql_codegen_example/utils.dart';

// NOTE: Subscriptions don't work with this schema, just an example widget below...
class NewUsersChip extends HookWidget {
  const NewUsersChip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final initialCount = useState(0);
    final newUsersSub = useSubscription$NewUsersChip(
      Options$Subscription$NewUsersChip(),
    );

    final noDataWidget = validateResult(newUsersSub);
    if (noDataWidget != null) return noDataWidget;

    final count = newUsersSub.parsedData!.users_aggregate.aggregate!.count!;
    if (initialCount.value == 0) initialCount.value = count;
    print("newUsers $count");
    final newUsers = count - initialCount.value;
    return Chip(label: Text("$newUsers New Users"));
  }
}
