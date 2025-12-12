import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app/logic/home/home_state.dart';
import 'package:quiz_app/view/user/widgets/category_card.dart';

class CategoryGrid extends StatelessWidget {
  final HomeState state;

  const CategoryGrid({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state is HomeLoading || state is HomeInitial) {
      return const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state is HomeError) {
      return SliverToBoxAdapter(
        child: Center(child: Text((state as HomeError).message)),
      );
    }
    if (state is HomeLoaded) {
      final loadedState = state as HomeLoaded;
      if (loadedState.filteredCategories.isEmpty) {
        return SliverToBoxAdapter(
          child: Center(
            child: Text(
              'no_categories_found'.tr(),
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ),
        );
      }
      return SliverPadding(
        padding: EdgeInsets.all(16.r),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) => CategoryCard(
              category: loadedState.filteredCategories[index],
              index: index,
            ),
            childCount: loadedState.filteredCategories.length,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16.h,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16.w,
          ),
        ),
      );
    }
    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}
