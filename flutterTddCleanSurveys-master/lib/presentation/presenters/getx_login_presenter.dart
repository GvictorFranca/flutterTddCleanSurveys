import 'package:get/get.dart';

import 'package:flutterClean/domain/helpers/domain_error.dart';
import 'package:flutterClean/domain/usecases/usecases.dart';
import 'package:flutterClean/ui/pages/login/login.dart';
import 'package:meta/meta.dart';
import 'package:flutterClean/presentation/dependencies/validation.dart';
import 'package:flutterClean/ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  String _email;
  String _password;
  var _emailError = Rx<UIError>();
  var _passwordError = Rx<UIError>();
  var _mainError = Rx<UIError>();
  var _navigateTo = RxString();
  var _isFormValid = false.obs;
  var _isLoading = false.obs;

  Stream<UIError> get emailErrorStream => _emailError.stream;
  Stream<UIError> get passwordErrorStream => _passwordError.stream;
  Stream<UIError> get mainErrorStream => _mainError.stream;
  Stream<String> get navigateToStream => _navigateTo.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  Stream<bool> get isLoadingStream => _isLoading.stream;

  GetxLoginPresenter(
      {@required this.validation,
      @required this.authentication,
      @required this.saveCurrentAccount});

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField(field: 'password', value: password);
    _validateForm();
  }

  UIError _validateField({String field, String value}) {
    final error = validation.validate(field: field, value: value);
    switch (error) {
      case ValidationError.invalidField:
        return UIError.invalidField;
      case ValidationError.requiredField:
        return UIError.requiredField;
      default:
        return null;
    }
  }

  void _validateForm() {
    _isFormValid.value = _emailError.value == null &&
        _passwordError.value == null &&
        _email != null &&
        _password != null;
  }

  Future<void> auth() async {
    try {
      _isLoading.value = true;
      final account = await authentication
          .auth(AuthenticationParams(email: _email, secret: _password));
      await saveCurrentAccount.save(account);
      _navigateTo.value = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          _mainError.value = UIError.invalidCredentials;
          break;
        default:
          _mainError.value = UIError.unexpected;
          break;
      }
      _isLoading.value = false;
    }
  }

  void goToSignUp() {
    _navigateTo.value = '/signup';
  }
}
