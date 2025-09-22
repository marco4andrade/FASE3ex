/// Clase base para todos los fallos en la aplicación
abstract class Failure {
  const Failure(this.message);

  final String message;
}

/// Fallo de servidor - cuando hay problemas con la API
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Fallo de caché - cuando hay problemas con el almacenamiento local
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Fallo de red - cuando no hay conectividad
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Fallo de validación - cuando los datos no son válidos
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Fallo de autenticación - cuando las credenciales son incorrectas
class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message);
}

/// Fallo general - para casos no específicos
class GeneralFailure extends Failure {
  const GeneralFailure(super.message);
}
