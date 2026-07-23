import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/auth_api_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';


class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});


  Future<void> _logout(BuildContext context) async {

    await AuthApiService.logout();

    if (context.mounted) {
      context.go('/');
    }
  }


  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;


    return Scaffold(

      backgroundColor: AppColors.background,


      body: Stack(

        children: [


          // ===============================
          // HEADER AREA
          // ===============================

          ClipPath(

            clipper: HomeWaveClipper(),


            child: Container(

              height: size.height * 0.36,


              decoration: const BoxDecoration(

                color: AppColors.primary,

              ),


              child: Stack(

                children: [


                  Positioned(

                    top: -60,

                    right: -50,

                    child: _circle(
                      170,
                      Colors.white.withValues(
                        alpha: 0.05,
                      ),
                    ),

                  ),



                  Positioned(

                    top: 90,

                    left: -70,

                    child: _circle(
                      150,
                      Colors.white.withValues(
                        alpha: 0.04,
                      ),
                    ),

                  ),



                  Positioned(

                    top: 45,

                    right: 50,

                    child: _circle(
                      35,
                      Colors.white.withValues(
                        alpha: 0.08,
                      ),
                    ),

                  ),



                  SafeArea(

                    child: Padding(

                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),


                      child: Row(

                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,


                        children: [


                          Text(

                            "Authentication",

                            style: AppTextStyles.titleLarge.copyWith(
                              color: Colors.white,
                            ),

                          ),



                          IconButton(

                            onPressed: () =>
                                _logout(context),


                            icon: const Icon(

                              Icons.logout_rounded,

                              color: Colors.white,

                            ),

                          ),

                        ],

                      ),

                    ),

                  ),




                  Positioned(

                    left: AppSpacing.lg,

                    bottom: 65,


                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment.start,


                      children: [


                        Text(

                          "Welcome back 👋",

                          style: AppTextStyles.headlineLarge.copyWith(

                            color: Colors.white,

                          ),

                        ),



                        const SizedBox(
                          height: AppSpacing.sm,
                        ),



                        Text(

                          "Your account is active",

                          style: AppTextStyles.bodyLarge.copyWith(

                            color: Colors.white70,

                          ),

                        ),


                      ],

                    ),

                  ),


                ],

              ),

            ),

          ),





          // ===============================
          // MAIN CARD
          // ===============================

          Positioned(

            top: size.height * 0.30,

            left: AppSpacing.lg,

            right: AppSpacing.lg,


            child: Container(

              padding: const EdgeInsets.all(
                AppSpacing.lg,
              ),


              decoration: BoxDecoration(

                color: Colors.white,


                borderRadius: BorderRadius.circular(
                  28,
                ),


                boxShadow: [


                  BoxShadow(

                    color: Colors.black.withValues(
                      alpha: 0.08,
                    ),

                    blurRadius: 25,

                    offset: const Offset(
                      0,
                      12,
                    ),

                  ),

                ],

              ),



              child: Column(

                mainAxisSize: MainAxisSize.min,


                children: [


                  Container(

                    height: 78,

                    width: 78,


                    decoration: BoxDecoration(

                      color: AppColors.primary.withValues(
                        alpha: 0.12,
                      ),


                      shape: BoxShape.circle,

                    ),



                    child: const Icon(

                      Icons.verified_user_rounded,

                      size: 42,

                      color: AppColors.primary,

                    ),

                  ),




                  const SizedBox(

                    height: AppSpacing.md,

                  ),




                  Text(

                    "Authenticated",

                    style: AppTextStyles.headlineMedium,

                  ),




                  const SizedBox(

                    height: AppSpacing.sm,

                  ),




                  Text(

                    "You are securely logged in.",

                    textAlign: TextAlign.center,


                    style: AppTextStyles.bodyLarge,

                  ),




                  const SizedBox(

                    height: AppSpacing.lg,

                  ),




                  Container(

                    padding: const EdgeInsets.all(
                      AppSpacing.md,
                    ),


                    decoration: BoxDecoration(

                      color: AppColors.background,


                      borderRadius:
                          BorderRadius.circular(
                            16,
                          ),

                    ),



                    child: Row(

                      children: [


                        const Icon(

                          Icons.check_circle_rounded,

                          color: Colors.green,

                        ),



                        const SizedBox(

                          width: AppSpacing.sm,

                        ),



                        Text(

                          "Secure session active",

                          style: AppTextStyles.bodyLarge,

                        ),

                      ],

                    ),

                  ),




                  const SizedBox(

                    height: AppSpacing.lg,

                  ),




                  SizedBox(

                    width: double.infinity,


                    child: ElevatedButton.icon(

                      onPressed: () =>
                          _logout(context),


                      icon: const Icon(

                        Icons.logout_rounded,

                      ),


                      label: const Text(

                        "Logout",

                      ),

                    ),

                  ),


                ],

              ),

            ),

          ),


        ],

      ),

    );

  }




  static Widget _circle(
    double size,
    Color color,
  ) {

    return Container(

      height: size,

      width: size,


      decoration: BoxDecoration(

        color: color,

        shape: BoxShape.circle,

      ),

    );

  }

}





class HomeWaveClipper extends CustomClipper<Path> {


  @override
  Path getClip(Size size) {


    final path = Path();


    path.lineTo(
      0,
      size.height - 35,
    );


    path.quadraticBezierTo(

      size.width * 0.35,

      size.height + 20,

      size.width * 0.65,

      size.height - 20,

    );


    path.quadraticBezierTo(

      size.width * 0.85,

      size.height - 55,

      size.width,

      size.height - 25,

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
  ) => false;

}