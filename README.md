# graphql_codegen_example

Simple Flutter example project using [graphql-flutter](https://github.com/zino-hofmann/graphql-flutter) and [graphql_codegen](https://github.com/heftapp/graphql_codegen/tree/main/packages/graphql_codegen) with a focus on folder/file structure.

Uses the SpaceX schema available [here](https://studio.apollographql.com/public/SpaceX-pxxbxen/explorer?variant=current)

## Goal

This project aims to replicate a typical client structure using npm packages Apollo or Relay.js. and act as a point of reference. In general, queries and fragments should live as close as possible to the widgets that use them and should not be reused across multiple widgets. 

---

## Reasons not to use graphql_codegen

- As of now, graphql_codegen doesn't support parsing out graphql queries from `.dart` files, so each query needs to be separated into it's own `.graphql` file. This is suboptimal because it adds a level of separation between the code and the query definition, and can make refactoring more difficult. There are plans to support this, or build a new library around this concept, see [this issue](https://github.com/heftapp/graphql_codegen/issues/130)

- Although without graphql type generation you wouldn't have any idea what types your responses are, graphql_codegen lumps all nested child fragments into the parent query. This can make it difficult to keep fragments specific to widgets separated. As in the following example:
```graphql
query Parent {
    viewer {
        id
        name
        ...child1
    }
}
fragment child1 on Viewer {
    age
    home {
        address
        state
        ...child2
    }
}
fragment child2 on Home {
    zip
}
```
```dart
class Parent extends StatelessWidget {
  const Parent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query$Parent$Widget(builder: (result, {fetchMore, refetch}) {
      // should only contain viewer->id/name
      final data = result.parsedData!; 
      // but this is valid and suggested in intellisense
      data.viewer.home.zip;
      ...
```

## graphql_codegen vs Artemis

You can see a similar example project for Artemis [here](https://github.com/baconcheese113/graphql-flutter-artemis-example/). Both projects require Graphql to be defined in separate files. Artemis types don't include fields in nested fragments, but they also have a lot of equality issues when passing down the widget hierarchy or generating classes with nested fragments both selecting the same fields. 

### Approach
Both projects are awesome steps towards better static type support for graphql with Dart/Flutter. For the most part graphql_codegen takes a more streamlined approach and the usage is more succinct. Artemis also has ArtemisClient which helps, but it's another configuration step, whereas with graphql_codegen it comes with the defaults suggested in the README.

1) A Mutation with Artemis
```dart
return Mutation(
    options: MutationOptions(
        document: ADD_USER_MUTATION_DOCUMENT,
        operationName: ADD_USER_MUTATION_DOCUMENT_OPERATION_NAME,
    ),
    builder: (runMutation, result) {
    return TextButton(
        onPressed: () {
            runMutation(AddUserArguments({
                user: (
                    name: name.value,
                    rocket: rocket.value,
                    twitter: "https://twitter.com/VerminSupreme",
                ),
                }).toJson()
            ).networkResult;
        },
        child: const Text("Submit"));
    },
);
```

2) A Mutation with graphql_codegen
```dart
return Mutation$AddUser$Widget(
    builder: (runMutation, result) {
    return TextButton(
        onPressed: () {
            runMutation(Variables$Mutation$AddUser(
            user: Input$users_insert_input(
                name: name.value,
                rocket: rocket.value,
                twitter: "https://twitter.com/VerminSupreme",
            ),
            )).networkResult;
        },
        child: const Text("Submit"));
    },
);

// Or using a hook...
final addUser = useMutation$AddUser();
return TextButton(
    onPressed: () {
        addUser.runMutation(Variables$Mutation$AddUser(
        user: Input$users_insert_input(
            name: name.value,
            rocket: rocket.value,
            twitter: "https://twitter.com/VerminSupreme",
        ),
        )).networkResult;
    },
    child: const Text("Submit"));
```

### Support
With support for standard dart, and helpers generated for [flutter_hooks](https://github.com/rrousselGit/flutter_hooks), [graphql_flutter](https://github.com/zino-hofmann/graphql-flutter), and [graphql](https://pub.dev/packages/graphql) graphql_codegen comes off as a more relevant tool with better future-facing support.

1) The last stable release from Artemis was 18 months ago, the last beta release was 5 weeks ago.

2) The last stable release from graphql_codegen was 5 hours ago. 

### Documentation

Neither have much of a public roadmap, but both have a Readme and examples available.

1) For Artemis changes are tracked in both [CHANGELOG.md](https://github.com/comigor/artemis/blob/master/CHANGELOG.md) and [Github Releases](https://github.com/comigor/artemis/releases). The Github Releases are attached to branches with the changes

2) For graphql_codegen changes are tracked in [CHANGELOG.md](https://github.com/heftapp/graphql_codegen/blob/main/packages/graphql_codegen/CHANGELOG.md) but don't link to PRs or documentation.

### Community

Artemis has had 18 contributors, with 2 consistent.

graphql_codegen has had 5 contributors, with 1 consistent.

## Schema Generation (introspection)
1) The schema is included in this project, but you can regenerate it with the [GraphQL Android Studio plugin](https://plugins.jetbrains.com/plugin/8097-graphql). You can add it in Android Studio from `File->Preferences->Plugins` and then searching for `GraphQL` in the Marketplace. It uses the [.graphqlconfig](\.graphqlconfig) configuration file.

2) Next, expand the plugin from the bottom of the window and double click on `Endpoints->Default GraphQL Endpoint` and select `Get GraphQL Schema From Endpoint`
3) You should be able to see your schema in [lib/graphql/schema.dart](lib/graphql/schema.dart)

