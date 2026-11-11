import 'card.dart';

///
class SdkCountry {

  ///
  SdkCountry({
    this.name,
    this.id,
    this.cards,
  });

  ///
  factory SdkCountry.fromJson(Map<String, dynamic> json) => SdkCountry(
        name: json['name'],
        id: json['id'],
        cards: json['cards'] == null
            ? []
            : List<Card>.from(json['cards']!.map((x) => Card.fromJson(x))),
      );

  ///
  String? name;

  ///
  dynamic id;

  ///
  List<Card>? cards;

  ///
  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'cards': cards == null
            ? []
            : List<dynamic>.from(cards!.map((x) => x.toJson())),
      };
}
