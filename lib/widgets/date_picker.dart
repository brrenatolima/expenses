import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
   DatePicker({super.key});

  
  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {

  DateTime? selectedDate;

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2999))
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        selectedDate = value;
      });

      if (kDebugMode) {
        print(selectedDate);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                      child: Text(selectedDate == null
                          ? 'Data Vazia!'
                          : DateFormat('dd/MM/yyyy').format(selectedDate!))),
                  IconButton(
                    onPressed: _presentDatePicker,
                    icon: Icon(Icons.calendar_today),
                    style: ButtonStyle(
                        iconColor: MaterialStatePropertyAll(
                            Theme.of(context).textTheme.labelLarge!.color),
                        foregroundColor: MaterialStatePropertyAll(
                            Theme.of(context).textTheme.labelLarge!.color)),
                  ),
                ],
              ),
            );
  }
}