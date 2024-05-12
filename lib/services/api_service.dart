import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:franz/pages/home/transcribe.dart';

// TODO: maybe support downloading local pdfs and loading them

class ApiService {
  Future<String> loadPDF(String pdfUrl) async {
    var response = await http.get(Uri.parse(pdfUrl));

    var dir = await getTemporaryDirectory();
    File file = File("${dir.path}/data.pdf");

    file.writeAsBytes(response.bodyBytes, flush: true);

    return file.path;
  }
}

/* ================================================================================================
DynamoDB GraphQL API
================================================================================================ */

class DynamoGraphQL {

  static initialize() {

    // DynamoDB Endpoint
    final HttpLink httpLink = HttpLink(DynamoAPI.url, defaultHeaders: {"x-api-key": DynamoAPI.key});
    // Initialize Client
    ValueNotifier<GraphQLClient> client = ValueNotifier(GraphQLClient(link: httpLink, cache: GraphQLCache(store: InMemoryStore())));

    return client;
  }

}
