import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/data_source.dart/data_source_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource implements DataSourceInterface {
  LocalDataSource(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  @override
  Future<Either<List<Map<String, dynamic>>, String>> getList(
    String url, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = _sharedPreferences.getString(url);
      if (response == null) {
        return const Right('no data found');
      }
      final decoded = jsonDecode(response);
      if (decoded is! List) {
        return const Right('no data found');
      }
      final data = decoded
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
      return Left(data);
    } catch (e) {
      return const Right('unknown error');
    }
  }

  @override
  Future<Either<Map<String, dynamic>, String>> getEntity(
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
        return const Right('no data found');
      }, (error) => Right(error));
    } catch (e) {
      return const Right('unknown error');
    }
  }

  @override
  Future<Either<Map<String, dynamic>, String>> post(
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
      return const Right('unknown error');
    }
  }

  @override
  Future<Either<Map<String, dynamic>, String>> put(
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
        return const Right('no data found');
      }
      final index = list.indexWhere((element) => element[key] == id);
      if (index == -1) {
        return const Right('no data found');
      }
      final entity = Map<String, dynamic>.from(list[index]);
      if (data is Map) {
        entity.addAll(Map<String, dynamic>.from(data));
      }
      list[index] = entity;
      await _sharedPreferences.setString(url, jsonEncode(list));
      return Left(entity);
    } catch (e) {
      return const Right('unknown error');
    }
  }

  @override
  Future<Either<bool, String>> delete(
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
      return const Right('unknown error');
    }
  }
}
