import 'package:flutterfooddiscovery_streetbite/core/data_source.dart/data_source_interface.dart';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';

class RemoteDataSource implements DataSourceInterface {
  final Dio _dio;

  RemoteDataSource(this._dio);

  @override
  Future<Either<List<Map<String, dynamic>>, String>> getList(String url, {Map<String, dynamic>? queryParams, Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParams, options: Options(headers: headers));
      if (response.statusCode == 200 && response.data is List<dynamic>) {
        return Left(response.data.map((e) => e as Map<String, dynamic>).toList());
      } else {
        return Right(_errorMessage(response));
      }
    } catch (e) {
      return Right('unknown error');
    }
  }

  @override
  Future<Either<Map<String, dynamic>, String>> getEntity(String url, String id, {String key = 'id', Map<String, dynamic>? queryParams, Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.get(url + '/' + id, queryParameters: queryParams, options: Options(headers: headers));
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return Left(response.data);
      } else {
        return Right(_errorMessage(response));
      }
    } catch (e) {  
      return Right('unknown error');
    }
  }

  @override
  Future<Either<Map<String, dynamic>, String>> post(String url, dynamic data, {Map<String, dynamic>? queryParams, Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.post(url, data: data, queryParameters: queryParams, options: Options(headers: headers));
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return Left(response.data);
      } else {
        return Right(_errorMessage(response));
      }
    } catch (e) {
      return Right('unknown error');
    }
  }

  @override
  Future<Either<Map<String, dynamic>, String>> put(String url, String id, dynamic data, {String key = 'id', Map<String, dynamic>? queryParams, Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.put(url + '/' + id, data: data, queryParameters: queryParams, options: Options(headers: headers));
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return Left(response.data);
      } else {
        return Right(_errorMessage(response));
      }
    } catch (e) {
      return Right('unknown error');
    }
  }

  @override
  Future<Either<bool, String>> delete(String url, String id, {String key = 'id', Map<String, dynamic>? queryParams, Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.delete(url + '/' + id, queryParameters: queryParams, options: Options(headers: headers));
      if (response.statusCode == 200) {
        return Left(true);
      } else {
        return Right(_errorMessage(response));
      }
    } catch (e) {
      return Right('unknown error');
    }
  }

  String _errorMessage(Response<dynamic> response) {
    final data = response.data;
    final message = data is Map ? data['message']?.toString() ?? '' : '';
    final preview = message.length > 20 ? message.substring(0, 20) : message;
    return '${response.statusCode ?? ''} $preview'.trim();
  }
}
