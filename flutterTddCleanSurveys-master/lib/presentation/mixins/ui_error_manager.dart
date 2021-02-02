import 'package:flutterClean/ui/helpers/errors/errors.dart';
import 'package:get/get.dart';

mixin UIErrorManager on GetxController {
  final _mainError = Rx<UIError>();
  Stream<UIError> get mainErrorStream => _mainError.stream;
  set mainError(UIError value) => _mainError.value = value;
}
