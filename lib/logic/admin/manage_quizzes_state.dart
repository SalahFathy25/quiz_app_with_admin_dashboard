import 'package:equatable/equatable.dart';
import 'package:quiz_app/model/category.dart';
import 'package:quiz_app/model/quiz.dart';

abstract class ManageQuizzesState extends Equatable {
  const ManageQuizzesState();

  @override
  List<Object?> get props => [];
}

class ManageQuizzesInitial extends ManageQuizzesState {}

class ManageQuizzesLoading extends ManageQuizzesState {}

class ManageQuizzesLoaded extends ManageQuizzesState {
  final List<Quiz> quizzes;
  final List<Category> categories;
  final String? selectedCategoryId;
  final String searchQuery;

  const ManageQuizzesLoaded({
    required this.quizzes,
    required this.categories,
    this.selectedCategoryId,
    this.searchQuery = '',
  });

  ManageQuizzesLoaded copyWith({
    List<Quiz>? quizzes,
    List<Category>? categories,
    String? selectedCategoryId,
    String? searchQuery,
  }) {
    return ManageQuizzesLoaded(
      quizzes: quizzes ?? this.quizzes,
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    quizzes,
    categories,
    selectedCategoryId,
    searchQuery,
  ];
}

class ManageQuizzesError extends ManageQuizzesState {
  final String message;

  const ManageQuizzesError(this.message);

  @override
  List<Object> get props => [message];
}
