import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/logic/admin/manage_quizzes_state.dart';
import 'package:quiz_app/services/category_service.dart';
import 'package:quiz_app/services/quiz_service.dart';

class ManageQuizzesCubit extends Cubit<ManageQuizzesState> {
  final QuizService _quizService;
  final CategoryService _categoryService;
  StreamSubscription? _quizzesSubscription;

  ManageQuizzesCubit(this._quizService, this._categoryService)
      : super(ManageQuizzesInitial());

  void loadInitialData({String? categoryId}) {
    emit(ManageQuizzesLoading());
    _fetchCategoriesAndQuizzes(categoryId: categoryId);
  }

  void _fetchCategoriesAndQuizzes({String? categoryId}) async {
    try {
      final categories = await _categoryService.getCategories();
      _quizzesSubscription?.cancel();
      _quizzesSubscription = _quizService
          .getQuizzesStream(categoryId: categoryId)
          .listen((quizzes) {
            emit(
              ManageQuizzesLoaded(
                quizzes: quizzes,
                categories: categories,
                selectedCategoryId: categoryId,
              ),
            );
          });
    } catch (e) {
      emit(ManageQuizzesError(e.toString()));
    }
  }

  void onCategoryChanged(String? categoryId) {
    if (state is ManageQuizzesLoaded) {
      final currentState = state as ManageQuizzesLoaded;
      _quizzesSubscription?.cancel();
      _quizzesSubscription = _quizService
          .getQuizzesStream(categoryId: categoryId)
          .listen((quizzes) {
            emit(
              currentState.copyWith(
                quizzes: quizzes,
                selectedCategoryId: categoryId,
              ),
            );
          });
    }
  }

  void onSearchChanged(String searchQuery) {
    if (state is ManageQuizzesLoaded) {
      final currentState = state as ManageQuizzesLoaded;
      emit(currentState.copyWith(searchQuery: searchQuery));
    }
  }

  Future<void> deleteQuiz(String quizId) async {
    try {
      await _quizService.deleteQuiz(quizId);
    } catch (e) {
      emit(ManageQuizzesError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _quizzesSubscription?.cancel();
    return super.close();
  }
}
