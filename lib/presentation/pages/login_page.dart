import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Helper to normalize Egyptian phone numbers to +20xxxxxxxxxx format.
String formatEgyptPhone(String input) {
  // Keep only digits.
  String digits = input.replaceAll(RegExp(r'\D'), '');

  if (digits.isEmpty) return '';

  // Remove leading country code or zero if present.
  if (digits.startsWith('20')) {
    digits = digits.substring(2);
  } else if (digits.startsWith('0')) {
    digits = digits.substring(1);
  }

  return '+20$digits';
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      _handleLogin();
    }
  }

  /// Resolve email for a given normalized phone using a backend helper (RPC).
  Future<String?> _getEmailForPhone(String formattedPhone) async {
    final supabase = Supabase.instance.client;
    final result = await supabase.rpc(
      'get_email_by_phone',
      params: {'p_phone': formattedPhone},
    );

    if (result is String && result.isNotEmpty) {
      return result;
    }

    if (result is Map && result['email'] is String) {
      return result['email'] as String;
    }

    return null;
  }

  /// Handle login using email or Egyptian phone number.
  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final identifier = _identifierController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;
      AuthResponse response;

      if (identifier.contains('@')) {
        // Login with email directly.
        response = await supabase.auth.signInWithPassword(
          email: identifier,
          password: password,
        );
      } else {
        // Login with Egyptian phone number:
        // 1) normalize to +20xxxxxxxxxx
        // 2) call backend helper to resolve the associated email
        final formattedPhone = formatEgyptPhone(identifier);
        final emailForPhone = await _getEmailForPhone(formattedPhone);

        if (emailForPhone == null) {
          throw const AuthException(
              'لا يوجد مستخدم مسجل بهذا الرقم، برجاء التحقق من الرقم');
        }

        response = await supabase.auth.signInWithPassword(
          email: emailForPhone,
          password: password,
        );
      }

      if (response.session != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تسجيل الدخول بنجاح')),
        );
        Navigator.pushReplacementNamed(context, '/home');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تعذر تسجيل الدخول، يرجى التحقق من البيانات والمحاولة مرة أخرى',
            ),
          ),
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Container(
                width: 400,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'تسجيل الدخول',
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: const Color(0xFF1F2937),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ادخل البريد الإلكتروني أو رقم الهاتف وكلمة المرور',
                        style: GoogleFonts.cairo(
                          fontSize: 15,
                          color: const Color(0xFF6B7280),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'البريد الإلكتروني أو رقم الهاتف',
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            color: const Color(0xFF1F2937),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _identifierController,
                        decoration: InputDecoration(
                          hintText:
                              'اكتب بريدك الإلكتروني أو رقم هاتف مصري مثل 01012345678',
                          hintStyle: GoogleFonts.cairo(
                            color: const Color(0xFF9CA3AF),
                            fontSize: 13,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF5F7FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        style: GoogleFonts.cairo(fontSize: 14),
                        textAlign: TextAlign.right,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'هذا الحقل مطلوب'),
                          MinLengthValidator(
                            3,
                            errorText:
                                'يجب إدخال بريد إلكتروني أو رقم هاتف صحيح',
                          ),
                        ]),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'كلمة المرور',
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            color: const Color(0xFF1F2937),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'اكتب كلمة المرور',
                          hintStyle: GoogleFonts.cairo(
                            color: const Color(0xFF9CA3AF),
                            fontSize: 13,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF5F7FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        style: GoogleFonts.cairo(fontSize: 14),
                        textAlign: TextAlign.right,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'هذا الحقل مطلوب'),
                          MinLengthValidator(
                            6,
                            errorText:
                                'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
                          ),
                        ]),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _submit,
                          icon: const Icon(Icons.arrow_forward, size: 18),
                          label: Text(
                            _isLoading
                                ? 'جاري تسجيل الدخول...'
                                : 'تسجيل الدخول',
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'لا تملك حسابًا؟ ',
                            style: GoogleFonts.cairo(fontSize: 13),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: Text(
                              'إنشاء حساب جديد',
                              style: GoogleFonts.cairo(
                                color: const Color(0xFF2563EB),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/forgot-password');
                        },
                        child: Text(
                          'نسيت كلمة المرور؟',
                          style: GoogleFonts.cairo(
                            color: const Color(0xFF2563EB),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
