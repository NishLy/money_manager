enum TranscationType {
  income,
  expense,
}

enum Category {
  food,
  travel,
  shopping,
  medical,
  education,
  salary,
  entertainment,
  others,
}

class TranscationModel {
  final int? id;
  final String title;
  final double amount;
  final String transcationType;
  final DateTime date;
  final String category;

  TranscationModel({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.transcationType,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'transcation_type': transcationType.toString(),
      'category': category.toString(),
    };
  }

  factory TranscationModel.fromMap(Map<String, dynamic> map) {
    return TranscationModel(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      transcationType: map['transcation_type'],
      category: map['category'],
    );
  }
}
