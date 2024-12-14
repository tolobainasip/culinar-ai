import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import '../providers/scanner_provider.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScannerProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сканер продуктов'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () => context.read<ScannerProvider>().clearItems(),
          ),
        ],
      ),
      body: Consumer<ScannerProvider>(
        builder: (context, provider, child) {
          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }

          return Column(
            children: [
              Expanded(
                flex: 2,
                child: _buildCameraPreview(context),
              ),
              Expanded(
                flex: 1,
                child: _buildScannedItemsList(context),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<ScannerProvider>().scanProducts(),
        child: const Icon(Icons.camera),
      ),
    );
  }

  Widget _buildCameraPreview(BuildContext context) {
    final controller = context.read<ScannerProvider>()._scannerService.cameraController;
    
    if (controller == null || !controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }

  Widget _buildScannedItemsList(BuildContext context) {
    final provider = context.watch<ScannerProvider>();
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Найденные продукты',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Expanded(
          child: provider.isScanning
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: provider.scannedItems.length,
                  itemBuilder: (context, index) {
                    final item = provider.scannedItems[index];
                    return ListTile(
                      title: Text(item),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => provider.removeItem(item),
                      ),
                    );
                  },
                ),
        ),
        if (provider.scannedItems.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => provider.getRecipeRecommendations(),
              child: const Text('Получить рекомендации рецептов'),
            ),
          ),
      ],
    );
  }
}
