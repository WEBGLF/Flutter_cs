import 'package:encrypt/encrypt.dart';
import 'package:encrypt_shared_preferences/provider.dart';
import 'package:Rupee_Rush/utils/Config.dart';
import 'package:get/get.dart';

class Storage extends GetxService {
  late EncryptedSharedPreferences _prefs;

  static Storage get to => Get.find();

  Future<Storage> init(String key) async {
    await EncryptedSharedPreferences.initialize(key);
    _prefs = EncryptedSharedPreferences.getInstance();
    return this;
  }

  // 设置token
  Future<bool> setToken(String token) =>
      _prefs.setString(Utils.storageToken, token);
  //得到token
  String? getToken() => _prefs.getString(Utils.storageToken);
  //清除token
  Future<bool> clearToken() => _prefs.remove(Utils.storageToken);

  // 清除所有数据
  Future<bool> clearAll() => _prefs.clear();

  static Future<Storage> registerWithKey(String encryptionKey) async {
    Get.put<Storage>(await Storage().init(encryptionKey));
    return to;
  }
}
