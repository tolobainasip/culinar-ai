import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';

class RecipeFilters extends StatefulWidget {
  final List<String> selectedCategories;
  final List<String> selectedDietaryTags;
  final void Function(List<String> categories, List<String> tags) onApply;

  const RecipeFilters({
    super.key,
    required this.selectedCategories,
    required this.selectedDietaryTags,
    required this.onApply,
  });

  @override
  State<RecipeFilters> createState() => _RecipeFiltersState();
}

class _RecipeFiltersState extends State<RecipeFilters> {
  late List<String> _selectedCategories;
  late List<String> _selectedDietaryTags;

  @override
  void initState() {
    super.initState();
    _selectedCategories = List.from(widget.selectedCategories);
    _selectedDietaryTags = List.from(widget.selectedDietaryTags);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipeProvider>();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Фильтры',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Категории',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: provider.categories.map((category) {
              return FilterChip(
                label: Text(category),
                selected: _selectedCategories.contains(category),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedCategories.add(category);
                    } else {
                      _selectedCategories.remove(category);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            'Диетические предпочтения',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: provider.dietaryTags.map((tag) {
              return FilterChip(
                label: Text(tag),
                selected: _selectedDietaryTags.contains(tag),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedDietaryTags.add(tag);
                    } else {
                      _selectedDietaryTags.remove(tag);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedCategories.clear();
                    _selectedDietaryTags.clear();
                  });
                },
                child: const Text('Сбросить'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  widget.onApply(_selectedCategories, _selectedDietaryTags);
                  Navigator.pop(context);
                },
                child: const Text('Применить'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
