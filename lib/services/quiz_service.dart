import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/model/quiz.dart';

class QuizService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Quiz>> getQuizzesByCategory(String categoryId) async {
    try {
      final snapshot = await _firestore
          .collection('quizzes')
          .where('categoryId', isEqualTo: categoryId)
          .get();

      return snapshot.docs
          .map((doc) => Quiz.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Quiz>> getQuizzesStream({String? categoryId}) {
    Query query = _firestore.collection('quizzes');
    if (categoryId != null) {
      query = query.where('categoryId', isEqualTo: categoryId);
    }
    return query.snapshots().map(
      (snapshot) => snapshot.docs
          .map(
            (doc) => Quiz.fromMap(doc.id, doc.data() as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Future<void> addQuiz(Quiz quiz) async {
    try {
      await _firestore.collection('quizzes').add(quiz.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateQuiz(Quiz quiz) async {
    try {
      await _firestore
          .collection('quizzes')
          .doc(quiz.id)
          .update(quiz.toMap(isUpdate: true));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteQuiz(String quizId) async {
    try {
      await _firestore.collection('quizzes').doc(quizId).delete();
    } catch (e) {
      rethrow;
    }
  }
}
