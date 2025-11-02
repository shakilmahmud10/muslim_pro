import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SurahCard extends StatelessWidget {
  const SurahCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Surah Card")),
      backgroundColor: const Color(0xFFE9F3EB),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              SurahCardInfo(
                suraNumber: '1',
                suraName: 'Al Fatiha',
                nameTranslation: 'The Opening',
                noOfAyah: 7,
                location: 'Meccan', // অথবা 'Madani'
              ),
              SizedBox(height: 16),
              // শুধুমাত্র required parameters সহ
              SurahCardInfo(
                suraNumber: '2',
                suraName: 'Al Baqara',
                nameTranslation: 'The Cow',
                noOfAyah: 286,
                location: 'Madani',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SurahCardInfo extends StatelessWidget {
  final String suraNumber;
  final String suraName;
  final String? nameTranslation;
  final int? noOfAyah;
  final String? location; // "Meccan" or "Madani"

  const SurahCardInfo({
    super.key,
    required this.suraNumber,
    required this.suraName,
    this.nameTranslation,
    this.noOfAyah,
    this.location,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Positioned(
            bottom: -1,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              "assets/image/svg/downWave.svg",
              fit: BoxFit.cover,
            ),
          ),
          // Location Image (Meccan/Madani)
          if (location != null)
            Positioned(
              right: 0,
              // height: 80,
              // width: 110,
              child: Image.asset(
                location == "Meccan"
                    ? "assets/image/png/Macci.png"
                    : "assets/image/png/Madani.png",
                fit: BoxFit.cover,
                scale: 1,
              ),
            ),
          Positioned(
            left: 10,
            top: 10,
            bottom: 10,
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/image/svg/numberBG.svg',
                      width: 46,
                      height: 46,
                    ),
                    Text(
                      suraNumber,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Surah Name
                    Text(
                      suraName,
                      style: const TextStyle(
                        color: Color(0xFF3d4953),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ),
                    ),
                    // Surah Translation (if provided)
                    if (nameTranslation != null)
                      Text(
                        nameTranslation!,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    // Ayah count and location (if provided)
                    if (noOfAyah != null || location != null)
                      Text(
                        _buildAyahLocationText(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
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
  }

  String _buildAyahLocationText() {
    String text = '';
    if (noOfAyah != null) {
      text += '$noOfAyah Ayahs';
    }
    if (location != null) {
      if (text.isNotEmpty) text += ' | ';
      text += location!;
    }
    return text;
  }
}
