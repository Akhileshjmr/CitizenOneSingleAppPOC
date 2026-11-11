///
class ChatOrderItemModel {
  factory ChatOrderItemModel.fromJson(Map<String, dynamic> json) =>
      ChatOrderItemModel(
        productName: json['productName'] ?? '',
        imgUrl: json['imgUrl'] ?? '',
        status: json['status'] ?? '',
        orderId: json['orderId'] ?? '',
      );

  ///
  ChatOrderItemModel({
    required this.productName,
    required this.imgUrl,
    required this.status,
    required this.orderId,
  });

  ///
  final String productName;

  ///
  final String imgUrl;

  ///
  final String status;

  ///
  final String orderId;

  Map<String, dynamic> toJson() => {
        'productName': productName,
        'imgUrl': imgUrl,
        'status': status,
        'orderId': orderId,
      };
}
