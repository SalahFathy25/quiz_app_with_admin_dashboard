import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'admin_stats_state.dart';

class AdminStatsCubit extends Cubit<AdminStatsState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AdminStatsCubit() : super(AdminStatsInitial());

  Future<void> fetchStatistics() async {
    emit(AdminStatsLoading());
    try {
      final categoriesCount = await _firestore
          .collection('categories')
          .count()
          .get();
      final quizzesCount = await _firestore.collection('quizzes').count().get();
      final latestQuizzes = await _firestore
          .collection('quizzes')
          .orderBy('createdAt', descending: true)
          .limit(5)
          .get();
      final categories = await _firestore.collection('categories').get();
      final categoriesData = await Future.wait(
        categories.docs.map((category) async {
          final quizCount = await _firestore
              .collection('quizzes')
              .where('categoryId', isEqualTo: category.id)
              .count()
              .get();
          return {
            'name': category.data()['name'] as String,
            'count': quizCount.count,
          };
        }),
      );

      emit(
        AdminStatsLoaded({
          'totalCategories': categoriesCount.count,
          'totalQuizzes': quizzesCount.count,
          'latestQuizzes': latestQuizzes.docs,
          'categoriesData': categoriesData,
        }),
      );
    } catch (e) {
      emit(AdminStatsError(e.toString()));
    }
  }
}
