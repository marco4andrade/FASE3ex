import 'package:equatable/equatable.dart';

/// Eventos base para el ProductsBloc
abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

/// Evento para cargar todos los productos
class LoadAllProducts extends ProductsEvent {
  const LoadAllProducts();
}

/// Evento para cargar un producto específico
class LoadProduct extends ProductsEvent {
  final int productId;

  const LoadProduct(this.productId);

  @override
  List<Object> get props => [productId];
}

/// Evento para cargar todas las categorías
class LoadCategories extends ProductsEvent {
  const LoadCategories();
}

/// Evento para cargar productos por categoría
class LoadProductsByCategory extends ProductsEvent {
  final String category;

  const LoadProductsByCategory(this.category);

  @override
  List<Object> get props => [category];
}

/// Evento para limpiar los detalles del producto seleccionado
class ClearSelectedProduct extends ProductsEvent {
  const ClearSelectedProduct();
}
