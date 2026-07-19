import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../controllers/login_controller.dart';

/// ===========================================================
/// Login Screen
/// -----------------------------------------------------------
/// Kullanıcının sisteme giriş yaptığı ekran.
/// Modern, minimalist dalga efektli ve lacivert temalı UI.
/// ===========================================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginController _controller;
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _controller = LoginController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await _controller.login();

    if (!mounted) return;

    if (!success && _controller.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_controller.errorMessage!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ========================================================
          // TOP WAVE BANNER (Ekranın sıfır noktasından başlar)
          // ========================================================
          ClipPath(
            clipper: ModernWaveClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.42,
              width: double.infinity,
              color: AppColors.primary, // Derin Lacivert
              child: Stack(
                children: [
                  // Sol Üst Arka Plan Sıvı Lekesi
                  Positioned(
                    top: -40,
                    right: -20,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryLight.withOpacity(0.4),
                      ),
                    ),
                  ),
                  // Orta Sağ Arka Plan Sıvı Lekesi
                  Positioned(
                    top: 100,
                    left: -50,
                    child: Container(
                      width: 220,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: AppColors.primaryLight.withOpacity(0.3),
                      ),
                    ),
                  ),
                  // Küçük Alt Leke
                  Positioned(
                    bottom: 60,
                    right: 80,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryLight.withOpacity(0.5),
                      ),
                    ),
                  ),
                  // Geri Butonu
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 10,
                    left: 10,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.textOnPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                  // Sola Dayalı Başlık
                  Positioned(
                    bottom: 80,
                    left: 28,
                    child: Text(
                      "LogIn",
                      style: AppTextStyles.headlineLarge.copyWith(
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ========================================================
          // FORM AREA
          // ========================================================
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 10.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // 1. NAME FIELD (Gölge ve Derinlik Eklendi)
                   /* Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CustomTextField(
                        controller: _controller.nameController,
                        label: "Name",
                        hint: "John Doe",
                        prefixIcon: Icons.person_outline_rounded,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Name is required";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),*/

                    // 2. EMAIL FIELD (Gölge ve Derinlik Eklendi)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CustomTextField(
                        controller: _controller.emailController,
                        label: "Email",
                        hint: "example@email.com",
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Email is required";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // 3. PASSWORD FIELD (Gölge ve Derinlik Eklendi)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CustomTextField(
                        controller: _controller.passwordController,
                        label: "Password",
                        hint: "••••••••",
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.iconPrimary,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }
                          if (value.length < 6) {
                            return "Minimum 6 characters";
                          }
                          return null;
                        },
                      ),
                    ),
                    
                    const SizedBox(height: AppSpacing.xl),

                    // SIGN UP BUTTON (Marka Renginde Gölgeli)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: PrimaryButton(
                        text: "Log in",
                        onPressed: _login,
                        isLoading: _controller.isLoading,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // OR DIVIDER (Çizgili minimalist "or" alanı)
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: AppColors.border,
                            thickness: 1.2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "or",
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            color: AppColors.border,
                            thickness: 1.2,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // LOG IN BUTTON (Siliklikten kurtulan, net çerçeveli ve zemin gölgeli buton)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 52),
                          backgroundColor: Colors.white,
                          side: const BorderSide(
                            color: AppColors.textSecondary,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Create Account",
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

/// ===========================================================
/// CUSTOM CLIPPER FOR ORGANIC WAVE
/// -----------------------------------------------------------
/// Üst kısımdaki organik, kıvrımlı dalga efektini çizen sınıf.
/// ===========================================================
class ModernWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 60);

    // Birinci kıvrım dalgası
    var firstControlPoint = Offset(size.width * 0.35, size.height);
    var firstEndPoint = Offset(size.width * 0.65, size.height - 40);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    // İkinci kıvrım dalgası
    var secondControlPoint = Offset(size.width * 0.85, size.height - 70);
    var secondEndPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}