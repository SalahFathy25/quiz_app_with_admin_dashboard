import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app/core/theme/theme.dart';
import 'package:quiz_app/logic/quiz/quiz_play_cubit.dart';
import 'package:quiz_app/logic/quiz/quiz_play_state.dart';
import 'package:quiz_app/model/question.dart';

import '../../../core/widgets/custom_button.dart';

class QuizQuestionCard extends StatelessWidget {
  final Question question;
  final int index;
  final Map<int, int?> selectedAnswers;
  final int totalQuestions;

  const QuizQuestionCard({
    super.key,
    required this.question,
    required this.index,
    required this.selectedAnswers,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          margin: EdgeInsets.all(16.r),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${"question".tr()} ${index + 1}',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Theme.of(context).textTheme.bodyLarge?.backgroundColor,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                question.text,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.backgroundColor,
                ),
              ),
              SizedBox(height: 24.h),
              ...question.options.asMap().entries.map((entry) {
                final optionIndex = entry.key;
                final option = entry.value;
                final isSelected = selectedAnswers[index] == optionIndex;
                final isCorrect =
                    selectedAnswers[index] == question.correctOptionIndex;

                return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? isCorrect
                                    ? AppTheme.secondaryColor.withAlpha(10)
                                    : Colors.redAccent.withAlpha(10)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? isCorrect
                                      ? AppTheme.secondaryColor
                                      : Colors.redAccent
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: ListTile(
                          onTap: selectedAnswers[index] == null
                              ? () {
                                  context.read<QuizPlayCubit>().selectAnswer(
                                    optionIndex,
                                  );
                                }
                              : null,
                          title: Text(
                            option,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? isCorrect
                                        ? AppTheme.secondaryColor
                                        : Colors.redAccent
                                  : selectedAnswers[index] != null
                                  ? Colors.grey.shade500
                                  : AppTheme.lightTextPrimaryColor,
                            ),
                          ),
                          trailing: isSelected
                              ? isCorrect
                                    ? const Icon(
                                        Icons.check_circle_rounded,
                                        color: AppTheme.secondaryColor,
                                      )
                                    : const Icon(
                                        Icons.close,
                                        color: Colors.redAccent,
                                      )
                              : null,
                        ),
                      ),
                    )
                    .animate(delay: const Duration(milliseconds: 300))
                    .slideX(
                      begin: 0.5,
                      end: 0,
                      duration: const Duration(milliseconds: 300),
                    )
                    .fadeIn();
              }),
              const Spacer(),
              BlocBuilder<QuizPlayCubit, QuizPlayState>(
                builder: (context, state) {
                  if (state is! QuizPlayInProgress) {
                    return const SizedBox.shrink();
                  }

                  final isAnswered = state.selectedAnswers[index] != null;
                  final isLastQuestion = index == totalQuestions - 1;

                  return CustomButton(
                    text: isLastQuestion
                        ? 'finish_quiz'.tr()
                        : 'next_question'.tr(),
                    onPressed: isAnswered
                        ? () {
                            context.read<QuizPlayCubit>().nextQuestion();
                          }
                        : null,
                  );
                },
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 500))
        .slideY(begin: 0.1, end: 0);
  }
}
