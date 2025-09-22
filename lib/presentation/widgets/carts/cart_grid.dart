import 'package:flutter/material.dart';
import 'package:fakestore_fase3_mandrade/fakestore_fase3_mandrade.dart';
import 'cart_card.dart';

class CartGrid extends StatelessWidget {
  final List<CartEntity> carts;
  final Function(int)? onCartTap;

  const CartGrid({super.key, required this.carts, this.onCartTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determinar número de columnas basado en el ancho
        int crossAxisCount;
        if (constraints.maxWidth > 1200) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth > 800) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 1;
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: carts.length,
          itemBuilder: (context, index) {
            final cart = carts[index];
            return CartCard(
              cart: cart,
              onTap: onCartTap != null ? () => onCartTap!(cart.id) : null,
            );
          },
        );
      },
    );
  }
}
