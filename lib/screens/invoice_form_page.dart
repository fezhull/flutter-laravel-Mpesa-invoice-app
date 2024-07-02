// lib/screens/invoice_form_page.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InvoiceFormPage extends StatefulWidget {
  @override
  _InvoiceFormPageState createState() => _InvoiceFormPageState();
}

class _InvoiceFormPageState extends State<InvoiceFormPage> {
  final TextEditingController invoiceNumberController = TextEditingController();
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();

  void saveInvoice() async {
    String invoiceNumber = invoiceNumberController.text.trim();
    String clientName = clientNameController.text.trim();
    String totalAmount = totalAmountController.text.trim();

    var url = Uri.parse('http://10.0.2.2:8000/api/invoices');
    

    try {
      var response = await http.post(
        url,
        body: {
          'invoice_number': invoiceNumber,
          'client_name': clientName,
          'total_amount': totalAmount,
        },
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Invoice saved successfully!'),
          duration: Duration(seconds: 3),
        ));
        Navigator.pop(context); // Navigate back after saving
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to save invoice. Please try again.'),
          duration: Duration(seconds: 3),
        ));
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Invoice'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: invoiceNumberController,
              decoration: InputDecoration(labelText: 'Invoice Number'),
            ),
            TextField(
              controller: clientNameController,
              decoration: InputDecoration(labelText: 'Client Name'),
            ),
            TextField(
              controller: totalAmountController,
              decoration: InputDecoration(labelText: 'Total Amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => saveInvoice(),
              child: Text('Save Invoice'),
            ),
          ],
        ),
      ),
    );
  }
}
