import 'dart:convert';

import 'package:expenses/models/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Transaction', () {
    test('A transação deve ser transformada em Map', () {
      final Transaction transaction = Transaction(
          id: DateTime.now().toString(),
          title: 'Teste',
          amount: 299.99,
          date: DateTime.now());
      final map = transaction.toJson();
      expect(map.runtimeType.toString(), "_Map<String, dynamic>");
    });

    test('O JSON deve ser transformado em transaction', () {
      const _json = """
    {
      "amount": 499.99,
      "date": "2022-05-23",
      "id": "2022-05-25 18:01:00",
      "title": "teste 2"
    }  
""";
      Map<String, dynamic> obj = json.decode(_json);
      final Transaction transaction = Transaction.fromJson(obj);
      expect(transaction.runtimeType.toString(), "Transaction");
    });

    test('A lista em JSON deve ser transformada em uma lista de transações',
        () {
      const String _json = """

   {
    "20220524": {
      "amount": 499.99,
      "date": "2022-05-23",
      "id": "2022-05-25 18:01:00",
      "title": "teste 2"
    },
    "20220525": {
      "amount": 299.99,
      "date": "2022-05-24",
      "id": "2022-05-25 18:00:00",
      "title": "teste"
    },
    "-NWNTC4xX67oD5CkOEZt": {
      "amount": 199.99,
      "date": "2023-05-22 00:00:00.000",
      "title": "teste 3"
    },
    "-NWNYfFBWha4bxPT5EST": {
      "amount": 195.99,
      "date": "2023-05-19 00:00:00.000",
      "location": "-22.7716996 : -43.4337254",
      "title": "teste 4"
    },
    "-NWNuEHfhWfosPoIbfvc": {
      "amount": "300.00",
      "date": "2023-05-25 00:00:00.000",
      "location": "-22.7738722 : -43.4281863",
      "title": "teste 5"
    },
    "-NWNwf_Wad5ejB6foiV0": {
      "amount": 400,
      "date": "2023-05-19 00:00:00.000",
      "location": "-22.7738733 : -43.428181",
      "title": "teste 6"
    },
    "-NWNxbVJC_LIRQykp4ZU": {
      "amount": 200,
      "date": "2023-05-21 00:00:00.000",
      "location": "-22.773873 : -43.4281794",
      "title": "teste 7"
    },
    "-NWO0S_hm6wRzuQdweaI": {
      "amount": 600,
      "date": "2023-05-23 00:00:00.000",
      "location": "-22.7738767 : -43.4281812",
      "title": "teste 8"
    },
    "-NWO1GZqMOLkG3OaHxm4": {
      "amount": 300,
      "date": "2023-05-26 00:00:00.000",
      "location": "-22.773871 : -43.4281887",
      "title": "teste 9"
    },
    "-NWqVH8zq2zAAV5r_xfu": {
      "amount": 299,
      "date": "2023-05-31 00:00:00.000",
      "location": "",
      "title": "teste 10"
    },
    "-NXKWv81sCwZjHNqi7zM": {
      "amount": 369,
      "date": "2023-06-07 00:00:00.000",
      "imageUrl": "transactions/2023-06-07 08:04:37.218232",
      "location": "-22.7738896 : -43.4281707",
      "title": "teste 11"
    },
    "-NXMrH9eSs-H5FFME6Lf": {
      "amount": 222,
      "date": "2023-06-07 00:00:00.000",
      "imageUrl": "transactions/2023-06-07 18:57:10.882653",
      "location": "-22.7738693 : -43.4281817",
      "title": "teste 12"
    },
    "-NXMriSm6heGJt7DVsc-": {
      "amount": 365,
      "date": "2023-06-06 00:00:00.000",
      "location": "-22.773871 : -43.4281842",
      "title": "teste 13"
    },
    "-NXMs02S48DnjY5tinYG": {
      "amount": 258,
      "date": "2023-06-07 00:00:00.000",
      "location": "-22.7738734 : -43.4281847",
      "title": "teste 14"
    },
    "-NXMtDEvN9X7HoKW9I7M": {
      "amount": 123,
      "date": "2023-06-07 00:00:00.000",
      "location": "-22.7738729 : -43.4281864",
      "title": "teste 15"
    },
    "-NXj5vNfUDIStpMOc2Sr": {
      "amount": 333,
      "date": "2023-06-12 00:00:00.000",
      "location": "-22.7738763 : -43.4281621",
      "title": "teste 17"
    }
  }

""";

      final Map<String, dynamic> objeto = jsonDecode(_json);
      final List<Transaction> lista = Transaction.listFromJson(objeto);
      expect(lista.runtimeType.toString(), "List<Transaction>");


    });


  });
}
