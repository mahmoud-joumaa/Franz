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

// Custom link (to authenticate with API key) =====================================================

typedef RequestTransformer = FutureOr<Request> Function(Request request);

class CustomAuthLink extends _AsyncReqTransformLink {
  CustomAuthLink({
    required this.getHeaders,
  }) : super(requestTransformer: transform(getHeaders));

  final FutureOr<Map<String, String>>? Function() getHeaders;

  static RequestTransformer transform(
    FutureOr<Map<String, String>>? Function() getHeaders,
  ) =>
      (Request request) async {
        final Map<String, String>? headers = await getHeaders();
        return request.updateContextEntry<HttpLinkHeaders>(
          // ignore: no_leading_underscores_for_local_identifiers
          (_headers) => HttpLinkHeaders(
            headers: headers!,
          ),
        );
      };
}

class _AsyncReqTransformLink extends Link {
  final RequestTransformer requestTransformer;

  _AsyncReqTransformLink({
    required this.requestTransformer,
  });

  @override
  Stream<Response> request(
    Request request, [
    NextLink? forward,
  ]) async* {
    final req = await requestTransformer(request);

    yield* forward!(req);
  }
}

// Interactable class =============================================================================

class DynamoGraphQL {

  static initialize() {

    // DynamoDB Endpoint
    final HttpLink httpLink = HttpLink(DynamoAPI.url);
    // Authenticate w/ API Key
    CustomAuthLink authLink = CustomAuthLink(getHeaders: () => {"x-api-key": DynamoAPI.key});
    // Concatenated Link
    final Link link = authLink.concat(httpLink);

    // Initialize Client
    ValueNotifier<GraphQLClient> client = ValueNotifier(GraphQLClient(link: link, cache: GraphQLCache(store: InMemoryStore())));

    return client;
  }

}
