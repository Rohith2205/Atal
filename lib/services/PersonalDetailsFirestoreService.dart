import 'package:amplify_flutter/amplify_flutter.dart' hide QuerySnapshot;
import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalDetailsFirestoreService{
  static Future<List<String>> FetchAffiliatedUniversities() async {
     List<String> universitiesList = [];
    try{
      CollectionReference affiliatedUniversitiesCollection = FirebaseFirestore.instance.collection("affiliatedUniversities");
      final QuerySnapshot data = await affiliatedUniversitiesCollection.get();
      for (var doc in data.docs) {
        universitiesList.add(doc.id);
      }

    }catch(e){
      safePrint("error is $e & ${e.toString()}");
    }
    return universitiesList;
  }

  static Future fetchMandalsByDistrict(String affiliatedUniversity, String district) async {
    List<String> mandalList = [];
    try{
      CollectionReference mandalCollection = FirebaseFirestore.instance.collection("affiliatedUniversities")
      .doc(affiliatedUniversity)
      .collection('districts')
      .doc(district)
      .collection('mandals');
      final QuerySnapshot data = await mandalCollection.get();
      for (var doc in data.docs) {
        mandalList.add(doc.id);
      }

    }catch(e){
      safePrint("error is $e & ${e.toString()}");
    }
    return mandalList;
  }

  static Future fetchCollegesByMandal(String affiliatedUniversity,String districtId, String mandalId) async {
    List<String> collegesList = [];
    try{
      CollectionReference collegesCollection = FirebaseFirestore.instance.collection("affiliatedUniversities")
          .doc(affiliatedUniversity)
          .collection('districts')
      .doc(districtId)
      .collection('mandals')
      .doc(mandalId)
      .collection('colleges');
      final QuerySnapshot data = await collegesCollection.get();
      for (var doc in data.docs) {
        collegesList.add(doc.id);
      }

    }catch(e){
      safePrint("error is $e & ${e.toString()}");
    }
    return collegesList;
  }


  static Future fetchDistrictsByUniversity(String affiliatedUniversity) async {
    List<String> districtList = [];
    try{
      CollectionReference districtsCollection = FirebaseFirestore.instance.collection("affiliatedUniversities")
          .doc(affiliatedUniversity)
          .collection('districts');
      final QuerySnapshot data = await districtsCollection.get();
      for (var doc in data.docs) {
        districtList.add(doc.id);
      }

    }catch(e){
      safePrint("error is $e & ${e.toString()}");
    }
    return districtList;
  }
}