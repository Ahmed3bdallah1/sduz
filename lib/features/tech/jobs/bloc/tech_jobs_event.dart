import 'package:equatable/equatable.dart';
import 'package:sudz/features/tech/jobs/models/models.dart';

abstract class TechJobsEvent extends Equatable {
  const TechJobsEvent();

  @override
  List<Object?> get props => [];
}

class TechJobsStarted extends TechJobsEvent {
  const TechJobsStarted();
}

class TechJobsRefreshed extends TechJobsEvent {
  const TechJobsRefreshed();
}

class TechJobsFilterChanged extends TechJobsEvent {
  final TechJobFilterTag filter;

  const TechJobsFilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}
