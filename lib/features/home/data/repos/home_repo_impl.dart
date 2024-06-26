import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ekhtarly_app/core/errors/failure.dart';
import 'package:ekhtarly_app/core/utils/api_service.dart';
import 'package:ekhtarly_app/features/home/data/model/newest_laptop/newest_laptop_model.dart';
import 'package:ekhtarly_app/features/home/data/model/profile.dart';
import 'package:ekhtarly_app/features/home/data/repos/home_repo.dart';

class HomeRepoImpl implements HomeRepo {
  final ApiService apiService;
  HomeRepoImpl(this.apiService);
  @override
  Future<Either<Failure, NewestLaptopModel>> getNewestLaptops() async {
    try {
      var data = await apiService.get(
        endpoint: 'api/laptops?page=1&limit=8',
      );
      //log('true data :$data');
      return right(NewestLaptopModel.fromJson(data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.formDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
   @override
  Future<Either<Failure, Profile>> getprofile() async {
    try {
      var data = await apiService.get(
        endpoint: 'auth/profile',
      );
      return right(Profile.fromjson(data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.formDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> changePassword(
      Map<String, String> body) async {
    try {

      var data =
          await apiService.patch(endpoint: 'auth/change-password', data: body);
      Map<String, dynamic> message;
      message = data ;
      return Right(message);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.formDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
