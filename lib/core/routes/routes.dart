import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/core/di/di.dart';
import 'package:quiz_app/logic/home/home_cubit.dart';
import 'package:quiz_app/logic/admin/manage_categories_cubit.dart';
import 'package:quiz_app/logic/admin/manage_quizzes_cubit.dart';
import 'package:quiz_app/model/category.dart';
import 'package:quiz_app/model/quiz.dart';
import 'package:quiz_app/logic/quiz/quiz_by_category_cubit.dart';
import 'package:quiz_app/services/category_service.dart';
import 'package:quiz_app/services/quiz_service.dart';
import 'package:quiz_app/view/admin/add_category_screen.dart';
import 'package:quiz_app/view/admin/add_quiz_screen.dart';
import 'package:quiz_app/view/admin/admin_home_screen.dart';
import 'package:quiz_app/view/admin/edit_quiz_screen.dart';
import 'package:quiz_app/view/admin/manage_categories_screen.dart';
import 'package:quiz_app/view/admin/manage_quizzes_screen.dart';
import 'package:quiz_app/view/admin/settings_screen.dart';
import 'package:quiz_app/view/auth/register_screen.dart';
import 'package:quiz_app/view/user/category_screen.dart';
import 'package:quiz_app/view/user/home_screen.dart';

class AppRoutes {
  static const home = '/';
  static const category = '/category';
  static const adminHome = '/admin';
  static const addCategory = '/admin/add-category';
  static const manageCategories = '/admin/manage-categories';
  static const addQuiz = '/admin/add-quiz';
  static const editQuiz = '/admin/edit-quiz';
  static const manageQuizzes = '/admin/manage-quizzes';
  static const settingsScreen = '/settings';
  static const register = '/register';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => HomeCubit(getIt()),
            child: const HomeScreen(),
          ),
        );
      case adminHome:
        return MaterialPageRoute(builder: (_) => const AdminHomeScreen());
      case manageCategories:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                ManageCategoriesCubit(getIt())..fetchCategories(),
            child: const ManageCategoriesScreen(),
          ),
        );
      case category:
        final args = settings.arguments as Category;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                QuizByCategoryCubit(getIt())..fetchQuizzesByCategory(args.id),
            child: CategoryScreen(category: args),
          ),
        );
      case addCategory:
        final args = settings.arguments as Category?;
        return MaterialPageRoute(
          builder: (_) => AddCategoryScreen(category: args),
        );
      case manageQuizzes:
        final args = settings.arguments as Map<String, String?>?;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                ManageQuizzesCubit(getIt(), getIt())
                  ..loadInitialData(categoryId: args?['categoryId']),
            child: ManageQuizzesScreen(
              categoryId: args?['categoryId'],
              categoryName: args?['categoryName'],
            ),
          ),
        );
      case addQuiz:
        final args = settings.arguments as Map<String, String?>?;
        return MaterialPageRoute(
          builder: (_) => AddQuizScreen(
            categoryId: args?['categoryId'],
            categoryName: args?['categoryName'],
          ),
        );
      case editQuiz:
        final args = settings.arguments as Quiz;
        return MaterialPageRoute(builder: (_) => EditQuizScreen(quiz: args));
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case settingsScreen:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
