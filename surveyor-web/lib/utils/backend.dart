import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hei_survei/constants.dart';

class Backend {
  Future<Map<String, dynamic>?> serverConnection(
      {required String query,
      required Map<String, dynamic> mapVariable}) async {
    try {
      HttpLink link = HttpLink(linkGraphql);
      GraphQLClient qlClient = GraphQLClient(
        link: link,
        cache: GraphQLCache(store: HiveStore()),
      );

      String request = query;

      QueryResult result = await qlClient.query(QueryOptions(
        document: gql(request),
        variables: mapVariable,
        fetchPolicy: FetchPolicy.networkOnly,
      ));
      return result.data;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> mutationConnection(
      {required String query,
      required Map<String, dynamic> mapVariable}) async {
    try {
      HttpLink link = HttpLink(linkGraphql);
      GraphQLClient qlClient = GraphQLClient(
        link: link,
        cache: GraphQLCache(store: HiveStore()),
      );

      String request = query;
      QueryResult result = await qlClient.mutate(MutationOptions(
        document: gql(request),
        variables: mapVariable,
        fetchPolicy: FetchPolicy.networkOnly,
      ));
      // QueryResult result = await qlClient.query(QueryOptions(
      //   document: gql(request),
      //   variables: mapVariable,
      // ));
      return result.data;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
