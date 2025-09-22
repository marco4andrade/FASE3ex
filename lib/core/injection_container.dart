import 'package:get_it/get_it.dart';
import 'package:fakestore_fase3_mandrade/fakestore_fase3_mandrade.dart';

import '../data/repositories/fake_store_repository_impl.dart';
import '../domain/repositories/fake_store_repository.dart';
import '../domain/usecases/products/get_all_products.dart';
import '../domain/usecases/products/get_product.dart';
import '../domain/usecases/products/get_categories.dart';
import '../domain/usecases/products/get_products_in_category.dart';
import '../domain/usecases/users/get_all_users.dart';
import '../domain/usecases/users/get_user.dart';
import '../domain/usecases/carts/get_all_carts.dart';
import '../domain/usecases/carts/get_cart.dart';
import '../domain/usecases/carts/get_carts_by_user.dart';
import '../presentation/bloc/products/products_bloc.dart';
import '../presentation/bloc/users/users_bloc.dart';
import '../presentation/bloc/carts/carts_bloc.dart';

/// Service Locator singleton para inyección de dependencias
final sl = GetIt.instance;

/// Inicializa todas las dependencias de la aplicación
///
/// Sigue el patrón de inyección de dependencias respetando:
/// - Single Responsibility: Cada clase tiene una responsabilidad
/// - Dependency Inversion: Las clases dependen de abstracciones
Future<void> init() async {
  //! Features - Products
  // Bloc
  sl.registerFactory(
    () => ProductsBloc(
      getAllProducts: sl(),
      getProduct: sl(),
      getCategories: sl(),
      getProductsInCategory: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllProducts(sl()));
  sl.registerLazySingleton(() => GetProduct(sl()));
  sl.registerLazySingleton(() => GetCategories(sl()));
  sl.registerLazySingleton(() => GetProductsInCategory(sl()));

  //! Features - Users
  // Bloc
  sl.registerFactory(() => UsersBloc(getAllUsers: sl(), getUser: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetAllUsers(sl()));
  sl.registerLazySingleton(() => GetUser(sl()));

  //! Features - Carts
  // Bloc
  sl.registerFactory(
    () => CartsBloc(getAllCarts: sl(), getCart: sl(), getCartsByUser: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllCarts(sl()));
  sl.registerLazySingleton(() => GetCart(sl()));
  sl.registerLazySingleton(() => GetCartsByUser(sl()));

  //! Core
  // Repository
  sl.registerLazySingleton<FakeStoreRepository>(
    () => FakeStoreRepositoryImpl(service: sl()),
  );

  //! External
  // FakeStoreService del paquete principal
  sl.registerLazySingleton(() => FakeStoreService());
}
