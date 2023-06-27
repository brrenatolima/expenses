// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:expenses/models/transaction.dart';
import 'package:expenses/providers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class EditTransaction extends StatefulWidget {
  const EditTransaction({super.key, required this.transaction});

  final Transaction transaction;

  @override
  State<EditTransaction> createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  final firebaseStorage = FirebaseStorage.instance;
  var _titleController = TextEditingController();
  var _amountController = TextEditingController();
  var _locationController = TextEditingController();

  DateTime? selectedDate;
  File? image;
  String? imageUrl;
  Image? photo;
  Uint8List? imageBytes;

  Future<Image> loadImageFromNetwork(String imageUrl) async {
    var response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      Uint8List bytes = response.bodyBytes;
      setState(() {
        imageBytes = response.bodyBytes;

        photo = Image.memory(bytes);
      });

      return Image.memory(bytes);
    } else {
      throw Exception(
          'Falha ao baixar a imagem. Código de status: ${response.statusCode}');
    }
  }

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
      print(selectedDate);
    });
  }

  void removeImage() {
    setState(() {
      imageBytes = null;
                        image = null;
                        imageUrl = null;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController.text = widget.transaction.title;
    _amountController.text = widget.transaction.amount.toString();
    _locationController.text = widget.transaction.location.toString();
    selectedDate = widget.transaction.date;
    imageUrl = widget.transaction.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final reference = firebaseStorage.ref(widget.transaction.imageUrl);
    final provider = Provider.of<TransactionProvider>(context);

    void _submitData(String id) {
      if (double.parse(_amountController.text).isNaN) {
        return;
      }
      final enteredTitle = _titleController.text;
      final enteredAmount = double.parse(_amountController.text.trim());

      if (enteredAmount.isNaN || _amountController.text.isEmpty) {
        return;
      }

      if (enteredTitle.isEmpty || enteredAmount <= 0 || selectedDate == null) {
        return;
      }

      Transaction tr = Transaction(
          id: id,
          title: enteredTitle,
          amount: enteredAmount,
          date: selectedDate!); //service.show(id) as Transaction;

      tr.location = _locationController.text;
      provider.editTransaction(tr.id, tr);
      Navigator.of(context).pop();
    }

    var futureBuilder = FutureBuilder(
      future: reference.getDownloadURL(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          print("Erro ao consultar dados: ${snapshot.error}");
          return Center(
            child: Text("Erro ao consultar dados: ${snapshot.error}"),
          );
        } else if (snapshot.hasData) {
          if (snapshot.data != null) {
            if (imageBytes == null) loadImageFromNetwork(snapshot.data!);

            return Row(
              children: [
                // image == null ? Text("Anexe uma foto") : Image.file(image!)

                //Image.network(snapshot.data!),
                image == null
                    ? imageBytes == null
                        ? CircularProgressIndicator()
                        : Image.memory(imageBytes!)
                    : Image.file(image!),

                IconButton(
                    onPressed: removeImage, icon: Icon(Icons.remove_circle)),
              ],
            );
          } else {
            return const Text("!");
          }
        } else {
          return const Text("!");
        }
      },
    );

    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Título'),
              controller: _titleController,
              onSubmitted: (_) => _submitData,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Valor'),
              controller: _amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) => _submitData,
            ),
            Container(
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
            ),
            Container(
              height: 70,
              child: Row(
                children: [
                  //imageUrl == null? Text("Vazio") : Text(imageUrl!),

                  Expanded(
                      child: image == null
                          ? imageUrl == null
                              ? Text("Anexe uma foto")
                              : futureBuilder
                          : Row(
                              children: [
                                Image.file(image!),
                                IconButton(
                                    onPressed: removeImage,
                                    icon: Icon(Icons.remove_circle)),
                              ],
                            )
                            ),
                  IconButton(onPressed: pickImage, icon: Icon(Icons.camera)),
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
                      //onSubmitted: (_) => _submitData(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _submitData(widget.transaction.id),
              child: Text('+'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
