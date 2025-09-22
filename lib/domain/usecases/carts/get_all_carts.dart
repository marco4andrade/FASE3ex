import 'package:dartz/dartz.dart';
import 'package:fakestore_fase3_mandrade/fakestore_fase3_mandrade.dart';

import '../../../core/failures.dart';
import '../../../core/usecases.dart';
import '../../repositories/fake_store_repository.dart';

/// Caso de uso para obtener todos los carritos
///
/// Implementa el principio de Responsabilidad Única (SRP)
class GetAllCarts implements UseCaseNoParams<List<CartEntity>> {
  final FakeStoreRepository repository;

  const GetAllCarts(this.repository);

  @override
  Future<Either<Failure, List<CartEntity>>> call() async {
    return await repository.getAllCarts();
  }
}
