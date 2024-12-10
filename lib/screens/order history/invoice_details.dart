import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery/constants/color_constants.dart';
import 'package:food_delivery/constants/text_constants.dart';
import 'package:food_delivery/utils/custom_text.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';

class InvoiceDetails extends StatefulWidget {
  const InvoiceDetails({super.key});

  @override
  State<InvoiceDetails> createState() => _InvoiceDetailsState();
}

class _InvoiceDetailsState extends State<InvoiceDetails> {
  final customText = CustomText();

  Future<void> genetatePdf() async {
    // Load the image as Uint8List
    // final Uint8List imageBytes = await rootBundle
    //     .load('assets/images/location_icon.png')
    //     .then((data) => data.buffer.asUint8List());
    final pdf = pw.Document();
    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Container(
        margin: pw.EdgeInsets.all(20),
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  "Order #1234567890",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                // GestureDetector(
                //   onTap: () {
                //     // generate pdf
                //     genetatePdf();
                //   },
                //   child: const Icon(
                //     Icons.picture_as_pdf_outlined,
                //   ),
                // ),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Container(
              child: pw.Text(
                "Delivered , 2 items,  -\$9.00",
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 10),
            // const pw.DottedLine(
            //   direction: Axis.horizontal,
            //   dashColor: ColorConstants.lightGreyColor,
            // ),
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // pw.Container(
                    //   margin: pw.EdgeInsets.only(right: 15),
                    //   height: 60,
                    //   width: 60,
                    //   decoration: pw.BoxDecoration(
                    //       shape: pw.BoxShape.circle,
                    //       image: pw.DecorationImage(
                    //           image: pw.MemoryImage(imageBytes))),
                    // ),
                    // pw.Container(
                    //     margin: pw.EdgeInsets.only(left: 25),
                    //     height: 80,
                    //     width: 2,
                    //     color: PdfColors.black
                    //     // child: pwDottedLine(
                    //     //   direction: Axis.vertical,
                    //     //   dashColor: ColorConstants.lightGreyColor,
                    //     // ),
                    //     ),
                    // pw.Container(
                    //   margin: pw.EdgeInsets.only(right: 15),
                    //   height: 60,
                    //   width: 60,
                    //   decoration: pw.BoxDecoration(
                    //       shape: pw.BoxShape.circle,
                    //       image: pw.DecorationImage(
                    //           image: pw.MemoryImage(imageBytes))),
                    // ),
                  ],
                ),
                pw.Container(
                  margin: pw.EdgeInsets.only(top: 10),
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        margin: pw.EdgeInsets.only(bottom: 5),
                        child: pw.Text(
                          "Girl & the Goat",
                          style: pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.red),
                        ),
                      ),
                      pw.Container(
                        width: 700,
                        margin: pw.EdgeInsets.only(bottom: 5),
                        child: pw.Text(
                          "Sector 63 Lorem Ipsum is simply dummy text of the printing and type setting industry.",
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Container(
                        margin: pw.EdgeInsets.only(bottom: 5),
                        child: pw.Text(
                          "Home",
                          style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.black),
                        ),
                      ),
                      pw.Container(
                        width: 700,
                        margin: pw.EdgeInsets.only(bottom: 5),
                        child: pw.Text(
                          "Lorem Ipsum is simply dummy text of the printing and type setting industry.",
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 010),
            pw.Container(
              height: 1,
              width: double.infinity,
              // color: ColorConstants.lightGreyColor,
            ),
            pw.SizedBox(height: 010),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // pw.Container(
                //   margin: pw.EdgeInsets.only(right: 15),
                //   child: pw.Icon(
                //     Icons.done,
                //     size: 32,
                //     color: Colors.greenAccent,
                //   ),
                // ),
                pw.Container(
                  width: 700,
                  child: pw.Text(
                    "Order Delivered on 25, sep 2024, 1:29 PM By John Smith",
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Container(
              margin: pw.EdgeInsets.only(bottom: 5),
              child: pw.Text(
                "${TextConstants.billDetails}",
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Container(
              padding: pw.EdgeInsets.all(10),
              // height: height * .45,
              width: double.infinity,
              decoration: pw.BoxDecoration(
                borderRadius: pw.BorderRadius.circular(12),
                // border: pw.Border.all(color: Colors.grey),
              ),
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 200,
                        child: pw.Text(
                          "Item 1",
                          style: pw.TextStyle(
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Container(
                        child: pw.Text(
                          "-\$4.00",
                          style: pw.TextStyle(
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 200,
                        child: pw.Text(
                          "Item 2",
                          style: pw.TextStyle(
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Container(
                        child: pw.Text(
                          "-\$6.00",
                          style: pw.TextStyle(
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Container(
                    height: 1,
                    width: double.infinity,
                    // color: ColorConstants.lightGreyColor,
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 60,
                        child: pw.Text(
                          "${TextConstants.itemTotal}",
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Container(
                        // child: customText.kText(
                        //   "-\$6.00",
                        //   20,
                        //   FontWeight.w800,
                        //   Colors.black,
                        //   TextAlign.start,
                        // ),
                        child: pw.Text(
                          "-\$6.00",
                          style: pw.TextStyle(
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Container(
                            margin: pw.EdgeInsets.only(bottom: 2),
                            width: 600,
                            child: pw.Text(
                              "${TextConstants.deliveryFee} | 4.2 Miles",
                              style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          // pw.Container(
                          //   width: 400,
                          //   child: const pw.DottedLine(
                          //     direction: Axis.horizontal,
                          //     dashColor: ColorConstants.lightGreyColor,
                          //   ),
                          // ),
                        ],
                      ),
                      pw.Container(
                        child: pw.Text(
                          "-\$6.00",
                          style: pw.TextStyle(
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Container(
                    margin: pw.EdgeInsets.only(bottom: 2),
                    width: 600,
                    child: pw.Text(
                      "${TextConstants.paymentDescription}",
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Container(
                            margin: pw.EdgeInsets.only(bottom: 2),
                            width: 200,
                            child: pw.Text(
                              "${TextConstants.platformFee}",
                              style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          // pw.Container(
                          //   width: 220,
                          //   child: const DottedLine(
                          //     direction: Axis.horizontal,
                          //     dashColor: ColorConstants.lightGreyColor,
                          //   ),
                          // ),
                        ],
                      ),
                      pw.Container(
                        child: pw.Text(
                          "-\$6.00",
                          style: pw.TextStyle(
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Container(
                            margin: pw.EdgeInsets.only(bottom: 2),
                            width: 200,
                            child: pw.Text(
                              "${TextConstants.gstAndRestaurantCharges}",
                              style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          // pw.Container(
                          //   width: 490,
                          //   child: const DottedLine(
                          //     direction: Axis.horizontal,
                          //     dashColor: ColorConstants.lightGreyColor,
                          //   ),
                          // ),
                        ],
                      ),
                      pw.Container(
                        child: pw.Text(
                          "-\$6.00",
                          style: pw.TextStyle(
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  // pw.Container(
                  //   height: 10,
                  //   width: double.infinity,
                  //   child: const DottedLine(
                  //     direction: Axis.horizontal,
                  //     dashColor: ColorConstants.lightGreyColor,
                  //   ),
                  // ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 200,
                        child: pw.Text(
                          "Paid Via Bank",
                          style: pw.TextStyle(
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Container(
                        child: pw.Text(
                          "-\$50.00",
                          style: pw.TextStyle(
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }));

    final directory = await getExternalStorageDirectory();
    // final path = '${directory!.path}/example.pdf';
    final path = '/storage/emulated/0/Download/invoice.pdf';

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
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customText.kText(
                    "Order #1234567890",
                    16,
                    FontWeight.w700,
                    Colors.black,
                    TextAlign.start,
                  ),
                  GestureDetector(
                    onTap: () {
                      // generate pdf
                      genetatePdf();
                    },
                    child: const Icon(
                      Icons.picture_as_pdf_outlined,
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * .010),
              Container(
                child: customText.kText(
                  "Delivered , 2 items,  -\$9.00",
                  14,
                  FontWeight.w700,
                  ColorConstants.lightGreyColor,
                  TextAlign.start,
                ),
              ),
              SizedBox(height: height * .010),
              const DottedLine(
                direction: Axis.horizontal,
                dashColor: ColorConstants.lightGreyColor,
              ),
              SizedBox(height: height * .010),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        height: height * .060,
                        width: width * .060,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/location_icon.png'))),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        height: height * .080,
                        width: 10,
                        child: const DottedLine(
                          direction: Axis.vertical,
                          dashColor: ColorConstants.lightGreyColor,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        height: height * .060,
                        width: width * .060,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/location_icon.png'))),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: customText.kText(
                            "Girl & the Goat",
                            20,
                            FontWeight.w700,
                            ColorConstants.kPrimary,
                            TextAlign.start,
                          ),
                        ),
                        Container(
                          width: width * .7,
                          margin: EdgeInsets.only(bottom: 5),
                          child: customText.kText(
                            "Sector 63 Lorem Ipsum is simply dummy text of the printing and type setting industry.",
                            14,
                            FontWeight.w500,
                            ColorConstants.lightGreyColor,
                            TextAlign.start,
                          ),
                        ),
                        SizedBox(height: height * .020),
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: customText.kText(
                            "Home",
                            20,
                            FontWeight.w700,
                            Colors.black,
                            TextAlign.start,
                          ),
                        ),
                        Container(
                          width: width * .7,
                          margin: EdgeInsets.only(bottom: 5),
                          child: customText.kText(
                            "Lorem Ipsum is simply dummy text of the printing and type setting industry.",
                            14,
                            FontWeight.w500,
                            ColorConstants.lightGreyColor,
                            TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * .010),
              Container(
                height: 1,
                width: double.infinity,
                color: ColorConstants.lightGreyColor,
              ),
              SizedBox(height: height * .010),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 15),
                    child: const Icon(
                      Icons.done,
                      size: 32,
                      color: Colors.greenAccent,
                    ),
                  ),
                  Container(
                    width: width * .7,
                    child: customText.kText(
                      "Order Delivered on 25, sep 2024, 1:29 PM By John Smith",
                      14,
                      FontWeight.w700,
                      ColorConstants.lightGreyColor,
                      TextAlign.start,
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * .020),
              Container(
                margin: EdgeInsets.only(bottom: 5),
                child: customText.kText(
                  TextConstants.billDetails,
                  20,
                  FontWeight.bold,
                  Colors.black,
                  TextAlign.start,
                ),
              ),
              SizedBox(height: height * .020),
              Container(
                padding: EdgeInsets.all(10),
                // height: height * .45,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ColorConstants.lightGreyColor),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: width * .6,
                          child: customText.kText(
                            "Item 1",
                            14,
                            FontWeight.w700,
                            ColorConstants.lightGreyColor,
                            TextAlign.start,
                          ),
                        ),
                        Container(
                          child: customText.kText(
                            "-\$4.00",
                            20,
                            FontWeight.w800,
                            Colors.black,
                            TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * .010),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: width * .6,
                          child: customText.kText(
                            "Item 2",
                            14,
                            FontWeight.w700,
                            ColorConstants.lightGreyColor,
                            TextAlign.start,
                          ),
                        ),
                        Container(
                          child: customText.kText(
                            "-\$6.00",
                            20,
                            FontWeight.w800,
                            Colors.black,
                            TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * .010),
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: ColorConstants.lightGreyColor,
                    ),
                    SizedBox(height: height * .010),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: width * .6,
                          child: customText.kText(
                            "${TextConstants.itemTotal}",
                            14,
                            FontWeight.w700,
                            ColorConstants.lightGreyColor,
                            TextAlign.start,
                          ),
                        ),
                        Container(
                          child: customText.kText(
                            "-\$6.00",
                            20,
                            FontWeight.w800,
                            Colors.black,
                            TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * .010),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 2),
                              width: width * .6,
                              child: customText.kText(
                                "${TextConstants.deliveryFee} | 4.2 Miles",
                                14,
                                FontWeight.w700,
                                ColorConstants.lightGreyColor,
                                TextAlign.start,
                              ),
                            ),
                            Container(
                              width: width * .4,
                              child: const DottedLine(
                                direction: Axis.horizontal,
                                dashColor: ColorConstants.lightGreyColor,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          child: customText.kText(
                            "-\$6.00",
                            20,
                            FontWeight.w800,
                            Colors.black,
                            TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * .010),
                    Container(
                      margin: EdgeInsets.only(bottom: 2),
                      width: width * .6,
                      child: customText.kText(
                        "${TextConstants.paymentDescription}",
                        14,
                        FontWeight.w700,
                        ColorConstants.lightGreyColor,
                        TextAlign.start,
                      ),
                    ),
                    SizedBox(height: height * .010),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 2),
                              width: width * .6,
                              child: customText.kText(
                                "${TextConstants.platformFee}",
                                14,
                                FontWeight.w700,
                                ColorConstants.lightGreyColor,
                                TextAlign.start,
                              ),
                            ),
                            Container(
                              width: width * .22,
                              child: const DottedLine(
                                direction: Axis.horizontal,
                                dashColor: ColorConstants.lightGreyColor,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          child: customText.kText(
                            "-\$6.00",
                            20,
                            FontWeight.w800,
                            Colors.black,
                            TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * .010),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 2),
                              width: width * .6,
                              child: customText.kText(
                                "${TextConstants.gstAndRestaurantCharges}",
                                14,
                                FontWeight.w700,
                                ColorConstants.lightGreyColor,
                                TextAlign.start,
                              ),
                            ),
                            Container(
                              width: width * .49,
                              child: const DottedLine(
                                direction: Axis.horizontal,
                                dashColor: ColorConstants.lightGreyColor,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          child: customText.kText(
                            "-\$6.00",
                            20,
                            FontWeight.w800,
                            Colors.black,
                            TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * .010),
                    Container(
                      height: 10,
                      width: double.infinity,
                      child: const DottedLine(
                        direction: Axis.horizontal,
                        dashColor: ColorConstants.lightGreyColor,
                      ),
                    ),
                    SizedBox(height: height * .010),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: width * .6,
                          child: customText.kText(
                            "Paid Via Bank",
                            20,
                            FontWeight.w800,
                            ColorConstants.kPrimary,
                            TextAlign.start,
                          ),
                        ),
                        Container(
                          child: customText.kText(
                            "-\$50.00",
                            20,
                            FontWeight.w800,
                            Colors.black,
                            TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
