import 'package:equatable/equatable.dart';
import 'package:quiz_app/model/category.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Category> allCategories;
  final List<Category> filteredCategories;
  final List<String> categoryFilters;
  final String selectedFilter;
  final String searchQuery;

  const HomeLoaded({
    required this.allCategories,
    required this.filteredCategories,
    required this.categoryFilters,
    required this.selectedFilter,
    this.searchQuery = '',
  });

  HomeLoaded copyWith({
    List<Category>? allCategories,
    List<Category>? filteredCategories,
    List<String>? categoryFilters,
    String? selectedFilter,
    String? searchQuery,
  }) {
    return HomeLoaded(
      allCategories: allCategories ?? this.allCategories,
      filteredCategories: filteredCategories ?? this.filteredCategories,
      categoryFilters: categoryFilters ?? this.categoryFilters,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [
    allCategories,
    filteredCategories,
    categoryFilters,
    selectedFilter,
    searchQuery,
  ];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
