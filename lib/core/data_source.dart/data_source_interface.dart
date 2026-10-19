import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';

abstract interface class DataSourceInterface {
  Future<Either<List<Map<String, dynamic>>, AppException>> getList(String url, {Map<String, dynamic>? queryParams, Map<String, dynamic>? headers});
  Future<Either<Map<String, dynamic>, AppException>> getMap(String url, {Map<String, dynamic>? queryParams, Map<String, dynamic>? headers});
  Future<Either<Map<String, dynamic>, AppException>> getEntity(String url, String id, {String key = 'id', Map<String, dynamic>? queryParams, Map<String, dynamic>? headers});
  Future<Either<Map<String, dynamic>, AppException>> post(String url, dynamic data, {Map<String, dynamic>? queryParams, Map<String, dynamic>? headers});
  Future<Either<Map<String, dynamic>, AppException>> put(String url, String id, dynamic data, {String key = 'id', Map<String, dynamic>? queryParams, Map<String, dynamic>? headers});
  Future<Either<bool, AppException>> delete(String url, String id, {String key = 'id', Map<String, dynamic>? queryParams, Map<String, dynamic>? headers});
}
