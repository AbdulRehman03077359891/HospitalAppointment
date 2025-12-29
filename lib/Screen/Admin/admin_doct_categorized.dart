import 'package:hospital_appointment/Controllers/admin_dashboard_controller.dart';
import 'package:hospital_appointment/Controllers/animation_controller.dart';
import 'package:hospital_appointment/Controllers/business_controller.dart';
import 'package:hospital_appointment/Widgets/Admin/admin_horizontal_doct_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class doctorViaHospitals extends StatefulWidget {
  final String userUid, userName, userEmail, hospital;
  // profilePicture;
  final int index;
  const doctorViaHospitals(
      {super.key,
      required this.userUid,
      required this.userName,
      required this.userEmail,
      required this.hospital,
      // required this.profilePicture,
      required this.index});

  @override
  State<doctorViaHospitals> createState() => _doctorViaHospitalsState();
}

class _doctorViaHospitalsState extends State<doctorViaHospitals> {
  var animateController = Get.put(AnimateController());
  var businessController = Get.put(BusinessController());
  final AdminDashboardController adminDashboardController =
      Get.put(AdminDashboardController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((value) {
      getAllHospitals();
    });
  }

  getAllHospitals() {
    adminDashboardController.getdoct(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(
          "${widget.hospital}'s Doctor",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFFE63946),
      ),
      body: Obx(
        () {
          return adminDashboardController.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Color(0xFFE63946),
                ))
              : adminDashboardController.selecteddoct.isEmpty
                  ? Center(
                      child: Text(
                          "No Doctor available in this ${widget.hospital}"),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  adminDashboardController.selecteddoct.length,
                              itemBuilder: (context, index) {
                                print("${adminDashboardController.selecteddoct}");
                                return AdminHorizontaldoctCard(
                                  doctName: adminDashboardController
                                      .selecteddoct[index]["doctName"],
                                  doctContact: adminDashboardController
                                      .selecteddoct[index]["doctContact"],
                                  // doctPlate: adminDashboardController
                                  //     .selecteddoct[index]["doctPlate"],
                                  // doctSize: adminDashboardController
                                  //     .selecteddoct[index]["doctSize"],
                                  description: adminDashboardController
                                      .selecteddoct[index]["description"],
                                  imageUrl: adminDashboardController
                                      .selecteddoct[index]["doctPic"],
                                  index: index,
                                  doctKey: adminDashboardController
                                      .selecteddoct[index]["doctKey"],
                                  userUid: widget.userUid,
                                  userName: widget.userName,
                                  userEmail: widget.userEmail,
                                );
                              })
                        ],
                      ),
                    );
        },
      ),
    );
  }
}
