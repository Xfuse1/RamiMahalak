import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mahlak_nem/core/constants/app_colors.dart';

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

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _governorateController = TextEditingController();
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _governorateController.dispose();
    _cityController.dispose();
    _streetController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final phone = _phoneController.text.trim();
      final governorate = _governorateController.text.trim();
      final city = _cityController.text.trim();
      final street = _streetController.text.trim();

      // Normalize Egyptian phone number to +20xxxxxxxxxx before sending to Supabase.
      final formattedPhone = formatEgyptPhone(phone);

      await Supabase.instance.client.auth.signUp(
        // Supabase Dart allows either email OR phone here, not both.
        email: email,
        password: password,
        data: {
          // Store phone in user metadata in a normalized format.
          'phone': formattedPhone,
          'governorate': governorate,
          'city': city,
          'street': street,
          'user_type': 'customer',
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'تم إرسال بريد إلكتروني للتأكيد. يرجى التحقق من بريدك الوارد.'),
          ),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في المصادقة: ${e.message}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ غير متوقع: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Container(
                width: 400,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 36),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'إنشاء حساب',
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Color(0xFF1F2937),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'أنشئ حسابك الآن للبدء',
                        style: GoogleFonts.cairo(
                          fontSize: 15,
                          color: Color(0xFF6B7280),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'البريد الإلكتروني',
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            color: Color(0xFF1F2937),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'أدخل بريدك الإلكتروني',
                          hintStyle: GoogleFonts.cairo(
                            color: Color(0xFF9CA3AF),
                            fontSize: 13,
                          ),
                          filled: true,
                          fillColor: Color(0xFFF5F7FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                        style: GoogleFonts.cairo(fontSize: 14),
                        textAlign: TextAlign.right,
                        keyboardType: TextInputType.emailAddress,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'هذا الحقل مطلوب'),
                          EmailValidator(errorText: 'أدخل بريدًا إلكترونيًا صحيحًا'),
                        ]),
                      ),
                      SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'رقم الهاتف',
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            color: Color(0xFF1F2937),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          hintText: 'أدخل رقم هاتفك',
                          hintStyle: GoogleFonts.cairo(
                            color: Color(0xFF9CA3AF),
                            fontSize: 13,
                          ),
                          filled: true,
                          fillColor: Color(0xFFF5F7FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                        style: GoogleFonts.cairo(fontSize: 14),
                        textAlign: TextAlign.right,
                        keyboardType: TextInputType.phone,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'هذا الحقل مطلوب'),
                          MinLengthValidator(10, errorText: 'أدخل رقم هاتف صحيح'),
                        ]),
                      ),
                      SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'المحافظة',
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            color: Color(0xFF1F2937),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _governorateController,
                        decoration: InputDecoration(
                          hintText: 'أدخل محافظتك',
                          hintStyle: GoogleFonts.cairo(
                            color: Color(0xFF9CA3AF),
                            fontSize: 13,
                          ),
                          filled: true,
                          fillColor: Color(0xFFF5F7FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                        style: GoogleFonts.cairo(fontSize: 14),
                        textAlign: TextAlign.right,
                        validator: RequiredValidator(errorText: 'هذا الحقل مطلوب'),
                      ),
                      SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'المدينة',
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            color: Color(0xFF1F2937),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _cityController,
                        decoration: InputDecoration(
                          hintText: 'أدخل مدينتك',
                          hintStyle: GoogleFonts.cairo(
                            color: Color(0xFF9CA3AF),
                            fontSize: 13,
                          ),
                          filled: true,
                          fillColor: Color(0xFFF5F7FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                        style: GoogleFonts.cairo(fontSize: 14),
                        textAlign: TextAlign.right,
                        validator: RequiredValidator(errorText: 'هذا الحقل مطلوب'),
                      ),
                      SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'الشارع',
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            color: Color(0xFF1F2937),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _streetController,
                        decoration: InputDecoration(
                          hintText: 'أدخل عنوان الشارع',
                          hintStyle: GoogleFonts.cairo(
                            color: Color(0xFF9CA3AF),
                            fontSize: 13,
                          ),
                          filled: true,
                          fillColor: Color(0xFFF5F7FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                        style: GoogleFonts.cairo(fontSize: 14),
                        textAlign: TextAlign.right,
                        validator: RequiredValidator(errorText: 'هذا الحقل مطلوب'),
                      ),
                      SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'كلمة المرور',
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            color: Color(0xFF1F2937),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'أدخل كلمة المرور',
                          hintStyle: GoogleFonts.cairo(
                            color: Color(0xFF9CA3AF),
                            fontSize: 13,
                          ),
                          filled: true,
                          fillColor: Color(0xFFF5F7FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                        style: GoogleFonts.cairo(fontSize: 14),
                        textAlign: TextAlign.right,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'هذا الحقل مطلوب'),
                          MinLengthValidator(8, errorText: 'يجب أن تكون كلمة المرور 8 أحرف على الأقل'),
                        ]),
                      ),
                      SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'تأكيد كلمة المرور',
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            color: Color(0xFF1F2937),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'أعد إدخال كلمة المرور',
                          hintStyle: GoogleFonts.cairo(
                            color: Color(0xFF9CA3AF),
                            fontSize: 13,
                          ),
                          filled: true,
                          fillColor: Color(0xFFF5F7FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                        style: GoogleFonts.cairo(fontSize: 14),
                        textAlign: TextAlign.right,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'هذا الحقل مطلوب';
                          }
                          if (val != _passwordController.text) {
                            return 'كلمة المرور غير متطابقة';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _submit,
                          icon: Icon(Icons.person_add, size: 18),
                          label: Text('إنشاء حساب',
                              style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: GoogleFonts.cairo(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: 18),
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text('لديك حساب بالفعل؟ ',
                              style: GoogleFonts.cairo(fontSize: 13)),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Text('تسجيل الدخول',
                                style: GoogleFonts.cairo(
                                    color: Color(0xFF2563EB),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
