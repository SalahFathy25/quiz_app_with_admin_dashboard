import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/model/category.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Category>> getCategories() async {
    try {
      final snapshot = await _firestore
          .collection('categories')
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => Category.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Category>> getCategoriesStream() {
    return _firestore
        .collection('categories')
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Category.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> addCategory(Category category) async {
    try {
      await _firestore.collection('categories').add(category.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCategory(Category category) async {
    try {
      await _firestore
          .collection('categories')
          .doc(category.id)
          .update(category.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      await _firestore.collection('categories').doc(categoryId).delete();
    } catch (e) {
      rethrow;
    }
  }
}
