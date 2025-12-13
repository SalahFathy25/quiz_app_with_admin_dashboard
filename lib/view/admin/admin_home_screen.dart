import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/core/routes/routes.dart';
import 'package:quiz_app/logic/auth/auth_cubit.dart';
import 'package:quiz_app/logic/auth/auth_state.dart';
import 'package:quiz_app/logic/admin/admin_stats_cubit.dart';
import 'package:quiz_app/logic/admin/admin_stats_state.dart';
import 'package:quiz_app/core/routes/app_routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:quiz_app/view/admin/widgets/admin_stat_card.dart';
import 'package:quiz_app/view/admin/widgets/category_stats_list.dart';
import 'package:quiz_app/view/admin/widgets/recent_activity_list.dart';
import 'package:quiz_app/view/admin/widgets/quiz_actions_grid.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'admin_dashboard'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, settingsScreen);
            },
            icon: const Icon(Icons.settings),
            tooltip: 'settings'.tr(),
          ),
          IconButton(
            onPressed: () {
              context.read<AuthCubit>().signOut();
            },
            icon: const Icon(Icons.logout),
            tooltip: 'sign_out'.tr(),
          ),
        ],
      ),
      body: BlocBuilder<AdminStatsCubit, AdminStatsState>(
        builder: (context, state) {
          if (state is AdminStatsLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          }

          if (state is AdminStatsError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is AdminStatsLoaded) {
            final stats = state.stats;
            final List<dynamic> categoryData = stats['categoriesData'] ?? [];
            final List<QueryDocumentSnapshot> latestQuizzes =
                stats['latestQuizzes'];

            return RefreshIndicator(
              color: Theme.of(context).primaryColor,
              onRefresh: () async {
                context.read<AdminStatsCubit>().fetchStatistics();
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, authState) {
                        String username = 'Admin';
                        if (authState is Authenticated) {
                          username = authState.user.username;
                        }
                        return Text(
                          'welcome_admin'.tr(args: [username]),
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "app_overview".tr(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 24.0),
                    Row(
                      children: [
                        Expanded(
                          child: AdminStatCard(
                            title: 'total_categories'.tr(),
                            value: stats['totalCategories'].toString(),
                            icon: Icons.category_rounded,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: AdminStatCard(
                            title: 'total_quizzes'.tr(),
                            value: stats['totalQuizzes'].toString(),
                            icon: Icons.quiz_rounded,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0),
                    CategoryStatsList(categoryData: categoryData),
                    const SizedBox(height: 24.0),
                    RecentActivityList(latestQuizzes: latestQuizzes),
                    const SizedBox(height: 24.0),
                    const QuizActionsGrid(),
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
