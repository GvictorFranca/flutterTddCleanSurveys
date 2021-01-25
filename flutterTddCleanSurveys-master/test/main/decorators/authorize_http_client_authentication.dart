import 'package:faker/faker.dart';
import 'package:flutterClean/data/cache/cache.dart';
import 'package:flutterClean/data/http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class AuthorizeHttpClientDecorator implements HttpClient {
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final HttpClient decoratee;

  AuthorizeHttpClientDecorator({
    @required this.fetchSecureCacheStorage,
    @required this.decoratee,
  });

  Future<dynamic> request({
    @required String url,
    @required String method,
    Map body,
    Map headers,
  }) async {
    try {
      final token = await fetchSecureCacheStorage.fetchSecure('token');
      final authorizedHeaders = headers ?? {}
        ..addAll({
          'x-access-token': token,
        });
      return await decoratee.request(
        url: url,
        method: method,
        headers: authorizedHeaders,
      );
    } on HttpError {
      rethrow;
    } catch (error) {
      throw HttpError.forbidden;
    }
  }
}

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

class HttpCLientSpy extends Mock implements HttpClient {}

void main() {
  FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  AuthorizeHttpClientDecorator sut;
  String url;
  String method;
  Map body;
  HttpCLientSpy httpClient;
  String token;
  String httpResponse;

  PostExpectation mockTokenCall() =>
      when(fetchSecureCacheStorage.fetchSecure(any));

  void mockToken() {
    token = faker.guid.guid();
    mockTokenCall().thenAnswer((_) async => token);
  }

  void mockTokenError() {
    mockTokenCall().thenThrow(Exception());
  }

  PostExpectation mockHttpResponseCall() => when(httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
        headers: anyNamed('headers'),
      ));

  void mockHttpResponse() {
    httpResponse = faker.randomGenerator.string(50);
    mockHttpResponseCall().thenAnswer(
      (_) async => httpResponse,
    );
  }

  void mockHttpResponseError(HttpError error) {
    mockHttpResponseCall().thenThrow(error);
  }

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = AuthorizeHttpClientDecorator(
      fetchSecureCacheStorage: fetchSecureCacheStorage,
      decoratee: httpClient,
    );
    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key': 'any_value'};
    mockToken();
    mockHttpResponse();
  });

  test('Should call FetchSEcureCacheStorage with correct key', () async {
    await sut.request(
      url: url,
      method: method,
      body: body,
    );

    verify(fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });

  test('Should call decoratee with access token on header', () async {
    await sut.request(
      url: url,
      method: method,
      body: body,
    );

    verify(
      httpClient.request(
          method: method,
          url: url,
          body: body,
          headers: {'x-access-token': token}),
    ).called(1);

    await sut.request(
        url: url,
        method: method,
        body: body,
        headers: {'any_header': 'any_value'});

    verify(
      httpClient.request(method: method, url: url, body: body, headers: {
        'x-access-token': token,
        'any_header': 'any_value',
      }),
    ).called(1);
  });

  test('Should retunr same result as decoratee', () async {
    final response = await sut.request(
      url: url,
      method: method,
      body: body,
    );

    expect(response, httpResponse);
  });

  test('Should throw Forbidden error if  FetchSEcureCacheStorage throws',
      () async {
    mockTokenError();

    final future = sut.request(
      url: url,
      method: method,
      body: body,
    );

    expect(future, throwsA(HttpError.forbidden));
  });

  test('Should rethrow Forbidden error if  decoratee throws', () async {
    mockHttpResponseError(HttpError.badRequest);

    final future = sut.request(
      url: url,
      method: method,
      body: body,
    );

    expect(future, throwsA(HttpError.badRequest));
  });
}
