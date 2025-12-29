import 'package:hospital_appointment/Controllers/animation_controller.dart';
import 'package:hospital_appointment/Controllers/user_dashboard_controller.dart';
import 'package:hospital_appointment/Widgets/User/user_horizontal_doct_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserdoctorViaHospitals extends StatefulWidget {
  final String userUid, userName, userEmail;
  // profilePicture;
  final int index;
  const UserdoctorViaHospitals(
      {super.key,
      required this.userUid,
      required this.userName,
      required this.userEmail,
      // required this.profilePicture,
      required this.index});

  @override
  State<UserdoctorViaHospitals> createState() => _UserdoctorViaHospitalsState();
}

class _UserdoctorViaHospitalsState extends State<UserdoctorViaHospitals> {
  var animateController = Get.put(AnimateController());
  final UserDashboardController userDashboardController  =
      Get.put(UserDashboardController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((value) {
      getAllHospitals();
    });
  }

  getAllHospitals() {
    userDashboardController.getdoct(widget.index);
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
        title: const Text(
          "View Doctors",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFFE63946),
      ),
      body: Obx(
        () {
          return userDashboardController.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Color(0xFFE63946),
                ))
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              userDashboardController.selecteddoct.length,
                          itemBuilder: (context, index) {
                            return  UserHorizontaldoctCard(
                                  doctName: userDashboardController
                                  .selecteddoct[index]["doctName"],
                                  doctContact: userDashboardController
                                  .selecteddoct[index]["doctContact"],
                                  // doctPlate: userDashboardController
                                  // .selecteddoct[index]["doctPlate"],
                                  // doctSize: userDashboardController
                                  // .selecteddoct[index]["doctSize"],
                                  description: userDashboardController
                                  .selecteddoct[index]["description"],
                                  imageUrl: userDashboardController
                                  .selecteddoct[index]["doctPic"],
                                  index: index,
                                  doctKey: userDashboardController
                                  .selecteddoct[index]["doctKey"],
                                  hosName: userDashboardController
                                  .selecteddoct[index]["hospital"],
                                  docUid: userDashboardController.selecteddoct[index]["doctUid"],
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
