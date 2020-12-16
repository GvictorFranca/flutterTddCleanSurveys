import 'package:flutterClean/domain/entities/entities.dart';

import 'package:flutterClean/data/http/http.dart';

class RemoteAccountModel {
  final String acessToken;

  RemoteAccountModel(this.acessToken);

  factory RemoteAccountModel.fromJson(Map json) {
    if (!json.containsKey('accessToken')) {
      throw HttpError.invalidData;
    }
    return RemoteAccountModel(json['accessToken']);
  }

  AccountEntity toEntity() => AccountEntity(acessToken);
}
