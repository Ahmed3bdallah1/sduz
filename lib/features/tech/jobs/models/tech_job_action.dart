import 'package:equatable/equatable.dart';

enum TechJobActionKind { arrive, startWork, completeWork, reject }

class TechJobPendingAction extends Equatable {
  final String id;
  final TechJobActionKind action;
  final String labelKey;
  final List<String> labelArgs;
  final DateTime createdAt;
  final bool isSynced;

  const TechJobPendingAction({
    required this.id,
    required this.action,
    required this.labelKey,
    this.labelArgs = const [],
    required this.createdAt,
    this.isSynced = false,
  });

  TechJobPendingAction copyWith({
    String? id,
    TechJobActionKind? action,
    String? labelKey,
    List<String>? labelArgs,
    DateTime? createdAt,
    bool? isSynced,
  }) {
    return TechJobPendingAction(
      id: id ?? this.id,
      action: action ?? this.action,
      labelKey: labelKey ?? this.labelKey,
      labelArgs: labelArgs ?? this.labelArgs,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  List<Object?> get props => [
    id,
    action,
    labelKey,
    labelArgs,
    createdAt,
    isSynced,
  ];
}
