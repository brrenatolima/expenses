import 'package:expenses/models/transaction.dart';
import 'package:expenses/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';




class Chart extends StatelessWidget {
  const Chart(this.transactions, {super.key});

  final List<Transaction> transactions;

  

  List<Transaction> get recentTransactions {    
    return transactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  List<Map<String, Object>> get groupedTransactionsValues {
    Intl.defaultLocale = 'pt_BR';
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum = recentTransactions[i].amount;
        }
      }
      return {        
        'dia': DateFormat.E().format(weekDay).substring(0, 3).toUpperCase(),
        'valor': totalSum
      };
    }).reversed.toList();

    
  }

  double get maxSpending {
    return groupedTransactionsValues.fold(0.0, (sum, item) {
      sum = sum + (item['valor'] as double);
      return sum;
    });
  }

  @override
  Widget build(BuildContext context) {    

    
    initializeDateFormatting('pt_BR', null).then((_) {print(groupedTransactionsValues);});
    
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            //flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: groupedTransactionsValues
                      .map((dado) => ChartBar(
                          dado['dia'].toString(),
                          (dado['valor'] as double),
                          (dado['valor'] as double) / maxSpending))
                      .toList()),
            ),
          ),
        ],
      ),
    );
  }
}
