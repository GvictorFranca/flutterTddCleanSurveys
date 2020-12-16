enum DomainError { unexpected, invalidCredentials }

extension DomainErrorExtension on DomainError {
  String get description {
    switch (this) {
      case DomainError.invalidCredentials:
        return 'Credenciais Invalidas';
      default:
        return 'Algo de errado aconteceu. Tente novamente em breve';
    }
  }
}