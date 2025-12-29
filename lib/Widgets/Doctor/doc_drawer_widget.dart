import 'package:hospital_appointment/Controllers/animation_controller.dart';
import 'package:hospital_appointment/Controllers/fire_controller.dart';
// import 'package:hospital_appointment/Screen/Admin/admin_view_req.dart';
import 'package:hospital_appointment/Screen/Chat/admin_choose_chat.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_appointment/Screen/Doctor/personal_data.dart';

class DocDrawerWidget extends StatefulWidget {
  final String doctUid, accountName, accountEmail;

  const DocDrawerWidget({
    super.key,
    required this.doctUid,
    required this.accountName,
    required this.accountEmail,
  });

  @override
  State<DocDrawerWidget> createState() => _DocDrawerWidgetState();
}

class _DocDrawerWidgetState extends State<DocDrawerWidget> {
  final FireController fireController = Get.put(FireController());
  final AnimateController animateController = Get.put(AnimateController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    fetchData();});
  }

  Future<void> fetchData() async {
    await fireController.fireBaseDataFetch(context, widget.doctUid, "go", '');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Drawer(
        backgroundColor: Colors.white,
        shadowColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 50,
        child: ListView(
          children: [
            fireController.isLoading.value
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * .8,
                    height: MediaQuery.of(context).size.height * .265,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFE63946),
                      ),
                    ),
                  )
                : UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(
                        color:  Color.fromARGB(255, 245, 222, 224)),
                    arrowColor: const Color(0xFFE63946),
                    currentAccountPicture:                           GestureDetector(
                            onTap: () {
                              if (fireController.userData["doctPic"] != null) {
                                animateController.showSecondPage(
                                  "Profile Picture",
                                  fireController.userData["doctPic"] ?? 'assets/images/profilePlaceHolder.jpg',
                                  context,
                                );
                              }
                            },
                            child: Hero(
                              tag: "Profile Picture",
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0xFFE63946),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color: const Color.fromARGB(255, 245, 222, 224),
                                    width: 2,
                                    style: BorderStyle.solid,
                                  ),
                                  image: DecorationImage(
                                    image: fireController.userData["doctPic"] != null
                                        ? CachedNetworkImageProvider(fireController.userData["doctPic"])
                                        : const AssetImage('assets/images/profilePlaceHolder.jpg') as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),

                    accountName: Text(
                      fireController.userData["doctName"] ?? 'Unknown user',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 77, 82, 88),
                        fontWeight: FontWeight.w700,
                        // shadows: [BoxShadow(color: Colors.white, blurRadius: 20)],
                      ),
                    ),
                    accountEmail: Text(
                      fireController.userData["doctEmail"] ?? 'Unknown email',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 77, 82, 88),
                        fontWeight: FontWeight.w700,
                        // shadows: [BoxShadow(color: Colors.white, blurRadius: 20)],
                      ),
                    ),
                  ),
            _buildListTile(
              icon: Icons.person_rounded,
              title: "Personal Data",
              onTap: () {
                Get.to(
                  DoctorPersonalData(
                    imageUrl: fireController.userData["doctPic"]??'',
                    doctName: fireController.userData["doctName"],
                    doctUid: widget.doctUid,
                    doctKey: fireController.userData["doctKey"],
                    gender: fireController.userData["doctGender"],
                    contact: fireController.userData["doctContact"],
                    dob: fireController.userData["dateOfBirth"],
                    address: fireController.userData["doctAddress"],
                    doctEmail: fireController.userData["doctEmail"],
                  ),
                );
              },
            ),
            
            // _buildListTile(
            //   icon: Icons.medical_information,
            //   title: "Requests",
            //   onTap: () {Get.to(ViewRequests(userUid: widget.userUid, userName: fireController.userData["userName"], userEmail: fireController.userData["userEmail"], userProfilePic: fireController.userData["profilePic"],));},
            // ),
            _buildListTile(
              icon: Icons.chat,
              title: "Chats",
              onTap: () {Get.to(AdminChatsScreen(userUid: widget.doctUid, userName: fireController.userData["doctName"], userEmail: fireController.userData["doctEmail"], profilePicture: fireController.userData["doctPic"], status: true,));},
            ),
            _buildListTile(
              icon: Icons.logout,
              title: "LogOut",
              onTap: () {
                fireController.logOut();
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildListTile({required IconData icon, required String title, required Function() onTap}) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFFE63946),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Color(0xFFE63946)),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Color(0xFFE63946),
      ),
      onTap: onTap,
    );
  }
}
