import 'dart:io';

import 'package:http/http.dart' as http;
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

class GraphQL {

  static query(queryString) async {
    var request = http.Request("GET", Uri.dataFromString("${DynamoAPI.url}?query=$query"));
    request.headers.addAll({"x-api-key": DynamoAPI.key});
    http.StreamedResponse response = await request.send();
    print("\n\n\n");
    print(await response.stream.bytesToString());
    print("\n\n\n");
    // return await response.stream.bytesToString();
  }

}
