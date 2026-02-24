import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Language extends StatefulWidget {
  const Language({super.key});

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          "Language",
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFAB47BC), // Rich Purple
                Color(0xFF42A5F5), // Medium Blue
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          _languageTile("English"),
          const Divider(),
          _languageTile("Hindi"),
          const Divider(),
          _languageTile("Gujarati"),
          const Divider(),
          _languageTile("Marathi"),
        ],
      ),
    );
  }

  Widget _languageTile(String language) {
    return RadioListTile<String>(
      title: Text(
        language,
        style: GoogleFonts.poppins(fontSize: 16),
      ),
      value: language,
      groupValue: selectedLanguage,
      activeColor: Colors.blue,
      onChanged: (value) {
        setState(() {
          selectedLanguage = value!;
        });
      },
    );
  }
}
