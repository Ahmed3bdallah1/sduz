import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeStarted extends HomeEvent {
  const HomeStarted();
}

class HomeCategorySelected extends HomeEvent {
  final String categoryId;

  const HomeCategorySelected(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class HomeBottomNavChanged extends HomeEvent {
  final int index;

  const HomeBottomNavChanged(this.index);

  @override
  List<Object?> get props => [index];
}
