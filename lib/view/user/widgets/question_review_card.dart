import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app/core/theme/theme.dart';
import 'package:quiz_app/model/question.dart';
import 'package:quiz_app/view/user/widgets/answer_review_row.dart';

class QuestionReviewCard extends StatelessWidget {
  final int questionIndex;
  final Question question;
  final int? selectedAnswer;
  final bool isCorrect;

  const QuestionReviewCard({
    super.key,
    required this.questionIndex,
    required this.question,
    required this.selectedAnswer,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(10),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isCorrect
                  ? Colors.green.withAlpha(10)
                  : Colors.redAccent.withAlpha(10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCorrect ? Icons.check_circle_outline : Icons.close,
              color: isCorrect ? Colors.green : Colors.redAccent,
              size: 24,
            ),
          ),
          title: Text(
            '${"question".tr()} ${questionIndex + 1}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTextPrimaryColor,
            ),
          ),
          subtitle: Text(
            question.text,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.lightTextSecondaryColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 16,
                right: 5,
                left: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.text,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: AppTheme.lightTextPrimaryColor,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 20.h),
                  AnswerReviewRow(
                    label: 'your_answer'.tr(),
                    answer: selectedAnswer != null
                        ? question.options[selectedAnswer!]
                        : 'not_answered'.tr(),
                    answerColor: isCorrect ? Colors.green : Colors.redAccent,
                  ),
                  SizedBox(height: 12.h),
                  AnswerReviewRow(
                    label: 'correct_answer'.tr(),
                    answer: question.options[question.correctOptionIndex],
                    answerColor: Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().slideX(
      begin: 0.3,
      duration: const Duration(milliseconds: 300),
      delay: Duration(milliseconds: 100 * questionIndex),
    );
  }
}
