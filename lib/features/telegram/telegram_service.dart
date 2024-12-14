import 'dart:html' as html;
import 'dart:js' as js;

class TelegramService {
  static final TelegramService _instance = TelegramService._internal();
  factory TelegramService() => _instance;
  TelegramService._internal();

  bool get isTelegramWebApp => js.context.hasProperty('Telegram') && 
                              js.context['Telegram'].hasProperty('WebApp');

  void initTelegramApp() {
    if (!isTelegramWebApp) return;

    // Установка темы
    js.context['Telegram']['WebApp'].callMethod('setBackgroundColor', ['#13171C']);
    js.context['Telegram']['WebApp'].callMethod('ready', []);
    
    // Включение главной кнопки
    final mainButton = js.context['Telegram']['WebApp']['MainButton'];
    mainButton.callMethod('setText', ['Начать']);
    mainButton.callMethod('show', []);
  }

  Map<String, dynamic>? getTelegramUser() {
    if (!isTelegramWebApp) return null;

    final initData = js.context['Telegram']['WebApp']['initDataUnsafe'];
    if (initData == null || !initData.hasProperty('user')) return null;

    final user = initData['user'];
    return {
      'id': user['id']?.toString(),
      'firstName': user['first_name'],
      'lastName': user['last_name'],
      'username': user['username'],
      'languageCode': user['language_code'],
    };
  }

  void showAlert(String message) {
    if (!isTelegramWebApp) return;
    js.context['Telegram']['WebApp'].callMethod('showAlert', [message]);
  }

  void close() {
    if (!isTelegramWebApp) return;
    js.context['Telegram']['WebApp'].callMethod('close', []);
  }

  void expandApp() {
    if (!isTelegramWebApp) return;
    js.context['Telegram']['WebApp'].callMethod('expand', []);
  }
}
