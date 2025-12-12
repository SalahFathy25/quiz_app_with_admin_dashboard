import 'package:flutter/material.dart';
import 'package:quiz_app/model/category.dart';

class CategoryListItem extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;
  final void Function(String) onAction;

  const CategoryListItem({
    super.key,
    required this.category,
    required this.onTap,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withAlpha(10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.category_outlined,
            color: Theme.of(context).primaryColor,
            size: 24,
          ),
        ),
        title: Text(
          category.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(category.description),
        trailing: PopupMenuButton(
          onSelected: onAction,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                title: const Text('Edit'),
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.delete, color: Colors.redAccent),
                title: Text('Delete'),
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
