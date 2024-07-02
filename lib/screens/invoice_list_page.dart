import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'invoice_details_page.dart'; // Adjust import as per your file structure

class InvoiceListPage extends StatefulWidget {
  @override
  _InvoiceListPageState createState() => _InvoiceListPageState();
}

class _InvoiceListPageState extends State<InvoiceListPage> {
  List invoices = [];

  @override
  void initState() {
    super.initState();
    fetchInvoices();
  }

  Future<void> fetchInvoices() async {
    var url = Uri.parse('http://10.0.2.2:8000/api/invoices'); // Adjust URL as per your backend setup
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          invoices = jsonDecode(response.body);
        });
      } else {
        print('Failed to fetch invoices. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch invoices. Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoices'),
      ),
      body: ListView.builder(
        itemCount: invoices.length,
        itemBuilder: (context, index) {
          var invoice = invoices[index];
          var invoiceId = invoice['id'];
          if (invoiceId == null) {
            return ListTile(
              title: Text('Invalid Invoice Data'),
            );
          }
          return ListTile(
            title: Text('Invoice Number: ${invoice['invoice_number']}'),
            subtitle: Text('Client: ${invoice['client_name']}'),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/invoice_details',
                arguments: {'invoiceId': invoiceId},
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create_invoice');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
