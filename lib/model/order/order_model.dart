// lib/model/order/order_model.dart

class OrderModel {
  final String customer;
  final String phone;
  final String address;
  final String item;
  final String price;
  final String dateTime;
  final String transactionId;

  OrderModel({
    required this.customer,
    required this.phone,
    required this.address,
    required this.item,
    required this.price,
    required this.dateTime,
    required this.transactionId,
  });

  /// Firestore document se convert karne ke liye
  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      customer: map['customer'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      item: map['item'] ?? '',
      price: map['price'] ?? '',
      dateTime: map['date time'] ?? '',
      transactionId: map['transactionId'] ?? '',
    );
  }

  /// Firestore me save karne ke liye map
  Map<String, dynamic> toMap() {
    return {
      'customer': customer,
      'phone': phone,
      'address': address,
      'item': item,
      'price': price,
      'date time': dateTime,
      'transactionId': transactionId,
    };
  }
}
