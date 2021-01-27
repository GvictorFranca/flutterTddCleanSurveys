import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:localstorage/localstorage.dart';
import 'package:meta/meta.dart';

class LocalStorageAdapter {
  final LocalStorage localStorage;

  LocalStorageAdapter({@required this.localStorage});

  Future<void> save({@required String key, @required dynamic value}) async {
    await localStorage.deleteItem(key);
    await localStorage.setItem(key, value);
  }
}

class LocalStorageSpy extends Mock implements LocalStorage {}

void main() {
  String key;
  dynamic value;
  LocalStorageAdapter sut;
  LocalStorageSpy localStorage;

  mockDeleteItemError() =>
      when(localStorage.deleteItem(any)).thenThrow(Exception());

  mockSetItemError() =>
      when(localStorage.setItem(any, value)).thenThrow(Exception());

  setUp(() {
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(50);
    localStorage = LocalStorageSpy();
    sut = LocalStorageAdapter(localStorage: localStorage);
  });

  test('Should call localStorage with correct values', () async {
    sut.save(key: key, value: value);

    verify(localStorage.deleteItem(key)).called(1);
    verify(localStorage.setItem(key, value)).called(1);
  });

  test('Should throws if delete item throws', () async {
    mockDeleteItemError();

    final future = sut.save(key: key, value: value);

    expect(future, throwsA(TypeMatcher<Exception>()));
  });

  test('Should throws iif delete item throws', () async {
    mockSetItemError();

    final future = sut.save(key: key, value: value);

    expect(future, throwsA(TypeMatcher<Exception>()));
  });
}
