import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kBlack = Color(0xFF21202A);
const kBlackAccent = Color(0xFF3A3A3A);
const kSilver = Color(0xFFF6F6F6);
const kOrange = Color(0xFFFA5805);

var kPageTitleStyle = GoogleFonts.poppins(
  textStyle: const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    wordSpacing: 2.5,
  )

);
var kPageTitleStyleBlack = GoogleFonts.questrial(
  fontSize: 23,
  fontWeight: FontWeight.w900,
  color: Colors.black,
  wordSpacing: 2.5,
);
var kTitleStyle = GoogleFonts.questrial(
  fontSize: 16,
  color: Colors.white,
  fontWeight: FontWeight.w400,
);
var kSubtitleStyle = GoogleFonts.questrial(
  fontSize: 14,
  color: kBlack,
);

final kHintTextStyle = TextStyle(
  color: Colors.grey[700],
  fontFamily: 'OpenSans',
);

const kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: const Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: const [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
