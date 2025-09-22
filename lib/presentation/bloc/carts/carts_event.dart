import 'package:equatable/equatable.dart';

/// Eventos base para el CartsBloc
abstract class CartsEvent extends Equatable {
  const CartsEvent();

  @override
  List<Object> get props => [];
}

/// Evento para cargar todos los carritos
class LoadAllCarts extends CartsEvent {
  const LoadAllCarts();
}

/// Evento para cargar un carrito específico
class LoadCart extends CartsEvent {
  final int cartId;

  const LoadCart(this.cartId);

  @override
  List<Object> get props => [cartId];
}

/// Evento para cargar carritos por usuario
class LoadCartsByUser extends CartsEvent {
  final int userId;

  const LoadCartsByUser(this.userId);

  @override
  List<Object> get props => [userId];
}
