import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fakestore_fase3_mandrade/fakestore_fase3_mandrade.dart';

import '../../../core/failures.dart';
import '../../../core/usecases.dart';
import '../../repositories/fake_store_repository.dart';

/// Caso de uso para obtener un usuario específico por ID
///
/// Implementa el principio de Responsabilidad Única (SRP)
class GetUser implements UseCase<UserEntity, GetUserParams> {
  final FakeStoreRepository repository;

  const GetUser(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(GetUserParams params) async {
    return await repository.getUser(params.userId);
  }
}

/// Parámetros para el caso de uso GetUser
class GetUserParams extends Equatable {
  final int userId;

  const GetUserParams({required this.userId});

  @override
  List<Object> get props => [userId];
}
