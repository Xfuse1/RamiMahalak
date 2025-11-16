import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  AuthService._();

  static final SupabaseClient _client = Supabase.instance.client;

  /// Login with either email or phone + password.
  ///
  /// If [identifier] contains '@', it is treated as an email,
  /// otherwise as a phone number. When a phone is provided, we look up
  /// the corresponding email from public.users then login with email+password.
  static Future<AuthResponse> signInWithIdentifier({
    required String identifier,
    required String password,
  }) async {
    final trimmedIdentifier = identifier.trim();
    final trimmedPassword = password.trim();

    if (trimmedIdentifier.isEmpty || trimmedPassword.isEmpty) {
      throw const AuthException('يجب إدخال البريد/الهاتف وكلمة المرور');
    }

    final bool isEmail = trimmedIdentifier.contains('@');

    String emailForLogin;

    if (isEmail) {
      emailForLogin = trimmedIdentifier;
    } else {
      // Treat identifier as phone: lookup corresponding email from public.users
      final response = await _client
          .from('users')
          .select('email')
          .eq('phone', trimmedIdentifier)
          .maybeSingle();


      final data = response;

      if (data == null) {
        throw const AuthException('لا يوجد حساب بهذا الرقم');
      }
      final foundEmail = data['email'] as String?;

      if (foundEmail == null || foundEmail.isEmpty) {
        throw const AuthException('لا يوجد حساب بهذا الرقم');
      }
      emailForLogin = foundEmail;
    }

    return _client.auth.signInWithPassword(
      email: emailForLogin,
      password: trimmedPassword,
    );
  }
}
