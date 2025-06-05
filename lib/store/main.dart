// lib/controller/app_data_controller.dart
import 'package:get/get.dart';

class AppDataController extends GetxController {
  var counter = 0.obs;

  void incrementCounter() {
    counter.value++;
  }
}
