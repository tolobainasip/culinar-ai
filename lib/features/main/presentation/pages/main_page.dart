import 'package:flutter/material.dart';
import '../../../ai_assistant/presentation/pages/ai_assistant_page.dart';
import '../../../scanner/presentation/pages/scanner_page.dart';
import '../../../scanner/presentation/widgets/scanner_button.dart';
import '../../../voice/presentation/widgets/voice_control_button.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const AIAssistantPage(),
    const ScannerPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.chat_bubble_outline,
                color: _selectedIndex == 0
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).unselectedWidgetColor,
              ),
              onPressed: () => _onItemTapped(0),
              tooltip: 'AI Ассистент',
            ),
            ScannerButton(
              onPressed: () => _onItemTapped(1),
              isSelected: _selectedIndex == 1,
            ),
            VoiceControlButton(
              onPressed: () {
                // Обработка голосового управления
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
