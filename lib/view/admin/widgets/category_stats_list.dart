import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CategoryStatsList extends StatelessWidget {
  final List<dynamic> categoryData;

  const CategoryStatsList({
    super.key,
    required this.categoryData,
  });

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
                  (sum, item) => (sum + item['count'] as int),
                );

                final percentage = totalQuizzes > 0
                    ? ((category['count'] as int) / totalQuizzes * 100)
                    : 0.0;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category['name'] as String,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              '${category['count']} ${(category['count'] as int) == 1 ? 'quiz'.tr() : 'quizzes'.tr()}',
                              style: Theme.of(context).textTheme.bodyMedium,
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
                          color: Theme.of(context).primaryColor.withAlpha(10),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          '${percentage.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor,
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
    );
  }
}
