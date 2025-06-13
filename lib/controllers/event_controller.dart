import 'package:get/get.dart';

import '../model/event.dart';
import '../services/api_services.dart';

class EventController extends GetxController {
  final RxList<Event> eventList = <Event>[].obs;
  final RxBool isEventLoading = false.obs;

  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    fetchEvents();
    super.onInit();
  }

  void fetchEvents() async {
    isEventLoading.value = true;
    try {
      eventList.value = await _apiService.fetchEvents();
    } catch (error) {
      print("Error fetching events: $error");
    } finally {
      isEventLoading.value = false;
    }
  }
}
