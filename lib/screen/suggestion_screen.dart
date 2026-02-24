import 'package:app/screen/view_suggestion.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../ViewModel/SuggetionVM/SRequest_vm.dart';
import '../widget/app_button.dart';

class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({super.key});

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController suggestionController = TextEditingController();

  String selectedCategory = "General";

  final List<String> categories = [
    "General",
    "Academics",
    "Teachers",
    "Fees",
    "Other"
  ];

  @override
  void dispose() {
    titleController.dispose();
    suggestionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SRequestVM(),
      child: Consumer<SRequestVM>(
        builder: (context, vm, child) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F6FA),
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              title: Text(
                "Suggestion",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: Colors.transparent,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFAB47BC), Color(0xFF42A5F5)],
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    /// CATEGORY
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonFormField<String>(
                          value: selectedCategory,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: "Suggestion Category",
                          ),
                          items: categories
                              .map(
                                (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value!;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// TITLE
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Title",
                        hintText: "Enter suggestion title",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Title is required";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    /// SUGGESTION MESSAGE
                    TextFormField(
                      controller: suggestionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: "Suggestion",
                        hintText: "Write your suggestion here...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Suggestion cannot be empty";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    /// SUBMIT BUTTON
                    vm.isLoading
                        ? const CircularProgressIndicator()
                        : AppButton(
                      title2: "Submit Suggestion",
                      onPress1: () async {
                        if (_formKey.currentState!.validate()) {
                          bool success =
                          await vm.submitSuggestion(
                            title: titleController.text,
                            category: selectedCategory,
                            remarks:
                            suggestionController.text,
                          );

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(success
                                  ? vm.message
                                  : "Failed to submit"),
                            ),
                          );

                          if (success) {
                            titleController.clear();
                            suggestionController.clear();
                            setState(() {
                              selectedCategory = "General";
                            });
                          }
                        }
                      },
                    ),

                    const SizedBox(height: 24),

                    /// VIEW BUTTON
                    AppButton(
                      title2: "View Suggestion",
                      onPress1: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const ViewSuggestion(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}