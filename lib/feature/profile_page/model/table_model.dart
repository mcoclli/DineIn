import 'package:uuid/uuid.dart';

class TableModel {
  String id;
  String? ref;
  bool? allowManualSize;
  bool? canExtend;
  int? occupancy;
  String? description;

  TableModel({
    id,
    this.ref,
    this.allowManualSize,
    this.canExtend,
    this.occupancy,
    this.description,
  }) : id = id ?? const Uuid().v4().toString();

  factory TableModel.fromMap(map) {
    return TableModel(
      id: map['id'],
      ref: map['ref'],
      allowManualSize: map['allowManualSize'],
      canExtend: map['canExtend'],
      occupancy: map['occupancy'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ref': ref,
      'allowManualSize': allowManualSize,
      'canExtend': canExtend,
      'occupancy': occupancy,
      'description': description,
    };
  }
}
