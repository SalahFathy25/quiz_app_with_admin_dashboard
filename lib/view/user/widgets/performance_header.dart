import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PerformanceHeader extends StatelessWidget {
  final double score;
  final int scorePercentage;
  final int correctAnswers;
  final int totalQuestions;

  const PerformanceHeader({
    super.key,
    required this.score,
    required this.scorePercentage,
    required this.correctAnswers,
    required this.totalQuestions,
  });

  IconData _getPerformanceIcon() {
    if (score >= 0.9) return Icons.emoji_events;
    if (score >= 0.8) return Icons.star;
    if (score >= 0.6) return Icons.thumb_up;
    if (score >= 0.4) return Icons.trending_up;
    return Icons.refresh;
  }

  String _getPerformanceMessage() {
    if (score >= 0.9) return 'outstanding'.tr();
    if (score >= 0.8) return 'great_job'.tr();
    if (score >= 0.6) return 'good_effort'.tr();
    if (score >= 0.4) return 'keep_practicing'.tr();
    return 'try_again'.tr();
  }

  Color _getScoreColor() {
    if (score >= 0.8) return Colors.green;
    if (score >= 0.5) return Colors.orange;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
                const Text(
                  'Quiz Result',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),
          const SizedBox(height: 20),
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
                        '${((correctAnswers / totalQuestions) * 100).toInt()}',
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
            delay: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
          ),
          const SizedBox(height: 20),
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
                  _getPerformanceIcon(),
                  color: _getScoreColor(),
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  _getPerformanceMessage(),
                  style: TextStyle(
                    color: _getScoreColor(),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ).animate().slideY(
            begin: 0.3,
            duration: const Duration(milliseconds: 500),
            delay: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
