import 'package:dartz/dartz.dart';

import '../../../core/failures.dart';
import '../../../core/usecases.dart';
import 'package:fakestore_fase3_mandrade/fakestore_fase3_mandrade.dart';
import '../../repositories/fake_store_repository.dart';

/// Caso de uso para obtener un carrito específico por ID
///
/// Implementa Clean Architecture y principios SOLID:
/// - SRP: Solo responsable de obtener un carrito por ID
/// - DIP: Depende de abstracciones (FakeStoreRepository)
class GetCart implements UseCase<CartEntity, int> {
  final FakeStoreRepository repository;

  const GetCart(this.repository);

  @override
  Future<Either<Failure, CartEntity>> call(int cartId) async {
    return await repository.getCart(cartId);
  }
}
