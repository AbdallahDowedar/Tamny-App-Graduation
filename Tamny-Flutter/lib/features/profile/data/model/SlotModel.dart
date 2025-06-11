class SlotModel {
  final String startTime;
  final String endTime;
  final bool isBooked;

  SlotModel({
    required this.startTime,
    required this.endTime,
    required this.isBooked,
  });

  factory SlotModel.fromJson(Map<String, dynamic> json) {
    return SlotModel(
      startTime: json['startTime'],
      endTime: json['endTime'],
      isBooked: json['isBooked'],
    );
  }
}

class DaySlotsModel {
  final String doctorId;
  final String day;
  final String date;
  final List<SlotModel> slots;

  DaySlotsModel({
    required this.doctorId,
    required this.day,
    required this.date,
    required this.slots,
  });

  factory DaySlotsModel.fromJson(Map<String, dynamic> json) {
    return DaySlotsModel(
      doctorId: json['doctorId'],
      day: json['day'],
      date: json['date'],
      slots: List<SlotModel>.from(
        json['slots'].map((slot) => SlotModel.fromJson(slot)),
      ),
    );
  }
}
