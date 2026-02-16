import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BrandLogo extends StatelessWidget {
  final bool isSplash;

  const BrandLogo({super.key, this.isSplash = false});

  @override
  Widget build(BuildContext context) {
    final double mainFontSize = isSplash ? 70 : 34;
    final double sloganFontSize = isSplash ? 17 : 9;
    final double letterSpacing = isSplash ? 3.8 : 2.4;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Ymr Necklaces',
          style: GoogleFonts.greatVibes(
            color: Colors.white,
            fontSize: mainFontSize,
            height: 0.95,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: isSplash ? 8 : 1),
        Text(
          'YOUR SIGNATURE SPARKLE',
          style: GoogleFonts.montserrat(
            color: Colors.white70,
            fontSize: sloganFontSize,
            letterSpacing: letterSpacing,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
