import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app/model/category.dart';
import 'package:quiz_app/logic/quiz/quiz_by_category_cubit.dart';
import 'package:quiz_app/logic/quiz/quiz_by_category_state.dart';

import '../../model/quiz.dart';
import 'quiz_play_screen.dart';

class CategoryScreen extends StatefulWidget {
  final Category category;

  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<QuizByCategoryCubit>().fetchQuizzesByCategory(
      widget.category.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<QuizByCategoryCubit, QuizByCategoryState>(
        builder: (context, state) {
          if (state is QuizByCategoryLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          } else if (state is QuizByCategoryError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is QuizByCategoryLoaded) {
            if (state.quizzes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.quiz_outlined,
                      size: 64.sp,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'no_quizzes_in_category'.tr(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('go_back'.tr()),
                    ),
                  ],
                ),
              );
            }
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  expandedHeight: 230.h,
                  floating: false,
                  pinned: true,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Padding(
                      padding: EdgeInsets.all(8.0.r),
                      child: Text(
                        widget.category.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    background: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.category_rounded,
                            size: 64.sp,
                            color: Colors.white,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            widget.category.name,
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 30.h),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.quizzes.length,
                      itemBuilder: (context, index) {
                        final quiz = state.quizzes[index];
                        return _buildQuizCard(quiz, index);
                      },
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildQuizCard(Quiz quiz, int index) {
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
                  builder: (context) => QuizPlayScreen(quiz: quiz),
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
        .slideX(begin: 0.5, end: 0, duration: Duration(milliseconds: 300))
        .fadeIn();
  }
}
