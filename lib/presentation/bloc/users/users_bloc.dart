import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/users/get_all_users.dart';
import '../../../domain/usecases/users/get_user.dart';
import 'users_event.dart';
import 'users_state.dart';

/// BLoC para manejar el estado de los usuarios
///
/// Implementa el patrón BLoC para separar la lógica de negocio de la UI
/// Respeta el principio de Responsabilidad Única (SRP)
class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetAllUsers getAllUsers;
  final GetUser getUser;

  UsersBloc({required this.getAllUsers, required this.getUser})
    : super(const UsersInitial()) {
    on<LoadAllUsers>(_onLoadAllUsers);
    on<LoadUser>(_onLoadUser);
    on<ClearSelectedUser>(_onClearSelectedUser);
  }

  /// Maneja el evento de cargar todos los usuarios
  Future<void> _onLoadAllUsers(
    LoadAllUsers event,
    Emitter<UsersState> emit,
  ) async {
    emit(const UsersLoading());

    final result = await getAllUsers();

    result.fold(
      (failure) => emit(UsersError(failure.message)),
      (users) => emit(UsersLoaded(users: users)),
    );
  }

  /// Maneja el evento de cargar un usuario específico
  Future<void> _onLoadUser(LoadUser event, Emitter<UsersState> emit) async {
    if (state is UsersLoaded) {
      final currentState = state as UsersLoaded;

      final result = await getUser(GetUserParams(userId: event.userId));

      result.fold(
        (failure) => emit(UsersError(failure.message)),
        (user) => emit(currentState.copyWith(selectedUser: user)),
      );
    }
  }

  /// Maneja el evento de limpiar el usuario seleccionado
  void _onClearSelectedUser(ClearSelectedUser event, Emitter<UsersState> emit) {
    if (state is UsersLoaded) {
      final currentState = state as UsersLoaded;
      emit(currentState.copyWith(clearSelectedUser: true));
    }
  }
}
