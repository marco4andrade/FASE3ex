import 'package:dartz/dartz.dart';
import 'failures.dart';

/// Caso de uso base que define la interfaz común para todos los casos de uso
///
/// [Type] es el tipo de dato que retorna el caso de uso
/// [Params] es el tipo de parámetros que recibe el caso de uso
abstract class UseCase<Type, Params> {
  /// Ejecuta el caso de uso
  ///
  /// Retorna [Right] con el resultado exitoso o [Left] con el fallo
  Future<Either<Failure, Type>> call(Params params);
}

/// Caso de uso que no requiere parámetros
abstract class UseCaseNoParams<Type> {
  /// Ejecuta el caso de uso sin parámetros
  ///
  /// Retorna [Right] con el resultado exitoso o [Left] con el fallo
  Future<Either<Failure, Type>> call();
}

/// Clase para representar que no se necesitan parámetros
class NoParams {
  const NoParams();
}
