final String tableWorkRecord = 'workRecord';

class WorkRecordFields{
  static final List<String> values = [
    id, title , description , checkoutDate , date , checkInType
  ];


  static final String id = "_id";
  static final String title = "title";
  static final String description = "description";
  static final String checkoutDate = "checkoutDate";
  static final String date = "date";
  static final String checkInType = "checkinType";
}

class WorkRecord{
  final int? id;
  late final String title;
  late final String description;
  final DateTime? checkoutDate;
  final DateTime? date;
  final String checkInType;


  WorkRecord({
    this.id,
    required this.description,
    required this.checkInType,
    this.checkoutDate,
    this.date,
    required this.title
  });

  WorkRecord copy({
    int? id,
    String? title,
    String? description,
    // DateTime? checkoutDate,
    // DateTime? date,
    String? checkInType,
  }) => WorkRecord(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    // checkoutDate: checkoutDate ?? this.checkoutDate,
    // date: date ?? this.date,
    checkInType: checkInType ?? this.checkInType
  );

  static WorkRecord fromJson(Map<String,dynamic> json) => WorkRecord(
    id: json[WorkRecordFields.id] as int?,
    title: json[WorkRecordFields.title] as String,
    description: json[WorkRecordFields.description] as String,
    checkInType: json[WorkRecordFields.checkInType] as String,
    //date: DateTime.parse([WorkRecordFields.date] as String),
    //checkoutDate: DateTime.parse([WorkRecordFields.checkoutDate] as String),
    
  );

  Map<String,dynamic?> toJson() => {
    WorkRecordFields.id: id,
    WorkRecordFields.title: title,
    WorkRecordFields.description: description,
    WorkRecordFields.checkoutDate: checkoutDate?.toIso8601String(),
    WorkRecordFields.date: date?.toIso8601String(),
    WorkRecordFields.checkInType: checkInType
  };
}