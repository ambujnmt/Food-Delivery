import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';

class InvoiceDetailsPdf extends StatefulWidget {
  const InvoiceDetailsPdf({super.key});

  @override
  State<InvoiceDetailsPdf> createState() => _InvoiceDetailsPdfState();
}

class _InvoiceDetailsPdfState extends State<InvoiceDetailsPdf> {
  Future<void> genetatePdf() async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Center(child: pw.Text("Pdf"));
    }));
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/example.pdf';
    final file = File(path);
    await file.writeAsBytes(await pdf.save());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("PDF Generate"),
        content: Text("Pdf has been saved to ${path}"),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 20,
              width: 100,
              child: Center(
                child: Text("OK"),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
