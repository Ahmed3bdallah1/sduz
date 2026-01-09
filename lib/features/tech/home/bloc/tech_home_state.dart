import 'package:equatable/equatable.dart';

enum TechHomeStatus { initial, loading, ready, failure }

extension TechHomeStatusX on TechHomeStatus {
  bool get isInitial => this == TechHomeStatus.initial;
  bool get isLoading => this == TechHomeStatus.loading;
  bool get isReady => this == TechHomeStatus.ready;
  bool get isFailure => this == TechHomeStatus.failure;
}

enum TechHomeTab { jobs, profile }

extension TechHomeTabX on TechHomeTab {
  bool get isJobs => this == TechHomeTab.jobs;
  bool get isProfile => this == TechHomeTab.profile;
}

class TechHomeState extends Equatable {
  final TechHomeStatus status;
  final int bottomNavIndex;
  final String? errorMessage;

  const TechHomeState({
    this.status = TechHomeStatus.initial,
    this.bottomNavIndex = 0,
    this.errorMessage,
  });

  TechHomeState copyWith({
    TechHomeStatus? status,
    int? bottomNavIndex,
    String? errorMessage,
  }) {
    return TechHomeState(
      status: status ?? this.status,
      bottomNavIndex: bottomNavIndex ?? this.bottomNavIndex,
      errorMessage: errorMessage,
    );
  }

  TechHomeTab get currentTab {
    final safeIndex = bottomNavIndex
        .clamp(0, TechHomeTab.values.length - 1)
        .toInt();
    return TechHomeTab.values[safeIndex];
  }

  @override
  List<Object?> get props => [status, bottomNavIndex, errorMessage];
}
