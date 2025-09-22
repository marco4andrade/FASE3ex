import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/products/get_all_products.dart';
import '../../../domain/usecases/products/get_product.dart';
import '../../../domain/usecases/products/get_categories.dart';
import '../../../domain/usecases/products/get_products_in_category.dart';
import 'products_event.dart';
import 'products_state.dart';

/// BLoC para manejar el estado de los productos
///
/// Implementa el patrón BLoC para separar la lógica de negocio de la UI
/// Respeta el principio de Responsabilidad Única (SRP)
class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetAllProducts getAllProducts;
  final GetProduct getProduct;
  final GetCategories getCategories;
  final GetProductsInCategory getProductsInCategory;

  ProductsBloc({
    required this.getAllProducts,
    required this.getProduct,
    required this.getCategories,
    required this.getProductsInCategory,
  }) : super(const ProductsInitial()) {
    on<LoadAllProducts>(_onLoadAllProducts);
    on<LoadProduct>(_onLoadProduct);
    on<LoadCategories>(_onLoadCategories);
    on<LoadProductsByCategory>(_onLoadProductsByCategory);
    on<ClearSelectedProduct>(_onClearSelectedProduct);
  }

  /// Maneja el evento de cargar todos los productos
  Future<void> _onLoadAllProducts(
    LoadAllProducts event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductsLoading());

    final productsResult = await getAllProducts();
    final categoriesResult = await getCategories();

    productsResult.fold((failure) => emit(ProductsError(failure.message)), (
      products,
    ) {
      categoriesResult.fold(
        (failure) => emit(ProductsError(failure.message)),
        (categories) =>
            emit(ProductsLoaded(products: products, categories: categories)),
      );
    });
  }

  /// Maneja el evento de cargar un producto específico
  Future<void> _onLoadProduct(
    LoadProduct event,
    Emitter<ProductsState> emit,
  ) async {
    // Si hay un estado ProductsLoaded, mantener los datos existentes
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;

      final result = await getProduct(
        GetProductParams(productId: event.productId),
      );

      result.fold(
        (failure) => emit(ProductsError(failure.message)),
        (product) => emit(currentState.copyWith(selectedProduct: product)),
      );
    } else {
      // Si no hay estado ProductsLoaded, crear uno temporal solo para el producto
      emit(const ProductsLoading());

      final result = await getProduct(
        GetProductParams(productId: event.productId),
      );

      result.fold(
        (failure) => emit(ProductsError(failure.message)),
        (product) => emit(
          ProductsLoaded(
            products: const [],
            categories: const [],
            selectedProduct: product,
          ),
        ),
      );
    }
  }

  /// Maneja el evento de cargar categorías
  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<ProductsState> emit,
  ) async {
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;

      final result = await getCategories();

      result.fold(
        (failure) => emit(ProductsError(failure.message)),
        (categories) => emit(currentState.copyWith(categories: categories)),
      );
    }
  }

  /// Maneja el evento de cargar productos por categoría
  Future<void> _onLoadProductsByCategory(
    LoadProductsByCategory event,
    Emitter<ProductsState> emit,
  ) async {
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      emit(const ProductsLoading());

      final result = await getProductsInCategory(
        GetProductsInCategoryParams(category: event.category),
      );

      result.fold(
        (failure) => emit(ProductsError(failure.message)),
        (products) => emit(
          currentState.copyWith(
            products: products,
            selectedCategory: event.category,
            clearSelectedProduct: true,
          ),
        ),
      );
    }
  }

  /// Maneja el evento de limpiar el producto seleccionado
  void _onClearSelectedProduct(
    ClearSelectedProduct event,
    Emitter<ProductsState> emit,
  ) {
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      emit(currentState.copyWith(clearSelectedProduct: true));
    }
  }
}
