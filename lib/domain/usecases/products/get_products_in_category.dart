import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fakestore_fase3_mandrade/fakestore_fase3_mandrade.dart';

import '../../../core/failures.dart';
import '../../../core/usecases.dart';
import '../../repositories/fake_store_repository.dart';

/// Caso de uso para obtener productos de una categoría específica
///
/// Implementa el principio de Responsabilidad Única (SRP)
class GetProductsInCategory
    implements UseCase<List<ProductEntity>, GetProductsInCategoryParams> {
  final FakeStoreRepository repository;

  const GetProductsInCategory(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(
    GetProductsInCategoryParams params,
  ) async {
    return await repository.getProductsInCategory(params.category);
  }
}

/// Parámetros para el caso de uso GetProductsInCategory
class GetProductsInCategoryParams extends Equatable {
  final String category;

  const GetProductsInCategoryParams({required this.category});

  @override
  List<Object> get props => [category];
}
