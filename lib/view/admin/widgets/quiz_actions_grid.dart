import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/core/routes/app_routes.dart';
import 'package:quiz_app/core/routes/routes.dart';
import 'package:quiz_app/view/admin/widgets/admin_dashboard_card.dart';

class QuizActionsGrid extends StatelessWidget {
  const QuizActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
                    Navigator.pushNamed(context, manageQuizzesScreen);
                  },
                ),
                AdminDashboardCard(
                  title: 'categories'.tr(),
                  icon: Icons.category_rounded,
                  onTap: () {
                    Navigator.pushNamed(context, manageCategoriesScreen);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
