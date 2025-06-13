import 'package:dio/dio.dart';

import '../model/event.dart';

class ApiService {
  final Dio _dioClient = Dio();
  final String _baseApiUrl = "https://6847d529ec44b9f3493e5f06.mockapi.io/api/v1/events";

  Future<List<Event>> fetchEvents() async {
    try {
      final apiResponse = await _dioClient.get(_baseApiUrl);
      if (apiResponse.statusCode == 200 && apiResponse.data is List) {
        return (apiResponse.data as List)
            .map((eventData) => Event.fromJson(eventData as Map<String, dynamic>))
            .toList();
      } else {
        print("Unexpected response: ${apiResponse.data}");
        return [];
      }
    } catch (error) {
      print("API error: $error");
      return [];
    }
  }
}
