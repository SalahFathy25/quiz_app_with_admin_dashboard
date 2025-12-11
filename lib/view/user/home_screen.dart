import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app/logic/home/home_cubit.dart';
import 'package:quiz_app/logic/home/home_state.dart';
import 'package:quiz_app/model/category.dart';
import 'package:quiz_app/core/routes/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().fetchCategories();
    _searchController.addListener(() {
      context.read<HomeCubit>().filterCategories(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(state),
              if (state is HomeLoaded) _buildCategoryFilters(state),
              _buildCategoryGrid(state),
            ],
          );
        },
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(HomeState state) {
    return SliverAppBar(
      expandedHeight: 230.h,
      pinned: true,
      floating: true,
      centerTitle: false,
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      title: Text(
        'Smart Quiz',
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Column(
            children: [
              SizedBox(height: kToolbarHeight + 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'welcome_learner'.tr(),
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "lets_test_knowledge".tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withAlpha(80),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildSearchBar(state),
                  ],
                ),
              ),
            ],
          ),
        ),
        collapseMode: CollapseMode.pin,
      ),
    );
  }

  Widget _buildSearchBar(HomeState state) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 4.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "search_categories".tr(),
          prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryColor),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                  },
                  icon: Icon(
                    Icons.clear,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : null,
          border: InputBorder.none,
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildCategoryFilters(HomeLoaded state) {
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
                    _searchController.text,
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

  Widget _buildCategoryGrid(HomeState state) {
    if (state is HomeLoading || state is HomeInitial) {
      return const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state is HomeError) {
      return SliverToBoxAdapter(child: Center(child: Text(state.message)));
    }
    if (state is HomeLoaded) {
      if (state.filteredCategories.isEmpty) {
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
            (context, index) =>
                _buildCategoryCard(state.filteredCategories[index], index),
            childCount: state.filteredCategories.length,
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

  Widget _buildCategoryCard(Category category, int index) {
    return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.category,
                arguments: category,
              );
            },
            child: Container(
              padding: EdgeInsets.all(16.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withAlpha(10),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.quiz,
                      size: 48.sp,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    category.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: Theme.of(
                        context,
                      ).textTheme.titleLarge?.fontSize?.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    category.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .slideY(
          begin: 0.5,
          end: 0,
          duration: const Duration(milliseconds: 300),
          delay: Duration(milliseconds: 100 * index),
        )
        .fadeIn();
  }
}
