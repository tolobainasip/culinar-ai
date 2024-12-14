import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import '../widgets/recipe_card.dart';
import '../widgets/recipe_filters.dart';
import 'recipe_details_page.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  final _searchController = TextEditingController();
  List<String> _selectedCategories = [];
  List<String> _selectedDietaryTags = [];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRecipes() async {
    await context.read<RecipeProvider>().loadRecipes(
          query: _searchController.text,
          categories: _selectedCategories.isEmpty ? null : _selectedCategories,
          dietaryTags: _selectedDietaryTags.isEmpty ? null : _selectedDietaryTags,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Рецепты'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => RecipeFilters(
                  selectedCategories: _selectedCategories,
                  selectedDietaryTags: _selectedDietaryTags,
                  onApply: (categories, tags) {
                    setState(() {
                      _selectedCategories = categories;
                      _selectedDietaryTags = tags;
                    });
                    _loadRecipes();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск рецептов...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                _loadRecipes();
              },
            ),
          ),
          Expanded(
            child: Consumer<RecipeProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.error != null) {
                  return Center(
                    child: Text(
                      'Ошибка: ${provider.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (provider.recipes.isEmpty) {
                  return const Center(
                    child: Text('Рецепты не найдены'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = provider.recipes[index];
                    return RecipeCard(
                      recipe: recipe,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailsPage(
                              recipeId: recipe.id,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Навигация к странице создания рецепта
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
