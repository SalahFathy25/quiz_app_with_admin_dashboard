import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:quiz_app/core/theme/theme.dart';

import '../../model/quiz.dart';

class QuizResultScreen extends StatefulWidget {
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
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(10),
            blurRadius: 10.r,
            spreadRadius: 2.r,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32.sp),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.darkTextSecondaryColor,
            ),
          ),
        ],
      ),
    ).animate().scale(
      duration: Duration(milliseconds: 400),
      delay: Duration(milliseconds: 300),
    );
  }

  Widget _buildAnswerRow(String label, String answer, Color answerColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppTheme.darkTextSecondaryColor,
          ),
        ),
        SizedBox(height: 4),
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

  IconData _getPerformanceIcon(double score) {
    if (score >= 0.9) return Icons.emoji_events;
    if (score >= 0.8) return Icons.star;
    if (score >= 0.6) return Icons.thumb_up;
    if (score >= 0.4) return Icons.trending_up;
    return Icons.refresh;
  }

  String _getPerformanceMessage(double score) {
    if (score >= 0.9) return 'outstanding'.tr();
    if (score >= 0.8) return 'great_job'.tr();
    if (score >= 0.6) return 'good_effort'.tr();
    if (score >= 0.4) return 'keep_practicing'.tr();
    return 'try_again'.tr();
  }

  Color _getScoreColor(double score) {
    if (score >= 0.8) return Colors.green;
    if (score >= 0.5) return Colors.orange;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    final score = widget.correctAnswers / widget.totalQuestions;
    final scorePercentage = (score * 100).round();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withAlpha(80),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        ),
                        Text(
                          'Quiz Result',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 40),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20.r),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(10),
                          shape: BoxShape.circle,
                        ),
                        child: CircularPercentIndicator(
                          radius: 100.r,
                          lineWidth: 15.w,
                          animation: true,
                          animationDuration: 1500,
                          percent: score,
                          center: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$scorePercentage%',
                                style: TextStyle(
                                  fontSize: 40.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${((widget.correctAnswers / widget.totalQuestions) * 100).toInt()}',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  color: Colors.white.withAlpha(90),
                                ),
                              ),
                            ],
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Colors.white,
                          backgroundColor: Colors.white.withAlpha(20),
                        ),
                      ),
                    ],
                  ).animate().scale(
                    delay: Duration(milliseconds: 800),
                    curve: Curves.elasticOut,
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.only(bottom: 30.h),
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(10),
                          blurRadius: 10.r,
                          offset: Offset(0, 4.h),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getPerformanceIcon(score),
                          color: _getScoreColor(score),
                          size: 28,
                        ),
                        SizedBox(width: 8),
                        Text(
                          _getPerformanceMessage(score),
                          style: TextStyle(
                            color: _getScoreColor(score),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ).animate().slideY(
                    begin: 0.3,
                    duration: Duration(milliseconds: 500),
                    delay: Duration(milliseconds: 200),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'correct'.tr(),
                      widget.correctAnswers.toString(),
                      Icons.check_circle,
                      Colors.green,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _buildStatCard(
                      'incorrect'.tr(),
                      (widget.totalQuestions - widget.correctAnswers)
                          .toString(),
                      Icons.cancel,
                      Colors.redAccent,
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
                  SizedBox(height: 16),
                  ...widget.quiz.questions.asMap().entries.map((entry) {
                    final questionIndex = entry.key;
                    final question = entry.value;
                    final selectedAnswer =
                        widget.selectedAnswers[questionIndex];
                    final isCorrect =
                        selectedAnswer != null &&
                        selectedAnswer == question.correctOptionIndex;

                    return Container(
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withAlpha(10),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Theme(
                        data: Theme.of(
                          context,
                        ).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          leading: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isCorrect
                                  ? Colors.green.withAlpha(10)
                                  : Colors.redAccent.withAlpha(10),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isCorrect
                                  ? Icons.check_circle_outline
                                  : Icons.close,
                              color: isCorrect
                                  ? Colors.green
                                  : Colors.redAccent,
                              size: 24,
                            ),
                          ),
                          title: Text(
                            '${"question".tr()} ${questionIndex + 1}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.lightTextPrimaryColor,
                            ),
                          ),
                          subtitle: Text(
                            question.text,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.lightTextSecondaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(
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
                                  _buildAnswerRow(
                                    'your_answer'.tr(),
                                    selectedAnswer != null
                                        ? question.options[selectedAnswer]
                                        : 'not_answered'.tr(),
                                    isCorrect ? Colors.green : Colors.redAccent,
                                  ),
                                  SizedBox(height: 12.h),
                                  _buildAnswerRow(
                                    'correct_answer'.tr(),
                                    question.options[question
                                        .correctOptionIndex],
                                    Colors.green,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().slideX(
                      begin: 0.3,
                      duration: Duration(milliseconds: 300),
                      delay: Duration(milliseconds: 100 * questionIndex),
                    );
                  }).toList(),
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
