import 'package:equatable/equatable.dart';

class AppContentPage extends Equatable {
  const AppContentPage({required this.slug, required this.content});

  final String slug;
  final String content;

  @override
  List<Object?> get props => [slug, content];
}
