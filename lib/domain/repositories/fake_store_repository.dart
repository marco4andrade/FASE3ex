import 'package:dartz/dartz.dart';
import 'package:fakestore_fase3_mandrade/fakestore_fase3_mandrade.dart';
import '../../core/failures.dart';

/// Repositorio abstracto que define los contratos para interactuar con la Fake Store API
///
/// Respeta el principio de Inversión de Dependencias (DIP) definiendo la abstracción
/// que será implementada por la capa de datos
abstract class FakeStoreRepository {
  /// Obtiene todos los productos disponibles
  Future<Either<Failure, List<ProductEntity>>> getAllProducts();

  /// Obtiene un producto específico por su ID
  Future<Either<Failure, ProductEntity>> getProduct(int productId);

  /// Obtiene todas las categorías disponibles
  Future<Either<Failure, List<String>>> getCategories();

  /// Obtiene productos de una categoría específica
  Future<Either<Failure, List<ProductEntity>>> getProductsInCategory(
    String category,
  );

  /// Obtiene todos los usuarios disponibles
  Future<Either<Failure, List<UserEntity>>> getAllUsers();

  /// Obtiene un usuario específico por su ID
  Future<Either<Failure, UserEntity>> getUser(int userId);

  /// Obtiene todos los carritos disponibles
  Future<Either<Failure, List<CartEntity>>> getAllCarts();

  /// Obtiene un carrito específico por su ID
  Future<Either<Failure, CartEntity>> getCart(int cartId);

  /// Obtiene carritos de un usuario específico
  Future<Either<Failure, List<CartEntity>>> getCartsByUser(int userId);
}
