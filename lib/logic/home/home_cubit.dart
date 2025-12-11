import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/logic/home/home_state.dart';
import 'package:quiz_app/services/category_service.dart';

class HomeCubit extends Cubit<HomeState> {
  final CategoryService _categoryService;

  HomeCubit(this._categoryService) : super(HomeInitial());

  void fetchCategories() async {
    try {
      emit(HomeLoading());
      final categories = await _categoryService.getCategories();
      final filters = ['All'] + categories.map((c) => c.name).toSet().toList();
      emit(
        HomeLoaded(
          allCategories: categories,
          filteredCategories: categories,
          categoryFilters: filters,
          selectedFilter: 'All',
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void filterCategories(String searchQuery, {String? categoryFilter}) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final newSelectedFilter = categoryFilter ?? currentState.selectedFilter;

      final filtered = currentState.allCategories.where((category) {
        final nameMatch =
            category.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            category.description.toLowerCase().contains(
              searchQuery.toLowerCase(),
            );

        final categoryMatch =
            newSelectedFilter == 'All' ||
            category.name.toLowerCase() == newSelectedFilter.toLowerCase();

        return nameMatch && categoryMatch;
      }).toList();

      emit(
        currentState.copyWith(
          filteredCategories: filtered,
          selectedFilter: newSelectedFilter,
          searchQuery: searchQuery,
        ),
      );
    }
  }
}
