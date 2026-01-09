import 'package:equatable/equatable.dart';

import 'tech_job.dart';

enum TechJobEvidenceCategory { preWork, postWork, rejection }

extension TechJobEvidenceCategoryX on TechJobEvidenceCategory {
  bool get isPre => this == TechJobEvidenceCategory.preWork;
  bool get isPost => this == TechJobEvidenceCategory.postWork;
  bool get isRejection => this == TechJobEvidenceCategory.rejection;
}

class TechJobEvidenceItem extends Equatable {
  final String id;
  final TechJobEvidenceCategory category;
  final String label;
  final bool isUploaded;
  final bool hasError;
  final DateTime createdAt;

  const TechJobEvidenceItem({
    required this.id,
    required this.category,
    required this.label,
    this.isUploaded = true,
    this.hasError = false,
    required this.createdAt,
  });

  TechJobEvidenceItem copyWith({
    String? id,
    TechJobEvidenceCategory? category,
    String? label,
    bool? isUploaded,
    bool? hasError,
    DateTime? createdAt,
  }) {
    return TechJobEvidenceItem(
      id: id ?? this.id,
      category: category ?? this.category,
      label: label ?? this.label,
      isUploaded: isUploaded ?? this.isUploaded,
      hasError: hasError ?? this.hasError,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    category,
    label,
    isUploaded,
    hasError,
    createdAt,
  ];
}

class TechJobTimelineEntry extends Equatable {
  final String id;
  final TechJobStatus status;
  final String titleKey;
  final List<String>? titleArgs;
  final String? noteKey;
  final List<String>? noteArgs;
  final DateTime timestamp;
  final String actor;

  const TechJobTimelineEntry({
    required this.id,
    required this.status,
    required this.titleKey,
    this.titleArgs,
    this.noteKey,
    this.noteArgs,
    required this.timestamp,
    this.actor = 'Technician',
  });

  TechJobTimelineEntry copyWith({
    String? id,
    TechJobStatus? status,
    String? titleKey,
    List<String>? titleArgs,
    String? noteKey,
    List<String>? noteArgs,
    DateTime? timestamp,
    String? actor,
  }) {
    return TechJobTimelineEntry(
      id: id ?? this.id,
      status: status ?? this.status,
      titleKey: titleKey ?? this.titleKey,
      titleArgs: titleArgs ?? this.titleArgs,
      noteKey: noteKey ?? this.noteKey,
      noteArgs: noteArgs ?? this.noteArgs,
      timestamp: timestamp ?? this.timestamp,
      actor: actor ?? this.actor,
    );
  }

  @override
  List<Object?> get props => [
    id,
    status,
    titleKey,
    titleArgs,
    noteKey,
    noteArgs,
    timestamp,
    actor,
  ];
}
