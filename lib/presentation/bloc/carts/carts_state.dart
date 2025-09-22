import 'package:equatable/equatable.dart';
import 'package:fakestore_fase3_mandrade/fakestore_fase3_mandrade.dart';

/// Estados base para el CartsBloc
abstract class CartsState extends Equatable {
  const CartsState();

  @override
  List<Object> get props => [];
}

/// Estado inicial
class CartsInitial extends CartsState {
  const CartsInitial();
}

/// Estado de carga
class CartsLoading extends CartsState {
  const CartsLoading();
}

/// Estado de éxito con lista de carritos
class CartsLoaded extends CartsState {
  final List<CartEntity> carts;

  const CartsLoaded({required this.carts});

  @override
  List<Object> get props => [carts];
}

/// Estado de error
class CartsError extends CartsState {
  final String message;

  const CartsError(this.message);

  @override
  List<Object> get props => [message];
}
