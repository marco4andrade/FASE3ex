import 'package:dartz/dartz.dart';
import 'package:fakestore_fase3_mandrade/fakestore_fase3_mandrade.dart';

import '../../core/failures.dart';
import '../../domain/repositories/fake_store_repository.dart';

/// Implementación concreta del repositorio FakeStore
///
/// Respeta el principio de Inversión de Dependencias (DIP) implementando la abstracción
/// definida en la capa de dominio
class FakeStoreRepositoryImpl implements FakeStoreRepository {
  final FakeStoreService service;

  const FakeStoreRepositoryImpl({required this.service});

  @override
  Future<Either<Failure, List<ProductEntity>>> getAllProducts() async {
    try {
      final products = await service.getAllProducts();
      return Right(products);
    } catch (e) {
      return Left(ServerFailure('Error al obtener productos: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProduct(int productId) async {
    try {
      final product = await service.getProduct(productId);
      return Right(product);
    } catch (e) {
      return Left(ServerFailure('Error al obtener producto: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    try {
      final categories = await service.getCategories();
      return Right(categories);
    } catch (e) {
      return Left(
        ServerFailure('Error al obtener categorías: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsInCategory(
    String category,
  ) async {
    try {
      final products = await service.getProductsInCategory(category);
      return Right(products);
    } catch (e) {
      return Left(
        ServerFailure(
          'Error al obtener productos por categoría: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getAllUsers() async {
    try {
      final users = await service.getAllUsers();
      return Right(users);
    } catch (e) {
      return Left(ServerFailure('Error al obtener usuarios: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUser(int userId) async {
    try {
      final user = await service.getUser(userId);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure('Error al obtener usuario: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<CartEntity>>> getAllCarts() async {
    try {
      final carts = await service.getAllCarts();
      return Right(carts);
    } catch (e) {
      return Left(ServerFailure('Error al obtener carritos: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> getCart(int cartId) async {
    try {
      final cart = await service.getCart(cartId);
      return Right(cart);
    } catch (e) {
      return Left(ServerFailure('Error al obtener carrito: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<CartEntity>>> getCartsByUser(int userId) async {
    try {
      final carts = await service.getUserCarts(userId);
      return Right(carts);
    } catch (e) {
      return Left(
        ServerFailure('Error al obtener carritos por usuario: ${e.toString()}'),
      );
    }
  }
}
