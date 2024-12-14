import 'dart:io';
import 'package:camera/camera.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:path_provider/path_provider.dart';

class ScannerService {
  CameraController? _cameraController;
  final ImageLabeler _imageLabeler = ImageLabeler(options: ImageLabelerOptions());
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (!_isInitialized) {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController?.initialize();
      _isInitialized = true;
    }
  }

  Future<List<String>> scanImage() async {
    if (!_isInitialized || _cameraController == null) {
      throw Exception('Scanner not initialized');
    }

    try {
      // Захват изображения
      final XFile? image = await _cameraController?.takePicture();
      if (image == null) return [];

      // Конвертация изображения для ML Kit
      final inputImage = InputImage.fromFilePath(image.path);
      
      // Распознавание объектов на изображении
      final List<ImageLabel> labels = await _imageLabeler.processImage(inputImage);
      
      // Фильтрация и обработка результатов
      final List<String> foodItems = labels
          .where((label) => _isFoodItem(label.label))
          .map((label) => label.label)
          .toList();

      // Удаление временного файла
      await File(image.path).delete();

      return foodItems;
    } catch (e) {
      print('Error scanning image: $e');
      return [];
    }
  }

  bool _isFoodItem(String label) {
    // Список категорий продуктов
    final foodCategories = {
      'fruit',
      'vegetable',
      'meat',
      'fish',
      'dairy',
      'bread',
      'beverage',
      'food',
      'ingredient',
    };

    return foodCategories.any((category) =>
        label.toLowerCase().contains(category));
  }

  CameraController? get cameraController => _cameraController;

  Future<void> dispose() async {
    await _cameraController?.dispose();
    await _imageLabeler.close();
  }
}
