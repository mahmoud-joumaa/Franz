import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:franz/pages/home/transcribe.dart';

// IDEA: maybe support downloading local pdfs and loading them

class ApiService {
  Future<String> loadPDF(String pdfUrl) async {
    var response = await http.get(Uri.parse(pdfUrl));

    var dir = await getTemporaryDirectory();
    File file = File("${dir.path}/pdfdata.pdf");

    file.writeAsBytes(response.bodyBytes, flush: true);
    return file.path;
  }


  Future<String> loadAudio(String audioURL) async {
    var response = await http.get(Uri.parse(audioURL));

    var dir = await getTemporaryDirectory();
    File file = File("${dir.path}/audiodata.mid");

    file.writeAsBytes(response.bodyBytes, flush: true);

    return file.path;
  }
}

/* ================================================================================================
DynamoDB GraphQL API
================================================================================================ */

class DynamoGraphQL {

  static initializeClient() {

    // DynamoDB Endpoint
    final HttpLink httpLink = HttpLink(DynamoAPI.url, defaultHeaders: {"x-api-key": DynamoAPI.key});
    // Initialize Client
    final policies = Policies(fetch: FetchPolicy.networkOnly);
    GraphQLClient client = GraphQLClient(link: httpLink, cache: GraphQLCache(store: InMemoryStore()), defaultPolicies: DefaultPolicies(watchQuery: policies, query: policies, mutate: policies));

    return client;

  }

}
