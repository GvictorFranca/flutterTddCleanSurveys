import 'package:flutterClean/data/http/http.dart';
import 'package:flutterClean/infra/http/http.dart';

import 'package:http/http.dart';

HttpClient makeHttpAdapter() {
  final client = Client();
  return HttpAdapter(client);
}
