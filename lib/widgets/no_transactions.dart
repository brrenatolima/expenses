import 'package:flutter/material.dart';

class NoTransactions extends StatelessWidget {
  const NoTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Builder(
              builder: (context) => Text(
                'Sem dados',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                height: constraints.maxHeight * 0.6,
                child: Image.asset(
                  'assets/images/empty.png',
                  fit: BoxFit.cover,
                ))
          ],
        );
      },
    );
  }
}
