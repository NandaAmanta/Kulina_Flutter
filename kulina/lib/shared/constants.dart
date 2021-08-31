import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

const greenColor = Color(0xff32a54b);
const primaryColor = Color(0xffF9423A);
final textNormalFont = GoogleFonts.poppins().copyWith(fontSize: 12, fontWeight: FontWeight.w500);
final textBoldFont = GoogleFonts.poppins().copyWith(fontSize: 12, fontWeight: FontWeight.bold);

final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');