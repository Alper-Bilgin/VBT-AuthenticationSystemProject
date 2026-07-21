import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';

import '../controllers/register_controller.dart';

/// ===========================================================
/// Register Screen
/// -----------------------------------------------------------
/// Yeni kullanıcı kayıt ekranı.
///
/// Sorumlulukları:
/// • Form yönetimi
/// • Kullanıcı doğrulamaları
/// • Register işlemini başlatma
/// • Login ekranına yönlendirme
///
/// İş mantığı RegisterController içerisinde tutulur.
/// ===========================================================
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final RegisterController _controller;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _controller = RegisterController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// ===========================================================
  /// Register
  /// ===========================================================
  Future<void> _register() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await _controller.register();

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account created successfully."),
        ),
      );

      context.pop();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _controller.errorMessage ?? "Something went wrong.",
        ),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Column(
        children: [

          // =====================================================
          // TOP WAVE HEADER
          // =====================================================
          ClipPath(
            clipper: ModernWaveClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height * .42,
              width: double.infinity,
              color: AppColors.primary,

              child: Stack(
                children: [

                  /// Decorative Circle
                  Positioned(
                    top: -40,
                    right: -20,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryLight.withOpacity(.35),
                      ),
                    ),
                  ),

                  /// Decorative Shape
                  Positioned(
                    top: 100,
                    left: -50,
                    child: Container(
                      width: 220,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: AppColors.primaryLight.withOpacity(.25),
                      ),
                    ),
                  ),

                  /// Decorative Dot
                  Positioned(
                    bottom: 60,
                    right: 80,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryLight.withOpacity(.45),
                      ),
                    ),
                  ),

                  /// Back Button
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 10,
                    left: 10,
                    child: IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ),

                  /// Screen Title
                  Positioned(
                    bottom: 80,
                    left: 28,
                    child: Text(
                      "Create\nAccount",
                      style: AppTextStyles.headlineLarge.copyWith(
                        color: AppColors.textOnPrimary,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // =====================================================
          // FORM
          // =====================================================
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 12,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                                        // =====================================================
                    // FIRST NAME
                    // =====================================================
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CustomTextField(
                        controller: _controller.firstNameController,
                        label: "First Name",
                        hint: "John",
                        prefixIcon: Icons.person_outline_rounded,
                        textInputAction: TextInputAction.next,
                        validator: _controller.validateFirstName,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // =====================================================
                    // LAST NAME
                    // =====================================================
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CustomTextField(
                        controller: _controller.lastNameController,
                        label: "Last Name",
                        hint: "Doe",
                        prefixIcon: Icons.badge_outlined,
                        textInputAction: TextInputAction.next,
                        validator: _controller.validateLastName,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // =====================================================
                    // EMAIL
                    // =====================================================
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.03),
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
                        textInputAction: TextInputAction.next,
                        validator: _controller.validateEmail,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // =====================================================
                    // PASSWORD
                    // =====================================================
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.03),
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
                        textInputAction: TextInputAction.next,
                        validator: _controller.validatePassword,
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
                      ),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // =====================================================
                    // CONFIRM PASSWORD
                    // =====================================================
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CustomTextField(
                        controller:
                            _controller.confirmPasswordController,
                        label: "Confirm Password",
                        hint: "•••••••• (Min. 8 characters)",
                        prefixIcon: Icons.lock_reset_outlined,
                        obscureText: _obscureConfirmPassword,
                        textInputAction: TextInputAction.done,
                        validator:
                            _controller.validateConfirmPassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.iconPrimary,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                     // =====================================================
                    // CREATE ACCOUNT BUTTON
                    // =====================================================
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(.25),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: PrimaryButton(
                        text: "Create Account",
                        onPressed: _register,
                        isLoading: _controller.isLoading,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // =====================================================
                    // DIVIDER
                    // =====================================================
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: AppColors.border,
                            thickness: 1.2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
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

                    // =====================================================
                    // LOGIN BUTTON
                    // =====================================================
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.04),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: OutlinedButton(
                        onPressed: () => context.pop(),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(
                            double.infinity,
                            52,
                          ),
                          backgroundColor: Colors.white,
                          side: const BorderSide(
                            color: AppColors.textSecondary,
                            width: 1.4,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Log In",
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ===========================================================
/// Modern Wave Clipper
/// -----------------------------------------------------------
/// Login ekranı ile aynı dalga efektini oluşturur.
/// İki ekranda da aynı görünüm korunur.
/// ===========================================================
class ModernWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(
      0,
      size.height - 60,
    );

    final firstControlPoint = Offset(
      size.width * .35,
      size.height,
    );

    final firstEndPoint = Offset(
      size.width * .65,
      size.height - 40,
    );

    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    final secondControlPoint = Offset(
      size.width * .85,
      size.height - 70,
    );

    final secondEndPoint = Offset(
      size.width,
      size.height - 30,
    );

    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(
      size.width,
      0,
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(
    CustomClipper<Path> oldClipper,
  ) {
    return false;
  }
}