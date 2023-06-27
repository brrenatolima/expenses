import 'dart:math';

import 'package:expenses/providers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/transaction.dart';
import 'edit_transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem(Key key, this.transaction) : super(key: key);

  final Transaction transaction;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {

Color? _bgColor;

@override
  void initState() {
    // TODO: implement initState
    
    const avaliableColors = [Colors.black, Colors.blue, Colors.red, Colors.green, Colors.purple, Colors.yellow];

    _bgColor = avaliableColors[Random().nextInt(6)];
    super.initState();
  }

  void _startEditTransaction(BuildContext ctx, Transaction trans) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return EditTransaction(transaction: trans);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    final mediaQuery = MediaQuery.of(context);

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: Builder(
          builder: (context) => ListTile(
                onTap: () => _startEditTransaction(context, widget.transaction),
                leading: CircleAvatar(
                  backgroundColor: _bgColor,
                  radius: 30,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: FittedBox(child: Text('\$${widget.transaction.amount}')),
                  ),
                ),
                title: Text(
                  widget.transaction.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                subtitle:
                    Text(DateFormat('dd/MM/yyyy').format(widget.transaction.date)),
                trailing: mediaQuery.size.width > 500?
                  TextButton(
                    onPressed: () => provider.deleteTransaction(widget.transaction.id) , 
                    style: ButtonStyle(iconColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.error)),
                    child: const Column(
                      children: [
                        Text('Apagar'),
                        Icon(Icons.delete)
                      ],
                    ),
                  ) 
                  :
                  IconButton(
                    icon: const Icon(Icons.delete),
                    color: Theme.of(context).colorScheme.error,
                    onPressed: () => provider.deleteTransaction(widget.transaction.id) 
                    //TransactionProvider().deleteTransaction(transaction.id)
                  )//_deleteTransaction(transaction.id)),
              )),
    );
  }
}
