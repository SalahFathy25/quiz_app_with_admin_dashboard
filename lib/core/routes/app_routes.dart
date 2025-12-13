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
import 'package:quiz_app/view/auth/settings_screen.dart';
import 'package:quiz_app/view/auth/register_screen.dart';
import 'package:quiz_app/view/user/category_screen.dart';
import 'package:quiz_app/view/user/home_screen.dart';

import '../../logic/admin/admin_stats_cubit.dart';
import 'routes.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case userHomeScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => HomeCubit(getIt()),
            child: const HomeScreen(),
          ),
        );
      case adminHomeScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AdminStatsCubit()..fetchStatistics(),
            child: AdminHomeScreen(),
          ),
        );
      case manageCategoriesScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                ManageCategoriesCubit(getIt())..fetchCategories(),
            child: const ManageCategoriesScreen(),
          ),
        );
      case categoryScreen:
        final args = settings.arguments as Category;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                QuizByCategoryCubit(getIt())..fetchQuizzesByCategory(args.id),
            child: CategoryScreen(category: args),
          ),
        );
      case addCategoryScreen:
        final args = settings.arguments as Category?;
        return MaterialPageRoute(
          builder: (_) => AddCategoryScreen(category: args),
        );
      case manageQuizzesScreen:
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
      case addQuizScreen:
        final args = settings.arguments as Map<String, String?>?;
        return MaterialPageRoute(
          builder: (_) => AddQuizScreen(
            categoryId: args?['categoryId'],
            categoryName: args?['categoryName'],
          ),
        );
      case editQuizScreen:
        final args = settings.arguments as Quiz;
        return MaterialPageRoute(builder: (_) => EditQuizScreen(quiz: args));
      case registerScreen:
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
