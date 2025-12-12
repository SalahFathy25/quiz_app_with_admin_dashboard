import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app/model/category.dart';
import 'package:quiz_app/logic/quiz/quiz_by_category_cubit.dart';
import 'package:quiz_app/logic/quiz/quiz_by_category_state.dart';
import 'package:quiz_app/view/user/widgets/quiz_list_card.dart';

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
                        return QuizListCard(quiz: quiz, index: index);
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
}
