import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app/logic/home/home_cubit.dart';
import 'package:quiz_app/logic/home/home_state.dart';

class CategoryFilterChips extends StatelessWidget {
  final HomeLoaded state;
  final TextEditingController searchController;

  const CategoryFilterChips({
    super.key,
    required this.state,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.all(16.r),
        height: 40.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: state.categoryFilters.length,
          itemBuilder: (context, index) {
            final filter = state.categoryFilters[index];
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: ChoiceChip(
                label: Text(
                  filter,
                  style: TextStyle(
                    color: state.selectedFilter == filter
                        ? Colors.white
                        : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                selected: state.selectedFilter == filter,
                selectedColor: Theme.of(context).primaryColor,
                backgroundColor: Theme.of(context).cardColor,
                onSelected: (bool selected) {
                  context.read<HomeCubit>().filterCategories(
                    searchController.text,
                    categoryFilter: filter,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
