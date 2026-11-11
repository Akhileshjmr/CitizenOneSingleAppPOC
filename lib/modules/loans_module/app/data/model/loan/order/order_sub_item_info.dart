
class OrderSubItemsInfo {
  final int? id;
  final String? image;
  final String? name;
  final String? status;

  OrderSubItemsInfo({
    this.id,
    this.image,
    this.name,
    this.status,
  });

  factory OrderSubItemsInfo.fromJson(Map<String, dynamic> json) =>
      OrderSubItemsInfo(
        id: json['id'],
        image: json['image'],
        name: json['name'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
        'name': name,
        'status': status,
      };
}
