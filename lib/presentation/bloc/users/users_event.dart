import 'package:equatable/equatable.dart';

/// Eventos base para el UsersBloc
abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object> get props => [];
}

/// Evento para cargar todos los usuarios
class LoadAllUsers extends UsersEvent {
  const LoadAllUsers();
}

/// Evento para cargar un usuario específico
class LoadUser extends UsersEvent {
  final int userId;

  const LoadUser(this.userId);

  @override
  List<Object> get props => [userId];
}

/// Evento para limpiar el usuario seleccionado
class ClearSelectedUser extends UsersEvent {
  const ClearSelectedUser();
}
