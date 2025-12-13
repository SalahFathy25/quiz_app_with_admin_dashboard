import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/logic/admin/manage_quizzes_cubit.dart';
import 'package:quiz_app/logic/admin/manage_quizzes_state.dart';
import 'package:quiz_app/model/quiz.dart';
import 'package:quiz_app/core/routes/app_routes.dart';
import '../../core/routes/routes.dart';
import 'widgets/quiz_list_card.dart';
import 'widgets/quiz_filters.dart';

class ManageQuizzesScreen extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;

  const ManageQuizzesScreen({super.key, this.categoryId, this.categoryName});

  @override
  State<ManageQuizzesScreen> createState() => _ManageQuizzesScreenState();
}

class _ManageQuizzesScreenState extends State<ManageQuizzesScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ManageQuizzesCubit>().loadInitialData(
      categoryId: widget.categoryId,
    );
    _searchController.addListener(() {
      context.read<ManageQuizzesCubit>().onSearchChanged(
        _searchController.text,
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<ManageQuizzesCubit, ManageQuizzesState>(
          builder: (context, state) {
            var title = widget.categoryName ?? 'all_quizzes'.tr();
            if (state is ManageQuizzesLoaded &&
                state.selectedCategoryId != null) {
              try {
                title = state.categories
                    .firstWhere((c) => c.id == state.selectedCategoryId)
                    .name;
              } catch (_) {}
            }
            return Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () => _navigateToAddQuiz(context),
            icon: Icon(
              Icons.add_circle_outline,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(context),
          Expanded(child: _buildQuizList()),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return QuizFilters(searchController: _searchController);
  }

  Widget _buildQuizList() {
    return BlocConsumer<ManageQuizzesCubit, ManageQuizzesState>(
      listener: (context, state) {
        if (state is ManageQuizzesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        if (state is ManageQuizzesLoading || state is ManageQuizzesInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ManageQuizzesLoaded) {
          final filteredQuizzes = state.quizzes
              .where(
                (quiz) => quiz.title.toLowerCase().contains(
                  state.searchQuery.toLowerCase(),
                ),
              )
              .toList();

          if (filteredQuizzes.isEmpty) return _buildEmptyState(context);

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredQuizzes.length,
            itemBuilder: (context, index) =>
                _buildQuizCard(context, filteredQuizzes[index]),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.quiz_rounded,
            size: 64,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'no_quizzes_yet'.tr(),
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _navigateToAddQuiz(context),
            child: Text('add_quiz'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizCard(BuildContext context, Quiz quiz) {
    return QuizListCard(
      quiz: quiz,
      onTap: () => _navigateToEditQuiz(context, quiz),
      onAction: (action) => _handleQuizAction(context, action, quiz),
    );
  }

  void _handleQuizAction(BuildContext context, String action, Quiz quiz) {
    if (action == 'edit') {
      _navigateToEditQuiz(context, quiz);
    } else if (action == 'delete') {
      _confirmDeleteQuiz(context, quiz);
    }
  }

  void _navigateToAddQuiz(BuildContext context) {
    final state = context.read<ManageQuizzesCubit>().state;
    String? categoryId;
    String? categoryName;
    if (state is ManageQuizzesLoaded) {
      categoryId = state.selectedCategoryId;
      if (categoryId != null) {
        try {
          categoryName = state.categories
              .firstWhere((c) => c.id == categoryId)
              .name;
        } catch (_) {}
      }
    }
    Navigator.pushNamed(
      context,
      addQuizScreen,
      arguments: {'categoryId': categoryId, 'categoryName': categoryName},
    );
  }

  void _navigateToEditQuiz(BuildContext context, Quiz quiz) {
    Navigator.pushNamed(context, editQuizScreen, arguments: quiz);
  }

  Future<void> _confirmDeleteQuiz(BuildContext context, Quiz quiz) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('delete_quiz'.tr()),
        content: Text('are_you_sure_you_want_to_delete_this_quiz'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'delete'.tr(),
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await context.read<ManageQuizzesCubit>().deleteQuiz(quiz.id);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('quiz_deleted_successfully'.tr())));
    }
  }
}
