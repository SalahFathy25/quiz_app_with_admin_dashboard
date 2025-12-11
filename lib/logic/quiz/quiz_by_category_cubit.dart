import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/logic/quiz/quiz_by_category_state.dart';
import 'package:quiz_app/services/quiz_service.dart';

class QuizByCategoryCubit extends Cubit<QuizByCategoryState> {
  final QuizService _quizService;

  QuizByCategoryCubit(this._quizService) : super(QuizByCategoryInitial());

  void fetchQuizzesByCategory(String categoryId) async {
    try {
      emit(QuizByCategoryLoading());
      final quizzes = await _quizService.getQuizzesByCategory(categoryId);
      emit(QuizByCategoryLoaded(quizzes));
    } catch (e) {
      emit(QuizByCategoryError(e.toString()));
    }
  }
}
