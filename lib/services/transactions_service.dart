import 'dart:convert';

import 'package:expenses/models/transaction.dart';
import 'package:http/http.dart';

import '../repositories/transactions_repository.dart';

class TransactionsService {
  final TransactionsRepository _transactionsRepository = TransactionsRepository();

  Future<List<Transaction>> list() async {
    try {
      Response response = await _transactionsRepository.list();
      
      if (response.statusCode == 200){
        Map<String, dynamic> json = jsonDecode(response.body);
        return Transaction.listFromJson(json);
      }
      return [];
    } catch (e) {
      print (e);
      throw Exception('Problemas ao consultar lista. ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> insert(Transaction transaction) async {
    try {
      String json = jsonEncode(transaction.toJson());
      Response response = await _transactionsRepository.insert(json);
      Map<String, dynamic> retorno = jsonDecode(response.body);
      //retorno.map((key, value) {return value;});
      return retorno;
    } catch (e) {
      throw Exception("Problemas ao inserir - ${e.toString()}");
    }
  }

  Future<bool> delete (String id) async {
    try {
      Response response = await _transactionsRepository.delete(id);
      return response.statusCode == 200;
      //return jsonDecode(response.body) as String;
    } catch (e) {
      throw Exception("Erro ao deletar registro! ${e.toString()}");
    }
  }

  Future<bool> update (String id, Transaction transaction) async {
    try {
      String json = jsonEncode(transaction.toJson());
      Response response = await _transactionsRepository.update(id, json);
      return response.statusCode == 200;
      //return jsonDecode(response.body) as String;
    } catch (e) {
      throw Exception("Erro ao atualizar registro! ${e.toString()}");
    }
  }

  Future<Transaction?> show(String id) async {
    try {
      Response response = await _transactionsRepository.show(id);
      //String json = jsonEncode(response.body);
      if (response.statusCode == 200){
        Map<String, dynamic> json = jsonDecode(response.body);
        return Transaction.listFromJson(json).first;
      }
      return null;
      //return jsonDecode(response.body) as String;
    } catch (e) {
      throw Exception("Erro ao obter registro! ${e.toString()}");
    }
  }
}