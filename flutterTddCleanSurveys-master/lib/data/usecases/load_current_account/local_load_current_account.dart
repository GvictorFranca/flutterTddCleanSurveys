import 'package:flutterClean/data/cache/cache.dart';
import 'package:flutterClean/domain/entities/entities.dart';
import 'package:flutterClean/domain/helpers/helpers.dart';
import 'package:flutterClean/domain/usecases/usecases.dart';
import 'package:meta/meta.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({@required this.fetchSecureCacheStorage});

  Future<AccountEntity> load() async {
    try {
      final token = await fetchSecureCacheStorage.fetchSecure('token');
      return AccountEntity(token: token);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
