import 'package:amplify_flutter/amplify_flutter.dart' hide QuerySnapshot;
import 'package:cloud_firestore/cloud_firestore.dart';

class SchoolsDetailsFirestoreService {
  static Future<List<String>> FetchDistricts() async {
    List<String> districtsList = [];
    try {
      CollectionReference districtsCollection = FirebaseFirestore.instance
          .collection("districts");
      final QuerySnapshot data = await districtsCollection.get();
      for (var doc in data.docs) {
        districtsList.add(doc.id);
      }
    } catch (e) {
      safePrint("error is $e & ${e.toString()}");
    }
    return districtsList;
  }

  static Future fetchMandalsByDistrict(String districts) async {
    List<String> mandalList = [];
    try {
      CollectionReference mandalCollection = FirebaseFirestore.instance
          .collection("districts")
          .doc(districts)
          .collection('mandals');
      final QuerySnapshot data = await mandalCollection.get();
      for (var doc in data.docs) {
        mandalList.add(doc.id);
      }
    } catch (e) {
      safePrint("error is $e & ${e.toString()}");
    }
    return mandalList;
  }

  static Future fetchSchoolsByMandal(String districts, String mandals) async {
    List<String> schoolsList = [];
    try {
      CollectionReference schoolsCollection = FirebaseFirestore.instance
          .collection("districts")
          .doc(districts)
          .collection('mandals')
          .doc(mandals)
          .collection('schools')
      ;
      final QuerySnapshot data = await schoolsCollection.where('isSelected', isEqualTo: true).get();
      for (var doc in data.docs) {
        schoolsList.add(doc.id);
      }
    } catch (e) {
      safePrint("error is $e & ${e.toString()}");
    }
    return schoolsList;
  }


}