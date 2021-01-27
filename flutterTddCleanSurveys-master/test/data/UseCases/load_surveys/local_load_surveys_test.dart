import 'package:faker/faker.dart';
import 'package:flutterClean/data/cache/cache.dart';
import 'package:flutterClean/data/models/models.dart';
import 'package:flutterClean/data/usecases/load_surveys/load_surveys.dart';
import 'package:flutterClean/domain/entities/entities.dart';
import 'package:flutterClean/domain/helpers/helpers.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class CacheStorageSpy extends Mock implements CacheStorage {}

void main() {
  group('load', () {
    LocalLoadSurveys sut;
    CacheStorageSpy cacheStorage;
    List<Map> data;

    List<Map> mockValidData() => [
          {
            'id': faker.guid.guid(),
            'question': faker.randomGenerator.string(10),
            'date': '2020-07-20T20:18:04Z',
            'didAnswer': 'false',
          },
          {
            'id': faker.guid.guid(),
            'question': faker.randomGenerator.string(10),
            'date': '2019-07-20T20:18:04Z',
            'didAnswer': 'true',
          },
        ];

    PostExpectation mockFetchCall() => when(cacheStorage.fetch(any));

    void mockFetch(List<Map> list) {
      data = list;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() {
      mockFetchCall().thenThrow(Exception());
    }

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      mockFetch(mockValidData());
    });
    test('Should call FetchCacheStorage  with correct key', () async {
      await sut.load();

      verify(cacheStorage.fetch('surveys')).called(1);
    });

    test('Should return a list of surveys on sucess', () async {
      final surveys = await sut.load();

      expect(surveys, [
        SurveyEntity(
          id: data[0]['id'],
          question: data[0]['question'],
          dateTime: DateTime.utc(2020, 7, 20),
          didAnswer: false,
        ),
        SurveyEntity(
          id: data[0]['id'],
          question: data[0]['question'],
          dateTime: DateTime.utc(2019, 7, 20),
          didAnswer: true,
        ),
      ]);
    });

    test('Should throw UnexpectedError if cache is empty', () async {
      mockFetch([]);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is null', () async {
      mockFetch(null);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is invalid', () async {
      mockFetch([
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': 'invalid_data',
          'didAnswer': 'false',
        }
      ]);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache throws', () async {
      mockFetchError();

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    LocalLoadSurveys sut;
    CacheStorageSpy cacheStorage;
    List<Map> data;

    List<Map> mockValidData() => [
          {
            'id': faker.guid.guid(),
            'question': faker.randomGenerator.string(10),
            'date': '2020-07-20T20:18:04Z',
            'didAnswer': 'false',
          },
          {
            'id': faker.guid.guid(),
            'question': faker.randomGenerator.string(10),
            'date': '2019-07-20T20:18:04Z',
            'didAnswer': 'true',
          },
        ];

    PostExpectation mockFetchCall() => when(cacheStorage.fetch(any));

    void mockFetch(List<Map> list) {
      data = list;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() {
      mockFetchCall().thenThrow(Exception());
    }

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      mockFetch(mockValidData());
    });
    test('Should call CacheStorage  with correct key', () async {
      await sut.validate();

      verify(cacheStorage.fetch('surveys')).called(1);
    });

    test('Should delete cache if its invalid', () async {
      mockFetch([
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': 'invalid_data',
          'didAnswer': 'false',
        }
      ]);

      await sut.validate();

      verify(cacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache if its incomplete', () async {
      mockFetch([
        {
          'date': '2020-07-20T20:18:04Z',
          'didAnswer': 'false',
        }
      ]);

      await sut.validate();

      verify(cacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache if it is incomplete', () async {
      mockFetchError();

      await sut.validate();

      verify(cacheStorage.delete('surveys')).called(1);
    });
  });

  group('save', () {
    LocalLoadSurveys sut;
    CacheStorageSpy cacheStorage;
    List<SurveyEntity> surveys;

    List<SurveyEntity> mockSurveys() => [
          SurveyEntity(
            id: faker.guid.guid(),
            question: faker.randomGenerator.string(10),
            dateTime: DateTime.utc(2020, 7, 20),
            didAnswer: true,
          ),
          SurveyEntity(
            id: faker.guid.guid(),
            question: faker.randomGenerator.string(10),
            dateTime: DateTime.utc(2020, 7, 22),
            didAnswer: false,
          ),
        ];

    PostExpectation mockSaveCall() =>
        when(cacheStorage.save(key: anyNamed('key'), value: anyNamed('value')));

    void mockSaveError() {
      mockSaveCall().thenThrow(Exception());
    }

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      surveys = mockSurveys();
    });
    test('Should call CacheStorage  with correct values', () async {
      final list = [
        {
          'id': surveys[0].id,
          'question': surveys[0].question,
          'date': '2020-07-20T00:00:00.000Z',
          'didAnswer': 'true',
        },
        {
          'id': surveys[1].id,
          'question': surveys[1].question,
          'date': '2020-07-22T00:00:00.000Z',
          'didAnswer': 'false',
        },
      ];
      await sut.save(surveys);

      verify(cacheStorage.save(
        key: 'surveys',
        value: list,
      )).called(1);
    });

    test('Should throw unexpectedError if save throws', () async {
      mockSaveError();
      final future = sut.save(surveys);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}
