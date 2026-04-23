import 'package:flutter/material.dart';
import '../../colors/app_colors.dart';

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
      width:  double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryButton,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 24,
                width:  24,
                child: CircularProgressIndicator(color: Colors.black, strokeWidth: 3),
              )
            : Text(
                text,
                style: const TextStyle(
                  color:      Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize:   18,
                ),
              ),
      ),
    );
  }
}