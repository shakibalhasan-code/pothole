class ApiEndpoints {
  ///MainUrl
  ///  static String baseUrl = 'http://192.168.10.99:5006/api/v1';

  static String baseUrl = 'http://31.97.33.65:5006/api/v1';

  static String authPath = '$baseUrl/auth';

  static String login = '$authPath/login';
  static String signUp = '$baseUrl/user';
  static String getMe = '$baseUrl/user/getme';
  static String updateProfile = '$baseUrl/user';
  static String getMyReports = '$baseUrl/pothole/my-reports';

  static String createPothole = '$baseUrl/pothole';

  static String verifyEmail = '$authPath/verify-email';
  static String forgotPassword = '$authPath/forgot-password';
  static String resetPassword = '$authPath/reset-password';
  static String changePassword = '$authPath/change-password';
  static String resendOtp = '$authPath/resend-otp';

  static String pothole = '$baseUrl/pothole';
  static String nearby = '$baseUrl/nearby';

  static String verifyPothole =
      '$baseUrl/pothole-verification/create-pothole-verification';

  static String deleteAccount = '$baseUrl/user/delete';
}