---

## Building the Types
Once you have the schema, you're ready to generate the type files using Build Runner. In the terminal use the command:
```powershell
flutter pub run build_runner build
```
This also deletes the old generated types if they exist. You should now be able to see the graphql_codegen types in [\_\_generated\_\_](lib/home/users/~graphql/__generated__/) folders

---

## Using Queries

Here's an example using a Query Widget with the .graphql queries and graphql_codegen types.

[launches_tab.query.graphql](lib/home/launches/~graphql/launches_tab.query.graphql)
```graphql
query LaunchesTab {
  launches(limit: 150) {
    ...launchCard_launch
  }
}
```
[pokemon_list.dart#L12](lib/list/pokemon_list.dart#L12)
```dart
return Query$LaunchesTab$Widget(builder: (result, {fetchMore, refetch}) {
      // helper to check if parsedData is null or there's an error
      final noDataWidget = validateResult(result);
      if (noDataWidget != null) return noDataWidget;

      final data = result.parsedData!;
      data.launches?.removeWhere((l) => l == null);

      final cardList = data.launches?.map(
        (l) => LaunchCard(launchFrag: l!)
      ).toList();

      if (cardList?.isEmpty ?? true) {
        return const Center(child: Text("No Launches"));
      }
      return ListView(children: cardList!);
    });
```

---

## Using Fragments

> This fragment is used with the query from the above section

[launches.fragments.graphql](lib/home/launches/~graphql/launches.fragments.graphql)
```graphql
fragment launchCard_launch on Launch {
  ...launchCardTitle_launch
  ...launchCardBody_launch
  id
  launch_date_utc
  launch_site {
    site_name_long
  }
}
```
[launch_card.dart](lib/home/launches/launch_card.dart)
```dart
class LaunchCard extends StatelessWidget {
  final Fragment$launchCard_launch launchFrag;
  const LaunchCard({Key? key, required this.launchFrag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String getLaunchTime() {
      final launchTime = launchFrag.launch_date_utc;
      if (launchTime != null) return "${launchTime.year}-${launchTime.month}-${launchTime.day}";
      return "";
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Card(
        child: Column(
          children: [
            ListTile(
              // Can pass the fragment directly to child fragment
              title: LaunchCardTitle(launchFrag: launchFrag),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(getLaunchTime()),
                  Text(launchFrag.launch_site?.site_name_long ?? ""),
                ],
              ),
            ),
            // Can pass the fragment directly to child fragment
            LaunchCardBody(launchFrag: launchFrag),
          ],
        ),
      ),
    );
  }
}
```
