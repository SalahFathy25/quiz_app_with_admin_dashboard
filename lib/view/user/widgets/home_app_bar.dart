import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_app/logic/auth/auth_cubit.dart';
import 'package:quiz_app/logic/auth/auth_state.dart';
import 'package:quiz_app/logic/home/home_state.dart';
import 'package:quiz_app/core/routes/routes.dart';

class HomeAppBar extends StatelessWidget {
  final HomeState state;
  final TextEditingController searchController;

  const HomeAppBar({
    super.key,
    required this.state,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
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
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.settingsScreen);
          },
          icon: const Icon(Icons.settings, color: Colors.white),
          tooltip: 'settings'.tr(),
        ),
        IconButton(
          onPressed: () {
            context.read<AuthCubit>().signOut();
          },
          icon: const Icon(Icons.logout, color: Colors.white),
          tooltip: 'sign_out'.tr(),
        ),
      ],
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
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, authState) {
                        String username = 'User';
                        if (authState is Authenticated) {
                          username = authState.user.username;
                        }
                        return Text(
                          'welcome_learner'.tr(args: [username]),
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      },
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
                    _buildSearchBar(context),
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

  Widget _buildSearchBar(BuildContext context) {
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
        controller: searchController,
        decoration: InputDecoration(
          hintText: "search_categories".tr(),
          prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryColor),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    searchController.clear();
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
}
