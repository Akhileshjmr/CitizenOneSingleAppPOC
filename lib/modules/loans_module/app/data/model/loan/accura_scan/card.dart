///
class Card {
  ///
  Card({
    this.name,
    this.id,
    this.type,
  });

  ///
  factory Card.fromJson(Map<String, dynamic> json) => Card(
    name: json['name'],
    id: json['id'],
    type: json['type'],
  );

  ///
  dynamic name;

  ///
  dynamic id;

  ///
  dynamic type;

  ///
  Map<String, dynamic> toJson() => {
    'name': name,
    'id': id,
    'type': type,
  };
}
