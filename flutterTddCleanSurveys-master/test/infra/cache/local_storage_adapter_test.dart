import 'package:faker/faker.dart';
import 'package:flutterClean/infra/cache/cache.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:localstorage/localstorage.dart';

class LocalStorageSpy extends Mock implements LocalStorage {}

void main() {
  String key;
  dynamic value;
  LocalStorageAdapter sut;
  LocalStorageSpy localStorage;

  mockDeleteCacheError() =>
      when(localStorage.deleteItem(any)).thenThrow(Exception());

  mockFetchCacheError() =>
      when(localStorage.getItem(any)).thenThrow(Exception());

  mockSaveError() =>
      when(localStorage.setItem(any, value)).thenThrow(Exception());

  setUp(() {
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(50);
    localStorage = LocalStorageSpy();
    sut = LocalStorageAdapter(localStorage: localStorage);
  });

  group('save', () {
    test('Should call localStorage with correct values', () async {
      sut.save(key: key, value: value);

      verify(localStorage.deleteItem(key)).called(1);
      verify(localStorage.setItem(key, value)).called(1);
    });

    test('Should throws if delete item throws', () async {
      mockDeleteCacheError();

      final future = sut.save(key: key, value: value);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });

    test('Should throws set item throws', () async {
      mockSaveError();

      final future = sut.save(key: key, value: value);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('delete', () {
    test('Should call delete with correct key', () async {
      await sut.delete(key);

      verify(localStorage.deleteItem(key)).called(1);
    });

    test('Should throws if delete item throws', () async {
      mockDeleteCacheError();

      final future = sut.delete(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('fetch', () {
    String result;

    void mockFetch() {
      result = faker.randomGenerator.string(50);
      when(localStorage.getItem(any)).thenAnswer((_) => result);
    }

    setUp(() {
      mockFetch();
    });
    test('Should call localStorage with correct values', () async {
      sut.fetch(key);

      verify(localStorage.getItem(key)).called(1);
    });

    test('Should return same value as localStorage', () async {
      final data = await sut.fetch(key);

      expect(data, result);
    });

    test('Should throws if fetch item throws', () {
      mockFetchCacheError();

      final future = sut.fetch(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });
}
