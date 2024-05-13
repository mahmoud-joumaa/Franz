import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

// TODO: maybe support downloading local pdfs and loading them

class ApiService {
  Future<String> loadPDF(String pdfUrl) async {
    var response = await http.get(Uri.parse(pdfUrl));

    var dir = await getTemporaryDirectory();
    File file = File("${dir.path}/pdfdata.pdf");

    file.writeAsBytes(response.bodyBytes, flush: true);
    print(file.path);
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
