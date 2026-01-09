import '../../../../core/models/json_types.dart';
import '../../domain/entities/car_size.dart';

class CarSizeDto {
  const CarSizeDto({required this.id, required this.name, this.description});

  final int id;
  final String name;
  final String? description;

  factory CarSizeDto.fromJson(JsonMap json) {
    return CarSizeDto(
      id: _toInt(json['id']) ?? 0,
      name: _stringify(json['name']) ?? 'غير محدد',
      description: _stringify(json['description']),
    );
  }

  CarSize toEntity() => CarSize(id: id, name: name, description: description);

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String && value.trim().isNotEmpty) {
      return int.tryParse(value.trim());
    }
    return null;
  }

  static String? _stringify(dynamic value) {
    if (value == null) return null;
    if (value is String) return value.trim();
    return value.toString();
  }
}
