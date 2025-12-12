import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/logic/home/home_cubit.dart';
import 'package:quiz_app/logic/home/home_state.dart';
import 'package:quiz_app/view/user/widgets/category_filter_chips.dart';
import 'package:quiz_app/view/user/widgets/category_grid.dart';
import 'package:quiz_app/view/user/widgets/home_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().fetchCategories();
    _searchController.addListener(() {
      context.read<HomeCubit>().filterCategories(_searchController.text);
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
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              HomeAppBar(
                state: state,
                searchController: _searchController,
              ),
              if (state is HomeLoaded)
                CategoryFilterChips(
                  state: state,
                  searchController: _searchController,
                ),
              CategoryGrid(state: state),
            ],
          );
        },
      ),
    );
  }
}
