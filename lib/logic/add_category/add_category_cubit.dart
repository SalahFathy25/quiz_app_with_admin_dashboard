import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/logic/add_category/add_category_state.dart';
import 'package:quiz_app/model/category.dart';
import 'package:quiz_app/services/category_service.dart';

class AddCategoryCubit extends Cubit<AddCategoryState> {
  final CategoryService _categoryService;
  final Category? category;

  AddCategoryCubit(this._categoryService, this.category)
    : super(AddCategoryInitial());

  Future<void> saveCategory(
    GlobalKey<FormState> formKey,
    String name,
    String description,
  ) async {
    if (!formKey.currentState!.validate()) return;

    emit(AddCategoryLoading());

    try {
      if (category != null) {
        final updatedCategory = category!.copyWith(
          name: name,
          description: description,
        );
        await _categoryService.updateCategory(updatedCategory);
      } else {
        final newCategory = Category(
          id: '',
          name: name,
          description: description,
          createdAt: DateTime.now(),
        );
        await _categoryService.addCategory(newCategory);
      }
      emit(AddCategorySuccess());
    } catch (e) {
      emit(AddCategoryError('Error saving category: $e'));
    }
  }
}
