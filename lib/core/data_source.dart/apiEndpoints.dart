mixin ApiEndpoints {
  static const String baseUrl = 'https://api.example.com';
  static const String login = '$baseUrl/login';
  static const String register = '$baseUrl/register';
  static const String logout = '$baseUrl/logout';
  static const String getUser = '$baseUrl/user';
  static const String updateUser = '$baseUrl/user';
  static const String deleteUser = '$baseUrl/user';
}