import 'package:equatable/equatable.dart';
import 'package:fakestore_fase3_mandrade/fakestore_fase3_mandrade.dart';

/// Estados base para el UsersBloc
abstract class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class UsersInitial extends UsersState {
  const UsersInitial();
}

/// Estado de carga
class UsersLoading extends UsersState {
  const UsersLoading();
}

/// Estado de éxito con lista de usuarios
class UsersLoaded extends UsersState {
  final List<UserEntity> users;
  final UserEntity? selectedUser;

  const UsersLoaded({required this.users, this.selectedUser});

  @override
  List<Object?> get props => [users, selectedUser];

  /// Copia el estado con nuevos valores
  UsersLoaded copyWith({
    List<UserEntity>? users,
    UserEntity? selectedUser,
    bool clearSelectedUser = false,
  }) {
    return UsersLoaded(
      users: users ?? this.users,
      selectedUser: clearSelectedUser
          ? null
          : selectedUser ?? this.selectedUser,
    );
  }
}

/// Estado de error
class UsersError extends UsersState {
  final String message;

  const UsersError(this.message);

  @override
  List<Object> get props => [message];
}
