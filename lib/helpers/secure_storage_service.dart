import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:intl/intl.dart';

class SecureStorageManager {
  static const _storage = FlutterSecureStorage();
  static final key = encrypt.Key.fromUtf8(dotenv.env["SECRET_KEY"]!);
  static final iv = encrypt.IV.fromBase64(dotenv.env["SALT"]!);
  static final encrypter = encrypt.Encrypter(encrypt.AES(key));

  static Future<void> saveToken(String token) async {
    final encryptedToken = encrypter.encrypt(token, iv: iv);
    await _storage.write(key: 'authToken', value: encryptedToken.base64);

    /// Get the current DateTime
    DateTime currentDateTime = DateTime.now();

    /// Format the current DateTime as a string
    String formattedDateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(currentDateTime);
    await saveData("timestamp", formattedDateTime);
  }

  static Future<String?> readData(String key) async {
    final data = await _storage.read(key: key);
    return data;
  }

  static saveData(String key, String val) async {
    await _storage.write(key: key, value: val);
  }

  static Future<String?> getToken() async {
    final encryptedToken = await _storage.read(key: 'authToken');

    if (encryptedToken == null) return null;
    final decryptedToken =
        encrypter.decrypt(encrypt.Encrypted.fromBase64(encryptedToken), iv: iv);
    return decryptedToken;
  }

  static deleteParticularData(String key) async {
    await _storage.delete(key: key);
  }

  static deleteAllData() async {
    await _storage.deleteAll();
  }
}
