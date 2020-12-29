import 'package:flutterClean/presentation/presenters/presenter.dart';
import 'package:flutterClean/ui/pages/pages.dart';
import '../../factories.dart';

LoginPresenter makeGetXLoginPresenter() {
  return GetXLoginPresenter(
      validation: makeLoginValidation(),
      authentication: makeRemoteAuthentication(),
      saveCurrentAccount: makeLocalSaveCurrentAccount());
}
