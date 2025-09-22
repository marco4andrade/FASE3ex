import 'package:dartz/dartz.dart';
import 'package:fakestore_fase3_mandrade/fakestore_fase3_mandrade.dart';

import '../../../core/failures.dart';
import '../../../core/usecases.dart';
import '../../repositories/fake_store_repository.dart';

/// Caso de uso para obtener todos los usuarios
///
/// Implementa el principio de Responsabilidad Única (SRP)
class GetAllUsers implements UseCaseNoParams<List<UserEntity>> {
  final FakeStoreRepository repository;

  const GetAllUsers(this.repository);

  @override
  Future<Either<Failure, List<UserEntity>>> call() async {
    return await repository.getAllUsers();
  }
}
