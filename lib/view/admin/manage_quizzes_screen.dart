import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/logic/admin/manage_quizzes_cubit.dart';
import 'package:quiz_app/logic/admin/manage_quizzes_state.dart';
import 'package:quiz_app/model/quiz.dart';
import 'package:quiz_app/core/routes/routes.dart';

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
            var title = widget.categoryName ?? 'All Quizzes';
            if (state is ManageQuizzesLoaded &&
                state.selectedCategoryId != null) {
              try {
                title = state.categories
                    .firstWhere((c) => c.id == state.selectedCategoryId)
                    .name;
              } catch (_) {
                // Category might not be loaded yet
              }
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
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search quizzes',
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 12),
          BlocBuilder<ManageQuizzesCubit, ManageQuizzesState>(
            builder: (context, state) {
              if (state is ManageQuizzesLoaded) {
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(hintText: 'Category'),
                  value: state.selectedCategoryId,
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('All Categories'),
                    ),
                    ...state.categories.map(
                      (category) => DropdownMenuItem(
                        value: category.id,
                        child: Text(category.name),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    context.read<ManageQuizzesCubit>().onCategoryChanged(value);
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
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
            'No quizzes yet',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _navigateToAddQuiz(context),
            child: const Text('Add Quiz'),
          ),
        ],
      ),
    );
  }

  Card _buildQuizCard(BuildContext context, Quiz quiz) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: _buildQuizIcon(context),
        title: Text(
          quiz.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: _buildQuizSubtitle(quiz),
        trailing: _buildPopupMenu(context, quiz),
        onTap: () => _navigateToEditQuiz(context, quiz),
      ),
    );
  }

  Widget _buildQuizIcon(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withAlpha(10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.quiz_rounded, color: Theme.of(context).primaryColor),
    );
  }

  Widget _buildQuizSubtitle(Quiz quiz) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          const Icon(Icons.question_answer_outlined, size: 16),
          const SizedBox(width: 4.0),
          Text("${quiz.questions.length} Questions"),
          const SizedBox(width: 16.0),
          const Icon(Icons.timer_outlined, size: 16.0),
          const SizedBox(width: 4.0),
          Text("${quiz.timeLimit} mins"),
        ],
      ),
    );
  }

  PopupMenuButton<String> _buildPopupMenu(BuildContext context, Quiz quiz) {
    return PopupMenuButton(
      onSelected: (value) => _handleQuizAction(context, value, quiz),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.edit, color: Theme.of(context).primaryColor),
            title: Text('Edit'),
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.delete, color: Colors.redAccent),
            title: Text('Delete'),
          ),
        ),
      ],
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
        categoryName = state.categories
            .firstWhere((c) => c.id == categoryId)
            .name;
      }
    }
    Navigator.pushNamed(
      context,
      AppRoutes.addQuiz,
      arguments: {'categoryId': categoryId, 'categoryName': categoryName},
    );
  }

  void _navigateToEditQuiz(BuildContext context, Quiz quiz) {
    Navigator.pushNamed(context, AppRoutes.editQuiz, arguments: quiz);
  }

  Future<void> _confirmDeleteQuiz(BuildContext context, Quiz quiz) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Quiz'),
        content: const Text('Are you sure you want to delete this quiz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await context.read<ManageQuizzesCubit>().deleteQuiz(quiz.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quiz deleted successfully')),
      );
    }
  }
}
