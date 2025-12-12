import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app/logic/quiz/quiz_play_cubit.dart';
import 'package:quiz_app/model/quiz.dart';
import 'package:quiz_app/view/user/quiz_play_screen.dart';

class QuizListCard extends StatelessWidget {
  final Quiz quiz;
  final int index;

  const QuizListCard({
    super.key,
    required this.quiz,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
          margin: EdgeInsets.only(bottom: 16.h),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => QuizPlayCubit(quiz),
                    child: QuizPlayScreen(quiz: quiz),
                  ),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withAlpha(10),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.quiz,
                      size: 32.sp,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quiz.title,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.question_answer_outlined,
                                  size: 16.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  '${quiz.questions.length} ${"questions".tr()}',
                                ),
                                SizedBox(width: 16.w),
                                Icon(Icons.timer_outlined, size: 16.sp),
                                SizedBox(width: 4.w),
                                Text('${quiz.timeLimit} ${"minutes".tr()}'),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 30.sp,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
        )
        .animate(delay: Duration(milliseconds: 100 * index))
        .slideX(begin: 0.5, end: 0, duration: const Duration(milliseconds: 300))
        .fadeIn();
  }
}
