abstract class AppException implements Exception {
  final String message;
  AppException({required this.message});
}


class GeneralException extends AppException {
  GeneralException({required super.message});
}