class ApiEndpoints {
  static String baseUrl = 'http://127.0.0.1:5006/api/v1';
  static String authPath = 'auth';
  static String login = '$baseUrl/login';
  static String signUp = '$baseUrl/user';

  static String verifyEmail = '$baseUrl/verify-email';
  static String forgotPassword = '$baseUrl/forgot-password';
  static String resetPassword = '$baseUrl/reset-password';
  static String changePassword = '$baseUrl/change-password';
  static String resendOtp = '$baseUrl/resend-otp';

  static String pothole = '$baseUrl/pothole';
  static String nearby = '$baseUrl/nearby';
}
