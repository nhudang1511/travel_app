
class CardModel {
  final String? name;
  final String? number;
  final String? expDate;
  final String? cvv;
  final String? country;

  CardModel(
      {
       this.name,
      this.number,
      this.expDate,
      this.cvv, this.country});

  static CardModel fromDocument(Map<String, dynamic> doc) {
    return CardModel(
        name: doc['name'] as String?,
        number: doc['number'] as String?,
        expDate: doc['expDate'] as String?,
        cvv: doc['cvv'] as String?,
        country: doc['country'] as String?);
  }

  Map<String, dynamic> toDocument() {
   return {
     'name':name,
     'number':number,
     'expDate': expDate,
     'cvv': cvv,
     'country': country
   };
  }
}

enum CardType {
  MasterCard,
  Visa,
  Verve,
  Others, // Any other card issuer
  Invalid // We'll use this when the card is invalid
}
