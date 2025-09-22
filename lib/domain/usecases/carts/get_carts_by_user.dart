import 'package:dartz/dartz.dart';
import 'package:fakestore_fase3_mandrade/fakestore_fase3_mandrade.dart';

import '../../../core/failures.dart';
import '../../../core/usecases.dart';
import '../../repositories/fake_store_repository.dart';

/// Parámetros para obtener carritos por usuario
class GetCartsByUserParams {
  final int userId;

  GetCartsByUserParams({required this.userId});
}

/// Caso de uso para obtener carritos de un usuario específico
///
/// Implementa Clean Architecture y principios SOLID:
/// - SRP: Solo responsable de obtener carritos por usuario
/// - DIP: Depende de abstracciones (FakeStoreRepository)
class GetCartsByUser
    implements UseCase<List<CartEntity>, GetCartsByUserParams> {
  final FakeStoreRepository repository;

  const GetCartsByUser(this.repository);

  @override
  Future<Either<Failure, List<CartEntity>>> call(
    GetCartsByUserParams params,
  ) async {
    return await repository.getCartsByUser(params.userId);
  }
}
