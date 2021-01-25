import 'package:faker/faker.dart';
import 'package:flutterClean/data/cache/cache.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class AuthorizeHttpClientDecorator {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  AuthorizeHttpClientDecorator({@required this.fetchSecureCacheStorage});

  Future<void> request({
    @required String url,
    @required String method,
    Map body,
    Map headers,
  }) async {
    await fetchSecureCacheStorage.fetchSecure('token');
  }
}

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

void main() {
  FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  AuthorizeHttpClientDecorator sut;
  String url;
  String method;
  Map body;

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = AuthorizeHttpClientDecorator(
        fetchSecureCacheStorage: fetchSecureCacheStorage);
    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key': 'any_value'};
  });

  test('Should call FetchSEcureCacheStorage with correct key', () async {
    await sut.request(
      url: url,
      method: method,
      body: body,
    );

    verify(fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });

  test('Should call FetchSEcureCacheStorage with correct key', () async {
    await sut.request();

    verify(fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });
}
