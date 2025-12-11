import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/logic/admin/manage_categories_state.dart';
import 'package:quiz_app/services/category_service.dart';

class ManageCategoriesCubit extends Cubit<ManageCategoriesState> {
  final CategoryService _categoryService;
  StreamSubscription? _categoriesSubscription;

  ManageCategoriesCubit(this._categoryService)
      : super(ManageCategoriesInitial());

  void fetchCategories() {
    _categoriesSubscription?.cancel();
    _categoriesSubscription = _categoryService.getCategoriesStream().listen(
      (categories) {
        emit(ManageCategoriesLoaded(categories));
      },
      onError: (error) {
        emit(ManageCategoriesError(error.toString()));
      },
    );
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      await _categoryService.deleteCategory(categoryId);
    } catch (e) {
      emit(ManageCategoriesError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _categoriesSubscription?.cancel();
    return super.close();
  }
}
