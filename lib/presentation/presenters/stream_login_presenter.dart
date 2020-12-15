import 'dart:async';

import 'package:meta/meta.dart';
import 'package:flutterClean/presentation/dependencies/validation.dart';

class LoginState {
  String emailError;
}

var _state = LoginState();

class StreamLoginPresenter {
  final Validation validation;
  final _controller = StreamController<LoginState>.broadcast();

  Stream<String> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError);

  StreamLoginPresenter({
    @required this.validation,
  });
  void validateEmail(String email) {
    _state.emailError = validation.validate(field: 'email', value: email);
    _controller.add(_state);
  }
}
