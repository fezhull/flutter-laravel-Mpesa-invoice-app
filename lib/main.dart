import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'screens/dashboard_page.dart';
import 'screens/invoice_details_page.dart';
import 'screens/invoice_form_page.dart';
import 'screens/invoice_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Invoice App',
      initialRoute: '/dashboard',
      routes: {
        '/dashboard': (context) => DashboardPage(),
        '/invoices': (context) => InvoiceListPage(),
        '/create_invoice': (context) => InvoiceFormPage(),
        '/edit_invoice': (context) => InvoiceFormPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/invoice_details') {
          final Map<String, dynamic>? args =
              settings.arguments as Map<String, dynamic>?;
          if (args != null && args.containsKey('invoiceId')) {
            return MaterialPageRoute(
              builder: (context) =>
                  InvoiceDetailsPage(invoiceId: args['invoiceId'] as int),
            );
          } else {
            // Handle error or fallback navigation
            return MaterialPageRoute(
              builder: (context) => InvoiceListPage(), // Fallback to invoice list
            );
          }
        }
        // Handle other routes if needed
        return null;
      },
    );
  }
}
