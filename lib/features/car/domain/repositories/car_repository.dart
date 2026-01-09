import '../entities/car_size.dart';
import '../entities/user_car.dart';
import '../../data/models/car_payload.dart';

abstract class CarRepository {
  Future<List<UserCar>> fetchCars();

  Future<List<CarSize>> fetchCarSizes();

  Future<UserCar> createCar(CarPayload payload);

  Future<UserCar> updateCar({
    required String id,
    required CarPayload payload,
  });

  Future<void> deleteCar(String id);

  Future<UserCar> setPrimaryCar(String id);
}
