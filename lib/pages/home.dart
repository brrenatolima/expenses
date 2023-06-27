// import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_io/io.dart';

import 'package:expenses/providers/transactions_provider.dart';
import '../models/transaction.dart';
import '../routes/routes_paths.dart';
import '../widgets/chart.dart';
import '../widgets/new_transaction.dart';
import '../widgets/transaction_list.dart';

import 'package:expenses_pk/expenses_pk.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {

// @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     print(state);
//     super.didChangeAppLifecycleState(state);
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addObserver(this);
//     super.initState();
//   }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewTransaction();
      },
    );
  }

  Calculator calculator = Calculator(); 



  List<Widget> _buildLandscapeContent(MediaQueryData mediaQuery, PreferredSizeWidget appBar, List<Transaction> list) {
    var transactionListContainer = _transactionListContainer(list, mediaQuery, appBar);
    var chartContainer = Container(
        height: (mediaQuery.size.height -
                (appBar).preferredSize.height -
                mediaQuery.padding.top) *
            (0.7), //3
        child: Chart(list));
   
   List<Tr> transactions = [];
    list.forEach((element) {
      Tr tr = Tr(id: element.id, title: element.title, amount: element.amount, date: element.date);
      transactions.add(tr);
    });
    var saldo = calculator.currentBalance(transactions);

    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Mostrar gráficos',
              style: Theme.of(context).textTheme.titleMedium),
          Switch.adaptive(
              activeColor: Theme.of(context).primaryColor,
              value: _showChart,
              onChanged: (val) {
                setState(() {
                  _showChart = val;
                });
              })
        ],
      ),
       Center(child: Text("Saldo Atual - R\$ " + saldo.toStringAsFixed(2)),),
      _showChart ? chartContainer : transactionListContainer,

     

      
    ];
    
  }

  Container _transactionListContainer(List<Transaction> list, MediaQueryData mediaQuery, PreferredSizeWidget appBar) {

    return Container(
      height: (mediaQuery.size.height -
              (appBar).preferredSize.height -
              mediaQuery.padding.top) *
          0.70,
      child: TransactionList(list),
    );
  }

  List<Widget> _buildPortraitContent(MediaQueryData mediaQuery, PreferredSizeWidget appBar, List<Transaction> list) {

    List<Tr> transactions = [];
    list.forEach((element) {
      Tr tr = Tr(id: element.id, title: element.title, amount: element.amount, date: element.date);
      transactions.add(tr);
    });
    var saldo = calculator.currentBalance(transactions);

    return [
      

      Container(
          height: (mediaQuery.size.height -
                  (appBar).preferredSize.height -
                  mediaQuery.padding.top) *
              (0.2), //3
          child: Chart(list)),
          Center(child: Text("Saldo Atual - R\$ " + saldo.toStringAsFixed(2)),),
      Container(child: _transactionListContainer(list, mediaQuery, appBar)),

      
    ];
  }

  PreferredSizeWidget _buildAppBar() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text("Despesas"),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              Builder(
                  builder: (context) => GestureDetector(
                        onTap: () => _startAddNewTransaction(context),
                        child: const Icon(CupertinoIcons.add),
                      ))
            ]),
          ) as PreferredSizeWidget
        : AppBar(
            title: const Text("Despesas"),
            actions: [
              Builder(
                  builder: (context) => IconButton(
                      onPressed: () => _startAddNewTransaction(context),
                      icon: const Icon(Icons.add))
             )
            ],
          );
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    if (auth.currentUser == null) {
      Navigator.of(context).pushNamed(RoutesPaths.LOGIN_SCREEN);
    }

    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    if (!isLandscape) _showChart = true;

    final provider = Provider.of<TransactionProvider>(context);

    final PreferredSizeWidget appBar = _buildAppBar();

    var mediaQuery = MediaQuery.of(context);

    final pageBody = FutureBuilder<List<Transaction>>(
        future: provider.list(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao consultar dados! ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final list = snapshot.data;
            if (list != null && list.isNotEmpty) {
            
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        if (isLandscape)
                          ..._buildLandscapeContent(mediaQuery, appBar, list),
                        if (!isLandscape)
                          ..._buildPortraitContent(mediaQuery, appBar, list),
                      ]
                  ),
                ),
              );
            } else {
              return Center(
                child: Text('Erro ao consultar dados! ${snapshot.error}'),
              );
            }
          } else {
            return Center(
              child: Text('Erro ao consultar dados! ${snapshot.error}'),
            );
          }
        });

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar as ObstructingPreferredSizeWidget,
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar as AppBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Builder(
              builder: (context) => Platform.isIOS
                  ? Container()
                  : FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: () => _startAddNewTransaction(context),
                    ),
            ),
          );
  }
}
