import 'dart:convert';
import 'package:doctor/core/utils/app_texts.dart';
import 'package:http/http.dart' as http;

import '../model/SlotModel.dart';

class ScheduleRepo {
  Future<List<DaySlotsModel>> setSchedule({
    required String doctorId,
    required int sessionDuration,
    required String day,
    required String startTime,
    required String endTime,
  }) async {
    final url = Uri.parse("${AppTexts.baseurl}/doctor/schedule/set-schedule");

    final body = jsonEncode({
      "doctorId": doctorId,
      "workingDays": [
        {
          "day": day,
          "slots": [
            {
              "startTime": startTime,
              "endTime": endTime,

            }
          ]
        }
      ],
      "sessionDuration": sessionDuration,
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data['message'] == 'done') {
        return List<DaySlotsModel>.from(
          data['slots'].map((e) => DaySlotsModel.fromJson(e)),
        );
      } else {
        throw Exception(data['message'] ?? 'Unknown error');
      }
    } else {
      throw Exception("Error ${response.statusCode}: ${response.body}");
    }

  }
}



