class Transaction {
  String id;
  String title;
  double amount;
  DateTime date;
  String? location;
  String? imageUrl;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    this.location,
    this.imageUrl
  });

  Transaction.fromJson(Map<String, dynamic> json): 
    id = json['id'],
    title = json['title'],
    amount = double.parse(json['amount'].toString()),
    date = DateTime.parse(json['date']),
    location = json['location'],
    imageUrl = json['imageUrl'];


  // TransacionABC.toJSON()
  Map<String, dynamic> toJson() => {
    'title' : title,
    'amount' : amount,
    'date' : date.toString(),
    'location' : location,
    'imageUrl' : imageUrl
  };

  static List<Transaction> listFromJson(Map<String, dynamic> json) {
    List<Transaction> transactions = [];
    json.forEach((key, value) {
      Map<String, dynamic> item = {"id" : key, ...value};
      transactions.add(Transaction.fromJson(item));
    });
    return transactions;
  }



}