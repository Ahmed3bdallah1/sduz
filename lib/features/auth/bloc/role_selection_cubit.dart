import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudz/core/local_database/local_database_service.dart';

enum AuthRole { client, technical }

extension AuthRoleX on AuthRole {
  bool get isClient => this == AuthRole.client;
  bool get isTechnical => this == AuthRole.technical;
}

class RoleSelectionState extends Equatable {
  final AuthRole role;
  final bool isRoleLocked;

  const RoleSelectionState({
    this.role = AuthRole.client,
    this.isRoleLocked = false,
  });

  RoleSelectionState copyWith({AuthRole? role, bool? isRoleLocked}) {
    return RoleSelectionState(
      role: role ?? this.role,
      isRoleLocked: isRoleLocked ?? this.isRoleLocked,
    );
  }

  @override
  List<Object?> get props => [role, isRoleLocked];
}

class RoleSelectionCubit extends Cubit<RoleSelectionState> {
  RoleSelectionCubit(LocalDatabaseService database)
      : _database = database,
        super(
          RoleSelectionState(
            role: resolveStoredRole(database.getUserRole()),
          ),
        );

  final LocalDatabaseService _database;

  void selectRole(AuthRole role) {
    if (state.isRoleLocked && role != state.role) return;
    emit(state.copyWith(role: role));
    unawaited(_database.saveUserRole(role.name));
  }

  void lockRole(AuthRole role) {
    emit(state.copyWith(role: role, isRoleLocked: true));
    unawaited(_database.saveUserRole(role.name));
  }

  void unlockRole() {
    emit(state.copyWith(isRoleLocked: false));
  }

  static AuthRole resolveStoredRole(String? value) {
    switch (value) {
      case 'technical':
        return AuthRole.technical;
      case 'client':
        return AuthRole.client;
      default:
        return AuthRole.client;
    }
  }
}
