import 'package:hospital_appointment/Screen/Doctor/docDashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hospital_appointment/Widgets/notification_message.dart';

class AdminDashboardController extends GetxController{
  RxBool isLoading = false.obs;
  var usersMap = <Map<String, dynamic>>[].obs;
  var userCount = 0.obs;
  var hos = <Map<String, dynamic>>[].obs;
  var hosCount = 0.obs;
  var req = <Map<String, dynamic>>[].obs;
  var reqCount = 0.obs;
  var doct = <Map<String, dynamic>>[].obs;
  var doctCount = 0.obs;
  RxList<Map<String, dynamic>> selecteddoct = <Map<String, dynamic>>[].obs;

  setLoading(val){
    isLoading.value = val;
  }

    // Function to get dashboard data
  void getDashBoardData() {
    fetchUsers();
    fetchHospitals();
    fetchRequests();
    fetchdoct();
  }
    // Function to fetch all users from the 'user' collection
  void fetchUsers() {
    FirebaseFirestore.instance.collection("User").snapshots().listen((QuerySnapshot snapshot) async {
      usersMap.clear();
      userCount.value = 0;

      try {
        for (var doc in snapshot.docs) {
          usersMap.add(doc.data() as Map<String, dynamic>);
          userCount.value = usersMap.length;
        }

      } catch (e) {
        print("Error fetching users: $e");
      }
    });
  }
  
  // Function to fetch all leave requests
  void fetchHospitals() {
    FirebaseFirestore.instance.collection("Hospitals").where("status", isEqualTo: true).snapshots().listen((QuerySnapshot snapshot) {
      hos.clear();
      hosCount.value = 0;

      for (var doc in snapshot.docs) {
        hos.add(doc.data() as Map<String, dynamic>);
        hosCount.value = hos.length;
      }
    });
  }  

  // Function to fetch all leave requests
  void fetchRequests() {
    FirebaseFirestore.instance.collection("Requests").snapshots().listen((QuerySnapshot snapshot) {
      req.clear();
      reqCount.value = 0;

      for (var doc in snapshot.docs) {
        req.add(doc.data() as Map<String, dynamic>);
        reqCount.value = req.length;
      }
    });
  }
   Future<void> updateRequest(String reqKey, String status, String userUid, String userName, String userEmail, String doctKey) async {
    try {
      await FirebaseFirestore.instance
          .collection('Requests')
          .doc(reqKey)
          .update({"status" : status});
      notify('Success','Request updated successfully!');
      Get.off(() => DoctorScreen(doctUid: userUid, doctName: userName, doctEmail: userEmail, doctKey: doctKey,));
    } catch (e) {
      notify('error','Error updating request: $e');
    }
  }
  // Function to fetch all leave requests
  void fetchdoct() {
    FirebaseFirestore.instance.collection("Doctor")
    .snapshots().listen((QuerySnapshot snapshot) {
      doct.clear();
      doctCount.value = 0;

      for (var doc in snapshot.docs) {
        doct.add(doc.data() as Map<String, dynamic>);
        doctCount.value = doct.length;
      }
      // Count doct per hospitals
    for (var hospitals in hos) {
      int count = 0;
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>?; // Make sure data is not null
        if (data != null && data["HosKey"] != null && hospitals["HosKey"] != null) {
          if (data["HosKey"] == hospitals["HosKey"]) {
            count++;
          }
        }
      }
      hospitals['doctCount'] = count; // Add post count to each hospitals
    }

      update(); // Notify listeners
    });
  }

  // Get Dishes via Hospitals
  Future<void> getdoct(int index,) async {

    hos.refresh(); // To trigger UI updates

    if (hos[index]["HosKey"] == "") {
      CollectionReference postInst = FirebaseFirestore.instance.collection("Doctor");
      await postInst.get().then((QuerySnapshot data) {
        var alldoctData = data.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        selecteddoct.value = alldoctData;
      });
    } else {
      CollectionReference dishInst = FirebaseFirestore.instance.collection("Doctor");
      await dishInst
          .where("HosKey", isEqualTo: hos[index]["HosKey"])
          .get()
          .then((QuerySnapshot data) {
        var alldoctData = data.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        selecteddoct.value = alldoctData;
      });
    }
  }




}