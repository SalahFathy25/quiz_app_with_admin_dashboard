import 'package:flutter/material.dart';

class CategoryFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;

  const CategoryFormFields({
    super.key,
    required this.nameController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category Details',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Create a new category for organizing your quizzes.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Category Name',
            hintText: 'Enter Category name',
            prefixIcon: Icon(
              Icons.category_rounded,
              color: Theme.of(context).primaryColor,
            ),
          ),
          validator: (value) =>
              value!.isEmpty ? 'Please enter a category name' : null,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: descriptionController,
          decoration: InputDecoration(
            labelText: 'Description',
            hintText: 'Enter Category description',
            alignLabelWithHint: true,
            prefixIcon: Icon(
              Icons.description_rounded,
              color: Theme.of(context).primaryColor,
            ),
          ),
          maxLines: 3,
          validator: (value) =>
              value!.isEmpty ? 'Please enter a category description' : null,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}
