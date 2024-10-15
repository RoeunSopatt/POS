import 'package:mobile/entity/model/cashier.dart';
import 'package:mobile/entity/model/detail.dart';

class Transaction {
  int? id;
  int? receiptNumber;
  int? cashierId;
  double? totalPrice;
  double? totalReceived;
  String? orderedAt;
  Cashier? cashier;
  List<Details>? details;

  Transaction({
    this.id,
    this.receiptNumber,
    this.cashierId,
    this.totalPrice,
    this.totalReceived,
    this.orderedAt,
    this.cashier,
    this.details,
  });

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? int.tryParse(json['id'].toString()) : null;
    receiptNumber = json['receipt_number'] != null
        ? int.tryParse(json['receipt_number'].toString())
        : null;
    cashierId = json['cashier_id'] != null
        ? int.tryParse(json['cashier_id'].toString())
        : null;
    totalPrice = json['total_price'] != null
        ? double.tryParse(json['total_price'].toString())
        : 0.0;
    orderedAt = json['ordered_at'];
    cashier =
        json['cashier'] != null ? Cashier.fromJson(json['cashier']) : null;
    if (json['details'] != null) {
      details =
          List<Details>.from(json['details'].map((x) => Details.fromJson(x)));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['receipt_number'] = receiptNumber;
    data['cashier_id'] = cashierId;
    data['total_price'] = totalPrice;
    data['total_received'] = totalReceived;
    data['ordered_at'] = orderedAt;
    if (cashier != null) data['cashier'] = cashier!.toJson();
    if (details != null) {
      data['details'] = details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
