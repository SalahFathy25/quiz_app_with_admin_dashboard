import 'package:flutter/material.dart';
import 'package:quiz_app/model/category.dart';
import 'package:quiz_app/services/category_service.dart';

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
          'Quiz Details',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: 'Quiz Title',
            hintText: 'Enter Quiz title',
            prefixIcon: Icon(Icons.title, color: Theme.of(context).primaryColor),
          ),
          validator: (value) => value!.isEmpty ? 'Please enter a quiz title' : null,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 20),
        if (categoryId == null)
          StreamBuilder<List<Category>>(
            stream: CategoryService().getCategoriesStream(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final categories = snapshot.data!;
              return DropdownButtonFormField<String>(
                value: selectedCategoryId,
                decoration: InputDecoration(
                  labelText: 'Category',
                  hintText: 'Select category',
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
                    value == null ? 'Please select a category' : null,
              );
            },
          ),
        const SizedBox(height: 16),
        TextFormField(
          controller: timeLimitController,
          decoration: InputDecoration(
            labelText: 'Time Limit (in minutes)',
            hintText: 'Enter time limit',
            prefixIcon: Icon(Icons.timer, color: Theme.of(context).primaryColor),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) return 'Please enter a time limit';
            final timeLimit = int.tryParse(value);
            if (timeLimit == null || timeLimit <= 0) {
              return 'Please enter a valid time limit';
            }
            return null;
          },
        ),
      ],
    );
  }
}
