import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InvoiceDetailsPage extends StatefulWidget {
  final int invoiceId;

  InvoiceDetailsPage({required this.invoiceId});

  @override
  _InvoiceDetailsPageState createState() => _InvoiceDetailsPageState();
}

class _InvoiceDetailsPageState extends State<InvoiceDetailsPage> {
  Map<String, dynamic>? invoice;

  @override
  void initState() {
    super.initState();
    fetchInvoiceDetails();
  }

  Future<void> fetchInvoiceDetails() async {
    var url = Uri.parse('http://10.0.2.2:8000/api/invoices/${widget.invoiceId}');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          invoice = jsonDecode(response.body);
        });
      } else {
        print('Failed to fetch invoice details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch invoice details. Error: $e');
    }
  }

  Future<void> initiatePayment() async {
    var paymentUrl = Uri.parse('http://10.0.2.2:8000/api/mpesa/initiate-payment'); // Replace with your Laravel backend URL for initiating payments

    try {
      var response = await http.post(
        paymentUrl,
        body: {
          'amount': invoice!['total_amount'].toString(), // Adjust as per your invoice structure
          'phone_number': '2547xxxxxxxx', // Replace with actual customer phone number
        },
      );

      // Handle response from Laravel backend
      if (response.statusCode == 200) {
        var paymentResponse = jsonDecode(response.body);
        // Optionally handle payment response here, e.g., show payment status
        print('Payment initiated successfully');
      } else {
        print('Failed to initiate payment. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to initiate payment. Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Details'),
      ),
      body: invoice == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Invoice Number: ${invoice!['invoice_number']}'),
                  Text('Client Name: ${invoice!['client_name']}'),
                  Text('Total Amount: \$${invoice!['total_amount']}'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: initiatePayment,
                    child: Text('Pay with M-Pesa'),
                  ),
                ],
              ),
            ),
    );
  }
}
