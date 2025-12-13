import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/model/category.dart';
import 'package:quiz_app/services/category_service.dart';
import 'package:quiz_app/core/widgets/custom_text_field.dart';

class QuizDetailsForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController timeLimitController;
  final String? categoryId;
  final String? selectedCategoryId;
  final ValueChanged<String?> onCategoryChanged;

  const QuizDetailsForm({
    super.key,
    required this.titleController,
    required this.timeLimitController,
    required this.categoryId,
    required this.selectedCategoryId,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'quiz_details'.tr(),
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: titleController,
          labelText: 'quiz_title'.tr(),
          hintText: 'enter_quiz_title'.tr(),
          prefixIcon: Icons.title,
          validator: (value) =>
              value!.isEmpty ? 'please_enter_quiz_title'.tr() : null,
          isFinal: false,
        ),
        const SizedBox(height: 20),
        if (categoryId == null)
          StreamBuilder<List<Category>>(
            stream: CategoryService().getCategoriesStream(),
            builder: (context, snapshot) {
              if (snapshot.hasError)
                return Text('error'.tr() + ': ${snapshot.error}');
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final categories = snapshot.data!;
              return DropdownButtonFormField<String>(
                value: selectedCategoryId,
                decoration: InputDecoration(
                  labelText: 'category'.tr(),
                  hintText: 'select_category'.tr(),
                  prefixIcon: Icon(
                    Icons.category,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                items: categories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category.id,
                        child: Text(category.name),
                      ),
                    )
                    .toList(),
                onChanged: onCategoryChanged,
                validator: (value) =>
                    value == null ? 'please_select_category'.tr() : null,
              );
            },
          ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: timeLimitController,
          labelText: 'time_limit_in_minutes'.tr(),
          hintText: 'enter_time_limit'.tr(),
          prefixIcon: Icons.timer,
          validator: (value) {
            if (value!.isEmpty) return 'please_enter_time_limit'.tr();
            final timeLimit = int.tryParse(value);
            if (timeLimit == null || timeLimit <= 0) {
              return 'please_enter_valid_time_limit'.tr();
            }
            return null;
          },
          isFinal: true,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
