import 'package:flutter/foundation.dart';
import '../../domain/services/scanner_service.dart';
import '../../../ai_assistant/presentation/providers/ai_assistant_provider.dart';

class ScannerProvider with ChangeNotifier {
  final ScannerService _scannerService;
  final AIAssistantProvider _aiProvider;
  List<String> _scannedItems = [];
  bool _isScanning = false;
  String? _error;

  ScannerProvider(this._scannerService, this._aiProvider);

  List<String> get scannedItems => _scannedItems;
  bool get isScanning => _isScanning;
  String? get error => _error;

  Future<void> initialize() async {
    try {
      await _scannerService.initialize();
      _error = null;
    } catch (e) {
      _error = 'Ошибка инициализации камеры: $e';
    }
    notifyListeners();
  }

  Future<void> scanProducts() async {
    try {
      _isScanning = true;
      _error = null;
      notifyListeners();

      final items = await _scannerService.scanImage();
      _scannedItems = items;

      if (items.isNotEmpty) {
        // Получаем рекомендации рецептов на основе отсканированных продуктов
        await _aiProvider.suggestRecipes(items);
      }
    } catch (e) {
      _error = 'Ошибка сканирования: $e';
      _scannedItems = [];
    } finally {
      _isScanning = false;
      notifyListeners();
    }
  }

  Future<void> addManualItem(String item) async {
    if (item.isNotEmpty && !_scannedItems.contains(item)) {
      _scannedItems.add(item);
      notifyListeners();
    }
  }

  void removeItem(String item) {
    _scannedItems.remove(item);
    notifyListeners();
  }

  void clearItems() {
    _scannedItems.clear();
    notifyListeners();
  }

  Future<void> getRecipeRecommendations() async {
    if (_scannedItems.isNotEmpty) {
      await _aiProvider.suggestRecipes(_scannedItems);
    }
  }

  void dispose() {
    _scannerService.dispose();
    super.dispose();
  }
}
