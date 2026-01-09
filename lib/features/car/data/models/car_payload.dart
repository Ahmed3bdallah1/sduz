import '../../../../core/models/json_types.dart';

class CarPayload {
  const CarPayload({
    this.name,
    this.brand,
    this.model,
    this.year,
    this.color,
    this.plateNumber,
    this.carSizeId,
    this.isPrimary,
    this.imageUrl,
  });

  final String? name;
  final String? brand;
  final String? model;
  final int? year;
  final String? color;
  final String? plateNumber;
  final int? carSizeId;
  final bool? isPrimary;
  final String? imageUrl;

  JsonMap toJson() {
    final map = <String, dynamic>{};

    void add(String key, dynamic value) {
      if (value == null) return;
      map[key] = value;
    }

    add('name', name);
    add('brand', brand);
    add('model', model);
    add('year', year);
    add('color', color);
    add('plate_number', plateNumber);
    add('car_size_id', carSizeId);
    add('is_primary', isPrimary);
    add('image', imageUrl);

    return map;
  }

  CarPayload merge(CarPayload other) {
    return CarPayload(
      name: other.name ?? name,
      brand: other.brand ?? brand,
      model: other.model ?? model,
      year: other.year ?? year,
      color: other.color ?? color,
      plateNumber: other.plateNumber ?? plateNumber,
      carSizeId: other.carSizeId ?? carSizeId,
      isPrimary: other.isPrimary ?? isPrimary,
      imageUrl: other.imageUrl ?? imageUrl,
    );
  }
}
