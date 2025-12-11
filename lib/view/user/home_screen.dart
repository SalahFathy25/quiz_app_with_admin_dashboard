import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/logic/home/home_cubit.dart';
import 'package:quiz_app/logic/home/home_state.dart';
import 'package:quiz_app/model/category.dart';
import 'package:quiz_app/core/routes/routes.dart';

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
              _buildSliverAppBar(state),
              if (state is HomeLoaded) _buildCategoryFilters(state),
              _buildCategoryGrid(state),
            ],
          );
        },
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(HomeState state) {
    return SliverAppBar(
      expandedHeight: 230,
      pinned: true,
      floating: true,
      centerTitle: false,
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      title: const Text(
        'Smart Quiz',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: kToolbarHeight + 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome, Learner!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "let's test your knowledge today!",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withAlpha(80),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSearchBar(state),
                  ],
                ),
              ),
            ],
          ),
        ),
        collapseMode: CollapseMode.pin,
      ),
    );
  }

  Widget _buildSearchBar(HomeState state) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "search categories...",
          prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryColor),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                  },
                  icon: Icon(
                    Icons.clear,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : null,
          border: InputBorder.none,
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildCategoryFilters(HomeLoaded state) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: state.categoryFilters.length,
          itemBuilder: (context, index) {
            final filter = state.categoryFilters[index];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(
                  filter,
                  style: TextStyle(
                    color: state.selectedFilter == filter
                        ? Colors.white
                        : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                selected: state.selectedFilter == filter,
                selectedColor: Theme.of(context).primaryColor,
                backgroundColor: Theme.of(context).cardColor,
                onSelected: (bool selected) {
                  context.read<HomeCubit>().filterCategories(
                    _searchController.text,
                    categoryFilter: filter,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(HomeState state) {
    if (state is HomeLoading || state is HomeInitial) {
      return const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state is HomeError) {
      return SliverToBoxAdapter(child: Center(child: Text(state.message)));
    }
    if (state is HomeLoaded) {
      if (state.filteredCategories.isEmpty) {
        return SliverToBoxAdapter(
          child: Center(
            child: Text(
              'No categories found',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ),
        );
      }
      return SliverPadding(
        padding: const EdgeInsets.all(16),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) =>
                _buildCategoryCard(state.filteredCategories[index], index),
            childCount: state.filteredCategories.length,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16,
          ),
        ),
      );
    }
    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }

  Widget _buildCategoryCard(Category category, int index) {
    return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.category,
                arguments: category,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withAlpha(10),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.quiz,
                      size: 48,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    category.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .slideY(
          begin: 0.5,
          end: 0,
          duration: const Duration(milliseconds: 300),
          delay: Duration(milliseconds: 100 * index),
        )
        .fadeIn();
  }
}
