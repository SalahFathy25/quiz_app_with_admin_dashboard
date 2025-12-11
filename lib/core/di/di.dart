import 'package:get_it/get_it.dart';

import '../../services/category_service.dart';
import '../../services/quiz_service.dart';
import '../../services/auth_service.dart';

final getIt = GetIt.instance;
Future<void> initGetIt() async {
  getIt.registerSingleton<CategoryService>(CategoryService());
  getIt.registerSingleton<QuizService>(QuizService());
  getIt.registerSingleton<AuthService>(AuthService());
}
