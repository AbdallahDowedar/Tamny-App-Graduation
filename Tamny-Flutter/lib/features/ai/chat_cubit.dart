import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/utils/app_texts.dart';
import 'chat_model.dart';
import 'chat_state.dart';


class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  List<ChatMessage> messages = [];

  Future<void> sendMessage(String symptom) async {
    messages.add(ChatMessage(text: symptom, isUser: true));
    emit(ChatUpdated(messages: List.from(messages)));

    try {
      final response = await http.post(
        Uri.parse('${AppTexts.baseurl}/ai'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userSymptoms': symptom}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final specialty = data['specialty'];
        final doctors = (data['doctors'] as List).join('\n- ');
        final massage = data['medicalAdvice'];

        final reply =
            'التخصص المناسب: $specialty\n\nالأطباء:\n- $doctors \n $massage';

        messages.add(ChatMessage(text: reply, isUser: false));
        emit(ChatUpdated(messages: List.from(messages)));
      } else {
        messages.add(ChatMessage(text: 'فشل الاتصال بالسيرفر', isUser: false));
        emit(ChatUpdated(messages: List.from(messages)));
      }
    } catch (e) {
      messages.add(ChatMessage(text: 'حدث خطأ: $e', isUser: false));
      emit(ChatUpdated(messages: List.from(messages)));
    }
  }
}
