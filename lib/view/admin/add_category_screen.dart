import 'package:flutter/material.dart';

import '../../model/category.dart';
import '../../services/category_service.dart';

class AddCategoryScreen extends StatefulWidget {
  final Category? category;

  const AddCategoryScreen({super.key, this.category});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _categoryService = CategoryService();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name);
    _descriptionController = TextEditingController(
      text: widget.category?.description,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim();

      if (widget.category != null) {
        final updatedCategory = widget.category!.copyWith(
          name: name,
          description: description,
        );
        await _categoryService.updateCategory(updatedCategory);
        _showSnackbar('Category updated successfully');
      } else {
        final newCategory = Category(
          id: '', // Firestore will generate this
          name: name,
          description: description,
          createdAt: DateTime.now(),
        );
        await _categoryService.addCategory(newCategory);
        _showSnackbar('Category added successfully');
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      _showSnackbar('Error saving category: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<bool> _onWillPop() async {
    if (_nameController.text.isNotEmpty ||
        _descriptionController.text.isNotEmpty) {
      return await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Discard Changes'),
              content: const Text(
                'Are you sure you want to discard your changes?',
              ),
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
          ) ??
          false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.category == null ? 'Add Category' : 'Edit Category',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 24),
                  _buildNameField(context),
                  const SizedBox(height: 20),
                  _buildDescriptionField(context),
                  const SizedBox(height: 32),
                  _buildSaveButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
      ],
    );
  }

  Widget _buildNameField(BuildContext context) {
    return TextFormField(
      controller: _nameController,
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
    );
  }

  Widget _buildDescriptionField(BuildContext context) {
    return TextFormField(
      controller: _descriptionController,
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
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.0,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveCategory,
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : Text(
                widget.category == null ? 'Add Category' : 'Update Category',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
