
import 'dart:io';

import 'package:expenses/models/transaction.dart';
import 'package:expenses/widgets/adaptive_button.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../providers/transactions_provider.dart';

class NewTransaction extends StatefulWidget {
  //final Function addTx;

  //NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? selectedDate;
  File? image;

  Future<String> getLocation() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) Future.value("");
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) Future.value("");
    }
    //location.enableBackgroundMode(enable: true);
    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _locationController.text = "${currentLocation.latitude} : ${currentLocation.longitude}";
      });
    });

    _locationData = await location.getLocation();
    return "${_locationData.latitude} : ${_locationData.longitude}";
  }

  final firebaseStorage = FirebaseStorage.instance;

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

Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 200,
    );
    if (pickImage != null) {
      setState(() {
        image = File(pickImage.path);
      });
    }
  }

  void removeImage() {
    setState(() {
      image = null;
    });
  }

  @override
  void initState() {
    super.initState();
    getLocation().then((location) => {
          setState(() {
            _locationController.text = location;
          })
        });
  }

// @override
//   void didUpdateWidget(covariant NewTransaction oldWidget) {
//     print('didUpdateWidget()');
//     super.didUpdateWidget(oldWidget);
//   }

// @override
//   void dispose(){
//     print('dispose()');
//     super.dispose();
// }
//  _NewTransactionState createState(){
//   print('');
//   return _NewTransactionState();
// }

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<TransactionProvider>(context);

    void _submitData() {
      if (double.parse(_amountController.text.trim()).isNaN) {
        return;
      }
      final enteredTitle = _titleController.text;
      final enteredAmount = double.parse(_amountController.text.trim());

      if (enteredAmount.isNaN || _amountController.text.isEmpty) {
        return;
      } else if (enteredTitle.isEmpty ||
          enteredAmount <= 0 ||
          selectedDate == null) {
        return;
      }

      Transaction transaction = Transaction(
          id: '',
          title: enteredTitle,
          amount: enteredAmount,
          date: selectedDate!);
      transaction.location = _locationController.text;

      provider.addTransaction(transaction, image);
      Navigator.of(context).pop();//popAndPushNamed(RoutesPaths.HOME);
    }

    final mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              bottom: mediaQuery.viewInsets.bottom + 10,
              left: 10,
              right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Título'),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
                // onChanged: (val) {
                //   titleInput = val;
                // } ,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Valor'),
                controller: _amountController,
                // onChanged: (val) => amountInput = val,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                        child: Text(selectedDate == null
                            ? 'Data Vazia!'
                            : DateFormat('dd/MM/yyyy').format(selectedDate!))),
                    AdaptiveButton('Informe a Data!', _presentDatePicker)
                  ],
                ),
              ),

              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: image == null ? Text("Anexe uma foto") : Image.file(image!),
                      ),
                      IconButton(onPressed: pickImage, icon: Icon(Icons.camera)),
                      IconButton(onPressed: removeImage, icon: Icon(Icons.remove_circle)),

                  ],
                ),
              ),


              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(labelText: 'Localização'),
                        controller: _locationController,
                        onSubmitted: (_) => _submitData(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _submitData,
                child: Text('+'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
