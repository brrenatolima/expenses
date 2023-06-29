import 'dart:io';

import 'package:expenses/models/transaction.dart';
import 'package:expenses/routes/routes_paths.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/transactions_service.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> items = [];
  var service = TransactionsService();

  Future<List<Transaction>> list() async {
    if (items.isEmpty) {
      items = await TransactionsService().list();
    }
    return items;
  }

  void deleteTransaction(String id) async {
    if (items.length == 0 || items.isEmpty) {
      items = await list();
    }
    
    TransactionsService transactionsService = TransactionsService();
    transactionsService.delete(id).then((value) {
      items.removeWhere((element) => element.id == id);
      notifyListeners();
    });
    
  }

  void addTransaction(Transaction transaction, File? image) {
    final firebaseStorage = FirebaseStorage.instance;
    transaction.id = DateTime.now().toString();
    if (image != null) {
      // firebaseStorage.ref("transactions/${transaction.id}");
      transaction.imageUrl = "transactions/${transaction.id}";
    }
    service.insert(transaction).then((value) {
      items.add(transaction);

      if (image != null) {
        
        final reference = firebaseStorage.ref("transactions/${transaction.id}");
        final upload = reference.putFile(image);
        upload.whenComplete(() {
          print("Upload realizado com sucesso.");
          });
      }

      notifyListeners();
    });

    
  }

  void editTransaction(String id, Transaction transaction, File? image) {
    final firebaseStorage = FirebaseStorage.instance;
    if (image != null) {
      // firebaseStorage.ref("transactions/${transaction.id}");
      transaction.imageUrl = "transactions/${transaction.id}";
    }
    service.update(id, transaction);
    if (image != null) {
        
        final reference = firebaseStorage.ref("transactions/${transaction.id}");
        final upload = reference.putFile(image);
        upload.whenComplete(() {
          print("Upload realizado com sucesso.");
          });
      }
    items.removeWhere((element) => element.id == id);
    items.add(transaction);

    notifyListeners();
  }

  int totalTransactions() => items.length;
}
