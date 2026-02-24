import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../ViewModel/SuggetionVM/SD_vm.dart';
import '../ViewModel/SuggetionVM/suggetion_vm.dart';

class ViewSuggestion extends StatelessWidget {
  const ViewSuggestion({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => SuggetionVM()..getAllSuggetions()),
        ChangeNotifierProvider(create: (_) => SDVM()),
      ],
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            "View Suggetion",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFAB47BC), Color(0xFF42A5F5)],
              ),
            ),
          ),
        ),
        body: Consumer<SuggetionVM>(
          builder: (context, vm, child) {

            if (vm.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (vm.suggetions.isEmpty) {
              return const Center(
                child: Text("No Suggestions Found"),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vm.suggetions.length,
              itemBuilder: (context, index) {

                final item = vm.suggetions[index];
                final deleteVM = Provider.of<SDVM>(context, listen: false);

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Admission No: ${item.appNo}",
                                  style: const TextStyle(
                                      fontWeight:
                                      FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text("Date:${item.date.day}/${item.date.month}/${item.date.year}",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),

                            IconButton(icon: const Icon(Icons.delete,
                                color: Colors.grey,
                              ),
                              onPressed: () async {
                                final confirm = await showDialog(
                                  context: context, builder: (_) =>
                                      AlertDialog(
                                        title: const Text("Delete Suggestion"),
                                        content: const Text("Are you sure delete this suggestion?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child:
                                            const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            child: const Text("Delete",
                                              style: TextStyle(
                                                  color:
                                                  Colors.red),
                                            ),
                                          ),
                                        ],
                                      ),
                                );

                                if (confirm == true) {
                                  bool success =
                                  await deleteVM.deleteSuggestion(item.suggestionId);

                                  if (success) {
                                    //remove locally
                                    Provider.of<SuggetionVM>(context, listen: false).deleteSuggestion(
                                        item.suggestionId);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Deleted Successfully")),
                                    );

                                  }
                                  else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Delete Failed")),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),
                        Text("Title: ${item.title}",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text("Category: ${item.category}",
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text("Remarks: ${item.remarks}"),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}