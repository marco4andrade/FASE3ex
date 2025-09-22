import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fakestore_fase3_mandrade/fakestore_fase3_mandrade.dart';

import '../../../core/failures.dart';
import '../../../core/usecases.dart';
import '../../repositories/fake_store_repository.dart';

/// Caso de uso para obtener un producto específico por ID
///
/// Implementa el principio de Responsabilidad Única (SRP)
class GetProduct implements UseCase<ProductEntity, GetProductParams> {
  final FakeStoreRepository repository;

  const GetProduct(this.repository);

  @override
  Future<Either<Failure, ProductEntity>> call(GetProductParams params) async {
    return await repository.getProduct(params.productId);
  }
}

/// Parámetros para el caso de uso GetProduct
class GetProductParams extends Equatable {
  final int productId;

  const GetProductParams({required this.productId});

  @override
  List<Object> get props => [productId];
}
