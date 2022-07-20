import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:graphql_codegen_example/graphql/__generated__/schema.graphql.dart';
import 'package:graphql_codegen_example/home/users/~graphql/__generated__/users.fragments.graphql.dart';
import 'package:graphql_codegen_example/home/users/~graphql/__generated__/users_tab.query.graphql.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

// This provider is used to hold the users query options and update the query
class UsersProvider extends ChangeNotifier {
  int _limit = 100;
  int get limit => _limit;

  List<Input$users_order_by> _orderBy = [
    Input$users_order_by(timestamp: Enum$order_by.desc_nulls_last),
  ];
  UnmodifiableListView<Input$users_order_by> get orderBy => UnmodifiableListView(_orderBy);

  void setLimit(int newLimit) {
    _limit = newLimit;
    notifyListeners();
  }

  void setOrderBy(List<Input$users_order_by> newOrderBy) {
    _orderBy = newOrderBy;
    notifyListeners();
  }

  Request _getRequest() {
    final usersQueryOptions = Options$Query$UsersTab(
      variables: Variables$Query$UsersTab(
        limit: limit,
        orderBy: orderBy,
      ),
    );
    return usersQueryOptions.asRequest;
  }

  Query$UsersTab? _tryGetQueryFromCache(GraphQLDataProxy cache, Request request) {
    final readQuery = cache.readQuery(_getRequest());
    return readQuery != null ? Query$UsersTab.fromJson(readQuery) : null;
  }

  void onDelete(GraphQLDataProxy cache, String userId) {
    final request = _getRequest();
    final readQuery = _tryGetQueryFromCache(cache, request);
    if (readQuery == null) return;
    readQuery.users.removeWhere((u) => u.id == userId);
    cache.writeQuery(request, data: readQuery.toJson(), broadcast: true);
  }

  void onAdd(GraphQLDataProxy cache, Fragment$userCard_users user) {
    final request = _getRequest();
    final readQuery = _tryGetQueryFromCache(cache, request);
    if (readQuery == null) return;
    readQuery.users.insert(0, user);
    cache.writeQuery(request, data: readQuery.toJson(), broadcast: true);
  }
}
