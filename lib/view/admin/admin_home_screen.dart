import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/logic/auth/auth_cubit.dart';
import 'package:quiz_app/logic/admin/admin_stats_cubit.dart';
import 'package:quiz_app/logic/admin/admin_stats_state.dart';
import 'package:quiz_app/core/routes/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:quiz_app/view/admin/widgets/admin_dashboard_card.dart';
import 'package:quiz_app/view/admin/widgets/admin_stat_card.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminStatsCubit()..fetchStatistics(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'admin_dashboard'.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.settingsScreen);
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
                      Text(
                        'welcome_admin'.tr(),
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
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
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.pie_chart_rounded,
                                    color: Theme.of(context).primaryColor,
                                    size: 24.0,
                                  ),
                                  const SizedBox(width: 12.0),
                                  Text(
                                    'category_statistics'.tr(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: categoryData.length,
                                itemBuilder: (context, index) {
                                  final category = categoryData[index];
                                  final totalQuizzes = categoryData.fold(
                                    0,
                                    (sun, item) => (sun + item['count'] as int),
                                  );

                                  final percentage = totalQuizzes > 0
                                      ? ((category['count'] as int) /
                                            totalQuizzes *
                                            100)
                                      : 0.0;
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 16.0,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                category['name'] as String,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                              ),
                                              const SizedBox(height: 5.0),
                                              Text(
                                                '${category['count']} ${(category['count'] as int) == 1 ? 'quiz'.tr() : 'quizzes'.tr()}',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 6.0,
                                            horizontal: 12.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(
                                              context,
                                            ).primaryColor.withAlpha(10),
                                            borderRadius: BorderRadius.circular(
                                              20.0,
                                            ),
                                          ),
                                          child: Text(
                                            '${percentage.toStringAsFixed(0)}%',
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(
                                                context,
                                              ).primaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.history_rounded,
                                    color: Theme.of(context).primaryColor,
                                    size: 24.0,
                                  ),
                                  const SizedBox(width: 12.0),
                                  Text(
                                    'recent_activity'.tr(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: latestQuizzes.length,
                                itemBuilder: (context, index) {
                                  final quiz =
                                      latestQuizzes[index].data()
                                          as Map<String, dynamic>;

                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 16.0,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color: Theme.of(
                                              context,
                                            ).primaryColor.withAlpha(10),
                                            borderRadius: BorderRadius.circular(
                                              12.0,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.quiz_rounded,
                                            color: Theme.of(
                                              context,
                                            ).primaryColor,
                                            size: 20.0,
                                          ),
                                        ),
                                        const SizedBox(width: 16.0),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                quiz['title'],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4.0),
                                              Text(
                                                '${'created_on'.tr()} ${_formatDate(quiz['createdAt'].toDate())}',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.speed_rounded,
                                    color: Theme.of(context).primaryColor,
                                    size: 24.0,
                                  ),
                                  const SizedBox(width: 12.0),
                                  Text(
                                    'quiz_actions'.tr(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              GridView.count(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.9,
                                crossAxisSpacing: 16,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  AdminDashboardCard(
                                    title: 'quizzes'.tr(),
                                    icon: Icons.quiz_rounded,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.manageQuizzes,
                                      );
                                    },
                                  ),
                                  AdminDashboardCard(
                                    title: 'categories'.tr(),
                                    icon: Icons.category_rounded,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.manageCategories,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
