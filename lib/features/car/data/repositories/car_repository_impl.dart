import '../../domain/entities/car_size.dart';
import '../../domain/entities/user_car.dart';
import '../../domain/repositories/car_repository.dart';
import '../datasources/car_remote_data_source.dart';
import '../models/car_payload.dart';

class CarRepositoryImpl implements CarRepository {
  CarRepositoryImpl(this._remote);

  final CarRemoteDataSource _remote;

  @override
  Future<List<UserCar>> fetchCars() async {
    final response = await _remote.fetchCars();
    return response.map((dto) => dto.toEntity()).toList(growable: false);
  }

  @override
  Future<List<CarSize>> fetchCarSizes() async {
    final response = await _remote.fetchCarSizes();
    return response.map((dto) => dto.toEntity()).toList(growable: false);
  }

  @override
  Future<UserCar> createCar(CarPayload payload) async {
    final dto = await _remote.createCar(payload);
    return dto.toEntity();
  }

  @override
  Future<UserCar> updateCar({
    required String id,
    required CarPayload payload,
  }) async {
    final dto = await _remote.updateCar(id: id, payload: payload);
    return dto.toEntity();
  }

  @override
  Future<void> deleteCar(String id) {
    return _remote.deleteCar(id);
  }

  @override
  Future<UserCar> setPrimaryCar(String id) async {
    final dto = await _remote.setPrimaryCar(id);
    return dto.toEntity();
  }
}
