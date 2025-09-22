import 'package:dartz/dartz.dart';

import '../../../core/failures.dart';
import '../../../core/usecases.dart';
import '../../repositories/fake_store_repository.dart';

/// Caso de uso para obtener todas las categorías de productos
///
/// Implementa el principio de Responsabilidad Única (SRP)
class GetCategories implements UseCaseNoParams<List<String>> {
  final FakeStoreRepository repository;

  const GetCategories(this.repository);

  @override
  Future<Either<Failure, List<String>>> call() async {
    return await repository.getCategories();
  }
}
