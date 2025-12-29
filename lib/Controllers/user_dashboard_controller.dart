import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserDashboardController extends GetxController{
  RxBool isLoading = false.obs;
  var usersMap = <Map<String, dynamic>>[].obs;
  var userCount = 0.obs;
  var hos = <Map<String, dynamic>>[].obs;
  var hosCount = 0.obs;
  var doct = <Map<String, dynamic>>[].obs;
  var doctCount = 0.obs;
  RxList<Map<String, dynamic>> selecteddoct = <Map<String, dynamic>>[].obs;

  setLoading(val){
    isLoading.value = val;
  }


    // Function to get dashboard data
  void getDashBoardData() {
    fetchHospitals();
    fetchdoct();
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
        if (data != null && data['HosKey'] != null && hospitals['HosKey'] != null) {
          if (data['HosKey'] == hospitals['HosKey']) {
            count++;
          }
        }
      }
      hospitals['doctCount'] = count; // Add doct count to each Hospitals
    }

      update(); // Notify listeners
    });
  }

  // Get Dishes via Hospitals
  Future<void> getdoct(int index,) async {

    hos.refresh(); // To trigger UI updates

    if (hos[index]["HosKey"] == "") {
      CollectionReference doctInst = FirebaseFirestore.instance.collection("Doctor");
      await doctInst.get().then((QuerySnapshot data) {
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