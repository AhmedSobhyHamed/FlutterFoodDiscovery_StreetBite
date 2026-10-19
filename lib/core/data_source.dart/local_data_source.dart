import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/data_source.dart/data_source_interface.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource implements DataSourceInterface {
  LocalDataSource(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  @override
  Future<Either<List<Map<String, dynamic>>, AppException>> getList(
    String url, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = _sharedPreferences.getString(url);
      if (response == null) {
        return Right(GeneralException(message: 'no data found'));
      }
      final decoded = jsonDecode(response);
      if (decoded is! List) {
        return Right(GeneralException(message: 'no data found'));
      }
      final data = decoded
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
      return Left(data);
    } catch (e) {
      return Right(GeneralException(message: 'unknown error'));
    }
  }

  @override
  Future<Either<Map<String, dynamic>, AppException>> getMap(
    String url, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = _sharedPreferences.getString(url);
      if (response == null) {
        return Right(GeneralException(message: 'no data found'));
      }
      final decoded = jsonDecode(response);
      if (decoded is! Map) {
        return Right(GeneralException(message: 'no data found'));
      }
      return Left(Map<String, dynamic>.from(decoded));
    } catch (e) {
      return Right(GeneralException(message: 'unknown error'));
    }
  }

  @override
  Future<Either<Map<String, dynamic>, AppException>> getEntity(
    String url,
    String id, {
    String key = 'id',
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final storedData = await getList(url);
      return storedData.fold((data) {
        for (final element in data) {
          if (element[key] == id) {
            return Left(element);
          }
        }
        return Right(GeneralException(message: 'no data found'));
      }, (error) => Right(error));
    } catch (e) {
      return Right(GeneralException(message: 'unknown error'));
    }
  }

  @override
  Future<Either<Map<String, dynamic>, AppException>> post(
    String url,
    dynamic data, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
  }) async {
    try {
      const key = 'id';
      final storedData = await getList(url);
      final list = storedData.fold(
        (existing) => existing,
        (error) => <Map<String, dynamic>>[],
      );
      final entity = data is Map
          ? Map<String, dynamic>.from(data)
          : <String, dynamic>{'value': data};
      entity[key] ??= list.length + 1;
      list.add(entity);
      await _sharedPreferences.setString(url, jsonEncode(list));
      return Left(entity);
    } catch (e) {
      return Right(GeneralException(message: 'unknown error'));
    }
  }

  @override
  Future<Either<Map<String, dynamic>, AppException>> put(
    String url,
    String id,
    dynamic data, {
    String key = 'id',
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final storedData = await getList(url);
      final list = storedData.fold<List<Map<String, dynamic>>?>(
        (existing) => existing,
        (error) => null,
      );
      if (list == null) {
        return Right(GeneralException(message: 'no data found'));
      }
      final index = list.indexWhere((element) => element[key] == id);
      if (index == -1) {
        return Right(GeneralException(message: 'no data found'));
      }
      final entity = Map<String, dynamic>.from(list[index]);
      if (data is Map) {
        entity.addAll(Map<String, dynamic>.from(data));
      }
      list[index] = entity;
      await _sharedPreferences.setString(url, jsonEncode(list));
      return Left(entity);
    } catch (e) {
      return Right(GeneralException(message: 'unknown error'));
    }
  }

  @override
  Future<Either<bool, AppException>> delete(
    String url,
    String id, {
    String key = 'id',
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final storedData = await getList(url);
      final list = storedData.fold<List<Map<String, dynamic>>?>(
        (existing) => existing,
        (error) => null,
      );
      if (list == null) {
        return const Left(false);
      }
      list.removeWhere((element) => element[key] == id);
      await _sharedPreferences.setString(url, jsonEncode(list));
      return const Left(true);
    } catch (e) {
      return Right(GeneralException(message: 'unknown error'));
    }
  }
}
