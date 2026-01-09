import 'package:equatable/equatable.dart';
import 'package:sudz/features/store/shared/models/models.dart';

enum StoreHomeStatus { initial, loading, success, failure }

extension StoreHomeStatusX on StoreHomeStatus {
  bool get isInitial => this == StoreHomeStatus.initial;
  bool get isLoading => this == StoreHomeStatus.loading;
  bool get isSuccess => this == StoreHomeStatus.success;
  bool get isFailure => this == StoreHomeStatus.failure;
}

class StoreHomeState extends Equatable {
  final StoreHomeStatus status;
  final List<StoreCategory> categories;
  final String? errorMessage;

  const StoreHomeState({
    this.status = StoreHomeStatus.initial,
    this.categories = const [],
    this.errorMessage,
  });

  StoreHomeState copyWith({
    StoreHomeStatus? status,
    List<StoreCategory>? categories,
    String? errorMessage,
  }) {
    return StoreHomeState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, categories, errorMessage];
}
