import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app/core/theme/theme.dart';

class AnswerReviewRow extends StatelessWidget {
  final String label;
  final String answer;
  final Color answerColor;

  const AnswerReviewRow({
    super.key,
    required this.label,
    required this.answer,
    required this.answerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: AppTheme.darkTextSecondaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: answerColor.withAlpha(10),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            answer,
            style: TextStyle(fontWeight: FontWeight.w500, color: answerColor),
          ),
        ),
      ],
    );
  }
}
