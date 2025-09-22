import 'package:dartz/dartz.dart';
import 'package:fakestore_fase3_mandrade/fakestore_fase3_mandrade.dart';

import '../../../core/failures.dart';
import '../../../core/usecases.dart';
import '../../repositories/fake_store_repository.dart';

/// Caso de uso para obtener todos los productos
///
/// Implementa el principio de Responsabilidad Única (SRP)
/// Su única responsabilidad es coordinar la obtención de todos los productos
class GetAllProducts implements UseCaseNoParams<List<ProductEntity>> {
  final FakeStoreRepository repository;

  const GetAllProducts(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call() async {
    return await repository.getAllProducts();
  }
}
