import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_colors.dart';


/// ===========================================================
/// Custom Text Field
/// -----------------------------------------------------------
/// Uygulama genelinde kullanılan input componentidir.
/// Login, Register ve diğer formlarda tekrar kullanılabilir.
/// ===========================================================

class CustomTextField extends StatelessWidget {


  final TextEditingController controller;

  final FocusNode? focusNode;

  final String label;

  final String hint;

  final IconData prefixIcon;

  final TextInputType keyboardType;

  final bool obscureText;

  final Widget? suffixIcon;

  final TextInputAction textInputAction;

  final String? Function(String?)? validator;

  final void Function(String)? onSubmitted;



  const CustomTextField({

    super.key,

    required this.controller,

    required this.label,

    required this.hint,

    required this.prefixIcon,

    this.focusNode,

    this.keyboardType = TextInputType.text,

    this.obscureText = false,

    this.suffixIcon,

    this.textInputAction = TextInputAction.next,

    this.validator,

    this.onSubmitted,

  });



  @override
  Widget build(BuildContext context) {

    return TextFormField(

      controller: controller,

      focusNode: focusNode,

      keyboardType: keyboardType,

      obscureText: obscureText,

      textInputAction: textInputAction,

      validator: validator,

      onFieldSubmitted: onSubmitted,


      style: AppTextStyles.bodyLarge,



      decoration: InputDecoration(


        labelText: label,

        hintText: hint,


        prefixIcon: Icon(

          prefixIcon,

          color: AppColors.textSecondary,

        ),


        suffixIcon: suffixIcon,



        labelStyle: AppTextStyles.bodyMedium,


        hintStyle: AppTextStyles.bodyMedium,



        border: OutlineInputBorder(

          borderRadius: AppRadius.radiusMd,

          borderSide: BorderSide.none,

        ),



        enabledBorder: OutlineInputBorder(

          borderRadius: AppRadius.radiusMd,

          borderSide: BorderSide(

            color: AppColors.border,

          ),

        ),



        focusedBorder: OutlineInputBorder(

          borderRadius: AppRadius.radiusMd,

          borderSide: BorderSide(

            color: AppColors.primary,

            width: 1.5,

          ),

        ),

      ),

    );

  }

}