import 'package:hospital_appointment/Screen/User/doct_detail_screen.dart';
import 'package:hospital_appointment/Widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_appointment/Controllers/user_dashboard_controller.dart';
import 'package:hospital_appointment/Controllers/user_controller.dart';

class SearchPage extends StatelessWidget {
  final String userUid, userName, userEmail;
  final UserDashboardController userDashboardController =
      Get.put(UserDashboardController());
  final UserController userController = Get.put(UserController());
  final TextEditingController searchController = TextEditingController();
  final RxList<dynamic> suggestions = <dynamic>[].obs; // List to hold suggestions

  SearchPage(
      {super.key,
      required this.userUid,
      required this.userName,
      required this.userEmail});

  @override
  Widget build(BuildContext context) {
    // Add listener to the search controller to update suggestions
    searchController.addListener(() {
      performSearchSuggestions(searchController.text.toLowerCase());
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text(
          "Search Doctors",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            shadows: [BoxShadow(blurRadius: 5, spreadRadius: 10)],
          ),
        ),
        centerTitle: true,
        foregroundColor: const Color(0xFFE63946),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              TextFieldWidget(
                suffixIconColor: const Color(0xFFE63946),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Trigger search functionality
                    performSearch();
                    searchController.clear();
                  },
                ),
                labelColor: const Color(0xFFE63946),
                labelText: "Search by Hospital or Doctor Name",
                controller: searchController,
                focusBorderColor: const Color(0xFFE63946),
                errorBorderColor: Colors.red,
              ),
              const SizedBox(height: 10), // Adjust spacing if needed
          
              // Display suggestions if available
              Obx(() {
                if (suggestions.isNotEmpty) {
                  return SizedBox(
                    // Wrap suggestions in a scrollable view
                    height: MediaQuery.of(context).size.height * 0.4, // Set a reasonable height for the suggestions
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: suggestions.length,
                      itemBuilder: (context, index) {
                        final Doctor = suggestions[index];
                        return ListTile(
                          title: Text(Doctor['doctName'] ?? "Unknown"),
                          subtitle: Text("Hospital: ${Doctor['hospital'] ?? 'Unknown'}"),
                          onTap: () {
                            // Handle suggestion tap
                            searchController.text = Doctor['doctName'] ?? ""; // Fill the text field
                            performSearch(); // Trigger the search
                          },
                        );
                      },
                    ),
                  );
                }
                return Container(); // Return empty container if no suggestions
              }),
          
              const SizedBox(height: 20), // Adjust spacing if needed
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                width: double.infinity,
                child: Obx(() {
                  if (userDashboardController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
          
                  // Check if selected Doctors list is empty after search
                  if (userDashboardController.selecteddoct.isEmpty && suggestions.isEmpty) {
                    return const Center(child: Text("No results found."));
                  }
          
                  // Display the searched Doctors
                  return ListView.builder(
                    itemCount: userDashboardController.selecteddoct.length,
                    itemBuilder: (context, index) {
                      final Doctor = userDashboardController.selecteddoct[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        leading: CircleAvatar(
                          radius: 30, // Adjust size as needed
                          backgroundImage: NetworkImage(Doctor['doctPic'] ?? ""),
                          backgroundColor: Colors.grey[300],
                        ),
                        title: Text(
                          Doctor['doctName'] ?? "Unknown",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("Hospital: ${Doctor['hospital'] ?? 'Unknown'}"),
                        onTap: () {
                          // Handle tap on the Doctor to navigate to detail screen
                          Get.to(DoctorDetailScreen(
                            doctName: Doctor['doctName'],
                            description: Doctor['description'] ?? "No description",
                            imageUrl: Doctor['doctPic'] ?? "",
                            docUid: Doctor['doctUid'] ?? "",
                            userUid: userUid,
                            userName: userName,
                            userEmail: userEmail,
                            doctKey: Doctor['doctKey'],
                            doctContact: Doctor['doctContact'] ?? "N/A",
                            // doctPlate: Doctor['doctPlate'] ?? "N/A",
                            // doctSize: Doctor['doctSize'] ?? "N/A",
                            hosName: Doctor['hospital'] ?? "N/A",
                            index: index,
                          ));
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void performSearch() {
    String query = searchController.text.toLowerCase();
    userDashboardController.selecteddoct.clear();

    // Search for Doctors based on the query
    for (var Doctor in userDashboardController.doct) {
      if (Doctor['doctName']?.toLowerCase().contains(query) == true ||
          Doctor['hospital']?.toLowerCase().contains(query) == true) {
        userDashboardController.selecteddoct.add(Doctor);
      }
    }

    userDashboardController.update(); // Notify listeners
  }

  void performSearchSuggestions(String query) {
    suggestions.clear();

    // Only search for suggestions if the query is not empty
    if (query.isNotEmpty) {
      for (var Doctor in userDashboardController.doct) {
        if (Doctor['doctName']?.toLowerCase().contains(query) == true ||
            Doctor['hospital']?.toLowerCase().contains(query) == true) {
          suggestions.add(Doctor);
        }
      }
    }
  }
}
