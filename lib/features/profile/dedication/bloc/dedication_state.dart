import 'package:equatable/equatable.dart';
import 'package:sudz/features/profile/shared/models/models.dart';

enum DedicationStatus { initial, loading, ready, submitting, success, failure }

extension DedicationStatusX on DedicationStatus {
  bool get isInitial => this == DedicationStatus.initial;
  bool get isLoading => this == DedicationStatus.loading;
  bool get isReady => this == DedicationStatus.ready;
  bool get isSubmitting => this == DedicationStatus.submitting;
  bool get isSuccess => this == DedicationStatus.success;
  bool get isFailure => this == DedicationStatus.failure;
}

class DedicationState extends Equatable {
  final DedicationStatus status;
  final String phoneNumber;
  final List<ProfileDedicationType> types;
  final String? selectedTypeId;
  final String? errorMessage;

  const DedicationState({
    this.status = DedicationStatus.initial,
    this.phoneNumber = '',
    this.types = const [],
    this.selectedTypeId,
    this.errorMessage,
  });

  ProfileDedicationType? get selectedType {
    if (selectedTypeId == null) return null;
    try {
      return types.firstWhere((type) => type.id == selectedTypeId);
    } catch (_) {
      return null;
    }
  }

  DedicationState copyWith({
    DedicationStatus? status,
    String? phoneNumber,
    List<ProfileDedicationType>? types,
    String? selectedTypeId,
    String? errorMessage,
  }) {
    return DedicationState(
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      types: types ?? this.types,
      selectedTypeId: selectedTypeId ?? this.selectedTypeId,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        phoneNumber,
        types,
        selectedTypeId,
        errorMessage,
      ];
}
