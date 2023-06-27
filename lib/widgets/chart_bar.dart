
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChartBar extends StatelessWidget {
  const ChartBar(this.label, this.speendingAmount, this.spendingPercent, {super.key});

  final String label;
  final double speendingAmount;
  final double spendingPercent;





  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(builder: (context, constraint) {
      return Column(
      children: [
        Container(
          height: constraint.maxHeight * 0.15,
          child: FittedBox(child: Text('\$${speendingAmount.toStringAsFixed(0)}'))
        ),

        SizedBox(height: constraint.maxHeight * 0.05,),

         Container(
          height: constraint.maxHeight * 0.6,
          width: 10, 
          child: Stack(
            children: [

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.0),
                  color: Color.fromRGBO(220, 220, 220, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
               ),

              FractionallySizedBox(
                heightFactor: spendingPercent.isNaN ? 0 : spendingPercent,
                child: Container(
                  decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(10)),
                ),
              ),

            ],
           ),
         ),

        SizedBox(height: constraint.maxHeight * 0.05,),
        Container(
          child: FittedBox(child: Text(label)), 
          height: constraint.maxHeight * 0.15
          ),

      ],
    );
    });
  }
}