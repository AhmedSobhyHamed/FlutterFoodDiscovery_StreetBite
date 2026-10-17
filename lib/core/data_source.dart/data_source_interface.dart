import 'package:dartz/dartz.dart';

abstract interface class DataSourceInterface {
  Future<Either<List<Map<String, dynamic>>, String>> getList(String url, {Map<String, dynamic>? queryParams, Map<String, dynamic>? headers});
  Future<Either<Map<String, dynamic>, String>> getEntity(String url, String id, {String key = 'id', Map<String, dynamic>? queryParams, Map<String, dynamic>? headers});
  Future<Either<Map<String, dynamic>, String>> post(String url, dynamic data, {Map<String, dynamic>? queryParams, Map<String, dynamic>? headers});
  Future<Either<Map<String, dynamic>, String>> put(String url, String id, dynamic data, {String key = 'id', Map<String, dynamic>? queryParams, Map<String, dynamic>? headers});
  Future<Either<bool, String>> delete(String url, String id, {String key = 'id', Map<String, dynamic>? queryParams, Map<String, dynamic>? headers});
}