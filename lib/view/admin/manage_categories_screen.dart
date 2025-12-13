import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/logic/admin/manage_categories_cubit.dart';
import 'package:quiz_app/logic/admin/manage_categories_state.dart';
import 'package:quiz_app/model/category.dart';
import 'package:quiz_app/core/routes/app_routes.dart';
import 'package:quiz_app/view/admin/widgets/category_list_item.dart';

import '../../core/routes/routes.dart';

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ManageCategoriesCubit>().fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Categories',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => _navigateToAddCategory(context),
            icon: Icon(
              Icons.add_circle_outline,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      body: BlocBuilder<ManageCategoriesCubit, ManageCategoriesState>(
        builder: (context, state) {
          if (state is ManageCategoriesLoading ||
              state is ManageCategoriesInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ManageCategoriesError) {
            return Center(child: Text(state.message));
          }
          if (state is ManageCategoriesLoaded) {
            if (state.categories.isEmpty) {
              return _buildEmptyState(context);
            }
            return _buildCategoryList(state.categories);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_rounded,
            size: 64,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No categories found',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _navigateToAddCategory(context),
            child: const Text('Add Category'),
          ),
        ],
      ),
    );
  }

  ListView _buildCategoryList(List<Category> categories) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return CategoryListItem(
          category: category,
          onTap: () => _navigateToManageQuizzes(context, category),
          onAction: (action) =>
              _handleCategoryAction(context, action, category),
        );
      },
    );
  }

  void _handleCategoryAction(
    BuildContext context,
    String action,
    Category category,
  ) {
    if (action == 'edit') {
      _navigateToEditCategory(context, category);
    } else if (action == 'delete') {
      _confirmDeleteCategory(context, category);
    }
  }

  void _navigateToAddCategory(BuildContext context) {
    Navigator.pushNamed(context, addCategoryScreen).then((_) {
      context.read<ManageCategoriesCubit>().fetchCategories();
    });
  }

  void _navigateToEditCategory(BuildContext context, Category category) {
    Navigator.pushNamed(context, addCategoryScreen, arguments: category).then((
      _,
    ) {
      context.read<ManageCategoriesCubit>().fetchCategories();
    });
  }

  void _navigateToManageQuizzes(BuildContext context, Category category) {
    Navigator.pushNamed(
      context,
      manageQuizzesScreen,
      arguments: {'categoryId': category.id, 'categoryName': category.name},
    );
  }

  Future<void> _confirmDeleteCategory(
    BuildContext context,
    Category category,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: const Text('Are you sure you want to delete this category?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      await context.read<ManageCategoriesCubit>().deleteCategory(category.id);
    }
  }
}
