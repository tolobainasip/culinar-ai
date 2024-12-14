import 'package:flutter/material.dart';

class MealPlannerPage extends StatelessWidget {
  const MealPlannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Планировщик питания'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildWeekCalendar(),
          const SizedBox(height: 16),
          _buildDailyMeals(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Добавить новый план питания
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildWeekCalendar() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'План на неделю',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                itemBuilder: (context, index) {
                  return Card(
                    child: SizedBox(
                      width: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getDayName(index),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text('0 блюд'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyMeals() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Сегодня',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildMealTime('Завтрак', '8:00'),
            _buildMealTime('Обед', '13:00'),
            _buildMealTime('Ужин', '19:00'),
          ],
        ),
      ),
    );
  }

  Widget _buildMealTime(String mealName, String time) {
    return ListTile(
      leading: const Icon(Icons.restaurant),
      title: Text(mealName),
      subtitle: Text(time),
      trailing: IconButton(
        icon: const Icon(Icons.add_circle_outline),
        onPressed: () {
          // Добавить блюдо
        },
      ),
    );
  }

  String _getDayName(int index) {
    final days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return days[index];
  }
}
