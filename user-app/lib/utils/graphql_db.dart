import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:survei_aplikasi/constants.dart';

class BackendConnection {
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
}
