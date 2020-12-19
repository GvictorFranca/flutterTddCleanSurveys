import 'package:flutterClean/main/factories/factories.dart';
import 'package:flutterClean/presentation/presenters/stream_login_presenter.dart';
import 'package:flutterClean/ui/pages/pages.dart';

LoginPresenter makeLoginPresenter() {
  return StreamLoginPresenter(
      validation: makeLoginValidation(),
      authentication: makeRemoteAuthentication());
}
