import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';


/// ===========================================================
/// Primary Button
/// -----------------------------------------------------------
/// Uygulamanın ana aksiyon butonudur.
/// ===========================================================

class PrimaryButton extends StatelessWidget {


  final String text;

  final VoidCallback? onPressed;

  final bool isLoading;



  const PrimaryButton({

    super.key,

    required this.text,

    required this.onPressed,

    this.isLoading = false,

  });



  @override
  Widget build(BuildContext context) {


    return SizedBox(

      width: double.infinity,

      height: 56,


      child: ElevatedButton(


        onPressed: isLoading ? null : onPressed,



        style: ElevatedButton.styleFrom(


          shape: RoundedRectangleBorder(

            borderRadius: AppRadius.radiusLg,

          ),


        ),



        child: isLoading


            ? const SizedBox(

                width: 22,

                height: 22,

                child: CircularProgressIndicator(

                  strokeWidth: 2,

                  color: Colors.white,

                ),

              )


            : Text(

                text,

                style: AppTextStyles.labelLarge,

              ),

      ),

    );

  }

}