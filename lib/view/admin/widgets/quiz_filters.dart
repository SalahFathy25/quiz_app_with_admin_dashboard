import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/logic/admin/manage_quizzes_cubit.dart';
import 'package:quiz_app/logic/admin/manage_quizzes_state.dart';

class QuizFilters extends StatelessWidget {
  final TextEditingController searchController;

  const QuizFilters({
    super.key,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Search quizzes',
              prefixIcon: Icon(Icons.search),
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
}
