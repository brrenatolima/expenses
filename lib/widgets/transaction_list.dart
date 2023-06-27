import 'package:expenses/providers/transactions_provider.dart';
import 'package:expenses/services/transactions_service.dart';
import 'package:expenses/widgets/edit_transaction.dart';
import 'package:expenses/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transaction.dart';
import 'no_transactions.dart';

// ignore: must_be_immutable
class TransactionList extends StatefulWidget {
  TransactionList(this.transactions, {super.key});

  List<Transaction> transactions;

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  @override
  void initState() {
    TransactionsService service = TransactionsService();
    service.list().then((value) => widget.transactions = value);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TransactionList oldWidget) {
    TransactionsService service = TransactionsService();
    service.list().then((value) => widget.transactions = value);
    super.didUpdateWidget(oldWidget);
  }

  void _startEditTransaction(BuildContext ctx, Transaction trans) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return EditTransaction(transaction: trans);
      },
    );
  }


  TransactionsService service = TransactionsService();


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);

    return FutureBuilder(
        future: service.list(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Erro ao consultar dados: ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            final list = snapshot.data;
            if (list != null && list.isNotEmpty) {
              return ChangeNotifierProvider(
                  create: (context) => TransactionProvider(),
                  child: Container(
                      //height: MediaQuery.of(context).size.height * 0.6,
                      child: list.isEmpty
                          ? const NoTransactions()
                          : ListView(
                              children: _generateListTransactions(list),
                              //_generateListTransactions(transaction);
                            )));
            } else {
              return const Center(child: Text("Lista de Transações vazia!"));
            }
          } else {
            return const Center(child: Text("Lista de Transações vazia!"));
          }
        }
        );
  }

  List<Widget> _generateListTransactions(List<Transaction> transactions) {
    return transactions.map((element) => TransactionItem(ValueKey(element.id), element)).toList();
   
  }
}
