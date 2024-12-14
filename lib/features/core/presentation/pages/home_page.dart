import 'package:flutter/material.dart';
import '../../../ai/presentation/pages/ai_assistant_page.dart';
import '../../../recipes/presentation/pages/recipes_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../planner/presentation/pages/meal_planner_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  
  final List<Widget> _pages = [
    const RecipesPage(),
    const AIAssistantPage(),
    const MealPlannerPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu),
            label: 'Рецепты',
          ),
          NavigationDestination(
            icon: Icon(Icons.assistant),
            label: 'Ассистент',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today),
            label: 'Планировщик',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}
