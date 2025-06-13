import 'package:flutter/material.dart';
import 'package:urbanmatch/utils/colors.dart';

class EmptyTabScreen extends StatelessWidget {
  const EmptyTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Empty Page',
        style: TextStyle(
          color: AppColors.creme,
          fontSize: 20,
        ),
      ),
    );
  }
} 