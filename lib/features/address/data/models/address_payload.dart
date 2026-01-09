import '../../../../core/models/json_types.dart';

class AddressPayload {
  const AddressPayload({
    this.title,
    this.description,
    this.latitude,
    this.longitude,
    this.city,
    this.district,
    this.streetName,
    this.buildingNumber,
    this.addressType,
    this.isDefault,
  });

  final String? title;
  final String? description;
  final double? latitude;
  final double? longitude;
  final String? city;
  final String? district;
  final String? streetName;
  final String? buildingNumber;
  final String? addressType;
  final bool? isDefault;

  JsonMap toJson() {
    final map = <String, dynamic>{};

    void put(String key, dynamic value) {
      if (value == null) return;
      map[key] = value;
    }

    put('title', title);
    put('description', description);
    put('lat', latitude);
    put('lng', longitude);
    put('city', city);
    put('district', district);
    put('street_name', streetName);
    put('building_number', buildingNumber);
    put('address_type', addressType);
    put('is_default', isDefault);

    return map;
  }
}
