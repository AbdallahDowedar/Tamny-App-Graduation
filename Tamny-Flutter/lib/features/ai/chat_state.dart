
import 'chat_model.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatUpdated extends ChatState {
  final List<ChatMessage> messages;

  ChatUpdated({required this.messages});
}
