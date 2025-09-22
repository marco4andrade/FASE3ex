import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/carts/get_all_carts.dart';
import '../../../domain/usecases/carts/get_cart.dart';
import '../../../domain/usecases/carts/get_carts_by_user.dart';
import 'carts_event.dart';
import 'carts_state.dart';

/// BLoC para manejar el estado de los carritos
///
/// Implementa el patrón BLoC para separar la lógica de negocio de la UI
/// Respeta el principio de Responsabilidad Única (SRP)
class CartsBloc extends Bloc<CartsEvent, CartsState> {
  final GetAllCarts getAllCarts;
  final GetCart getCart;
  final GetCartsByUser getCartsByUser;

  CartsBloc({
    required this.getAllCarts,
    required this.getCart,
    required this.getCartsByUser,
  }) : super(const CartsInitial()) {
    on<LoadAllCarts>(_onLoadAllCarts);
    on<LoadCart>(_onLoadCart);
    on<LoadCartsByUser>(_onLoadCartsByUser);
  }

  /// Maneja el evento de cargar todos los carritos
  Future<void> _onLoadAllCarts(
    LoadAllCarts event,
    Emitter<CartsState> emit,
  ) async {
    emit(const CartsLoading());

    final result = await getAllCarts();

    result.fold(
      (failure) => emit(CartsError(failure.message)),
      (carts) => emit(CartsLoaded(carts: carts)),
    );
  }

  /// Maneja el evento de cargar un carrito específico
  Future<void> _onLoadCart(LoadCart event, Emitter<CartsState> emit) async {
    emit(const CartsLoading());

    final result = await getCart(event.cartId);

    result.fold(
      (failure) => emit(CartsError(failure.message)),
      (cart) => emit(CartsLoaded(carts: [cart])),
    );
  }

  /// Maneja el evento de cargar carritos por usuario
  Future<void> _onLoadCartsByUser(
    LoadCartsByUser event,
    Emitter<CartsState> emit,
  ) async {
    emit(const CartsLoading());

    final result = await getCartsByUser(
      GetCartsByUserParams(userId: event.userId),
    );

    result.fold(
      (failure) => emit(CartsError(failure.message)),
      (carts) => emit(CartsLoaded(carts: carts)),
    );
  }
}
