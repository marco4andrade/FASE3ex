import 'package:flutter/material.dart';
import 'package:fakestore_fase3_mandrade/fakestore_fase3_mandrade.dart';
import 'product_card.dart';

/// Widget de grid de productos responsivo
///
/// Implementa SRP - responsable únicamente del layout en grid de productos
class ProductGrid extends StatelessWidget {
  final List<ProductEntity> products;
  final Function(int productId) onProductTap;

  const ProductGrid({
    super.key,
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determinar número de columnas basado en el ancho
        int crossAxisCount;
        if (constraints.maxWidth > 1200) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth > 900) {
          crossAxisCount = 3;
        } else {
          crossAxisCount = 2;
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onTap: () => onProductTap(product.id),
            );
          },
        );
      },
    );
  }
}
