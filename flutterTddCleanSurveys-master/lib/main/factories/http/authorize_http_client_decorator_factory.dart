import 'package:flutterClean/data/http/http.dart';

import 'package:flutterClean/main/decorators/decorators.dart';
import 'package:flutterClean/main/factories/factories.dart';

HttpClient makeAuthorizeHttpClientDecorator() => AuthorizeHttpClientDecorator(
      decoratee: makeHttpAdapter(),
      fetchSecureCacheStorage: makeLocalStorageAdapter(),
    );
