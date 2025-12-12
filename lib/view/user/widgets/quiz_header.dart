import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app/logic/quiz/quiz_play_cubit.dart';
import 'package:quiz_app/logic/quiz/quiz_play_state.dart';
import 'package:quiz_app/model/quiz.dart';
import 'package:quiz_app/view/user/widgets/quiz_timer.dart';

class QuizHeader extends StatelessWidget {
  final Quiz quiz;

  const QuizHeader({
    super.key,
    required this.quiz,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizPlayCubit, QuizPlayState>(
      builder: (context, state) {
        if (state is! QuizPlayInProgress) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: EdgeInsets.all(12.r),
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  QuizTimer(
                    remainingMinutes: state.remainingMinutes,
                    remainingSeconds: state.remainingSeconds,
                    totalMinutes: state.totalMinutes,
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              TweenAnimationBuilder<double>(
                tween: Tween(
                  begin: 0,
                  end: (state.currentQuestionIndex + 1) / quiz.questions.length,
                ),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, child) {
                  return LinearProgressIndicator(
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(10.r),
                      right: Radius.circular(10.r),
                    ),
                    value: value,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                    minHeight: 6.h,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
