class ChatMessage {
  final String? text;
  final bool isUser;

  final String? specialty;
  final List<String>? doctors;
  final String? medicalAdvice;

  ChatMessage({
    this.text,
    required this.isUser,
    this.specialty,
    this.doctors,
    this.medicalAdvice,
  });
}
