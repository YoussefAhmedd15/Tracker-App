class RealtimeWeightRecordModel {
  final String? id;
  final String userId;
  final double weight;
  final String? notes;
  final int date;
  final int timestamp;

  RealtimeWeightRecordModel({
    this.id,
    required this.userId,
    required this.weight,
    this.notes,
    required this.date,
    required this.timestamp,
  });

  // Convert from Realtime Database data
  factory RealtimeWeightRecordModel.fromRealtime(
      String recordId, Map<dynamic, dynamic> data) {
    return RealtimeWeightRecordModel(
      id: recordId,
      userId: data['userId'] ?? '',
      weight: data['weight'] != null ? (data['weight'] as num).toDouble() : 0.0,
      notes: data['notes'],
      date: data['date'] ?? 0,
      timestamp: data['timestamp'] ?? 0,
    );
  }

  // Convert to Realtime Database data
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'userId': userId,
      'weight': weight,
      'date': date,
    };

    if (notes != null) {
      map['notes'] = notes;
    }

    return map;
  }
}
