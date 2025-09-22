import 'package:equatable/equatable.dart';
import 'package:fakestore_fase3_mandrade/fakestore_fase3_mandrade.dart';

/// Estados base para el ProductsBloc
abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

/// Estado de carga
class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

/// Estado de éxito con lista de productos
class ProductsLoaded extends ProductsState {
  final List<ProductEntity> products;
  final List<String> categories;
  final String? selectedCategory;
  final ProductEntity? selectedProduct;

  const ProductsLoaded({
    required this.products,
    required this.categories,
    this.selectedCategory,
    this.selectedProduct,
  });

  @override
  List<Object?> get props => [
    products,
    categories,
    selectedCategory,
    selectedProduct,
  ];

  /// Copia el estado con nuevos valores
  ProductsLoaded copyWith({
    List<ProductEntity>? products,
    List<String>? categories,
    String? selectedCategory,
    ProductEntity? selectedProduct,
    bool clearSelectedProduct = false,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedProduct: clearSelectedProduct
          ? null
          : selectedProduct ?? this.selectedProduct,
    );
  }
}

/// Estado de error
class ProductsError extends ProductsState {
  final String message;

  const ProductsError(this.message);

  @override
  List<Object> get props => [message];
}
