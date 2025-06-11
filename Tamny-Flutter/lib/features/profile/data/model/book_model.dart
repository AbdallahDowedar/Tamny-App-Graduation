class BookingModel {
  final String id;
  final String status;
  final String date;
  final String startTime;
  final String endTime;
  final String day;
  final String patientName;
  final String patientEmail;

  BookingModel({
    required this.id,
    required this.status,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.day,
    required this.patientName,
    required this.patientEmail,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final schedule = json['scheduleId'];
    final slot = schedule['slots'][0];
    final patient = json['patientId'];

    return BookingModel(
      id: json['_id'],
      status: json['status'],
      date: schedule['date'],
      day: schedule['day'],
      startTime: slot['startTime'],
      endTime: slot['endTime'],
      patientName: patient['userName'],
      patientEmail: patient['email'],
    );
  }
}
