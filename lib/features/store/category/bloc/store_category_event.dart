import 'package:equatable/equatable.dart';

abstract class StoreCategoryEvent extends Equatable {
  const StoreCategoryEvent();

  @override
  List<Object?> get props => [];
}

class StoreCategoryStarted extends StoreCategoryEvent {
  final String categoryId;

  const StoreCategoryStarted(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class StoreCategoryFilterChanged extends StoreCategoryEvent {
  final String filterId;

  const StoreCategoryFilterChanged(this.filterId);

  @override
  List<Object?> get props => [filterId];
}

class StoreCategoryLoadMoreRequested extends StoreCategoryEvent {
  const StoreCategoryLoadMoreRequested();
}
