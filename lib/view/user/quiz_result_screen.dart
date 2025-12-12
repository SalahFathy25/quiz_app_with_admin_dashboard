import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app/core/theme/theme.dart';
import 'package:quiz_app/model/quiz.dart';
import 'package:quiz_app/view/user/widgets/performance_header.dart';
import 'package:quiz_app/view/user/widgets/question_review_card.dart';
import 'package:quiz_app/view/user/widgets/result_stat_card.dart';

class QuizResultScreen extends StatelessWidget {
  final Quiz quiz;
  final int totalQuestions;
  final int correctAnswers;
  final Map<int, int?> selectedAnswers;

  const QuizResultScreen({
    super.key,
    required this.quiz,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.selectedAnswers,
  });

  @override
  Widget build(BuildContext context) {
    final score = correctAnswers / totalQuestions;
    final scorePercentage = (score * 100).round();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            PerformanceHeader(
              score: score,
              scorePercentage: scorePercentage,
              correctAnswers: correctAnswers,
              totalQuestions: totalQuestions,
            ),
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                children: [
                  Expanded(
                    child: ResultStatCard(
                      title: 'correct'.tr(),
                      value: correctAnswers.toString(),
                      icon: Icons.check_circle,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ResultStatCard(
                      title: 'incorrect'.tr(),
                      value: (totalQuestions - correctAnswers).toString(),
                      icon: Icons.cancel,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.analytics,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'detailed_analysis'.tr(),
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkTextSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...quiz.questions.asMap().entries.map((entry) {
                    final questionIndex = entry.key;
                    final question = entry.value;
                    final selectedAnswer = selectedAnswers[questionIndex];
                    final isCorrect = selectedAnswer != null &&
                        selectedAnswer == question.correctOptionIndex;

                    return QuestionReviewCard(
                      questionIndex: questionIndex,
                      question: question,
                      selectedAnswer: selectedAnswer,
                      isCorrect: isCorrect,
                    );
                  }),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(24.r),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.refresh, size: 24.sp, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      label: Text(
                        'try_again'.tr(),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
