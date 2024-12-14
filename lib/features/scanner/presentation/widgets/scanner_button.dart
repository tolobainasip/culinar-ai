import 'package:flutter/material.dart';

class ScannerButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isSelected;

  const ScannerButton({
    Key? key,
    required this.onPressed,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.document_scanner_outlined,
        color: isSelected
            ? Theme.of(context).primaryColor
            : Theme.of(context).unselectedWidgetColor,
        size: 28,
      ),
      onPressed: onPressed,
      tooltip: 'Сканировать продукты',
    );
  }
}
