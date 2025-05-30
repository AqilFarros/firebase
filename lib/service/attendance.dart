import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AttendanceServie {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, int>> checkInCount() async {
    String userId = _auth.currentUser!.uid;
    Map<String, int> count = {
      'checkIn': 0,
      'Attendance': 0,
      'Late': 0,
      'Absent': 0,
    };

    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('attendance')
        .where('description', whereIn: ['Attendance', 'Late', 'Absent']).get();

    for (var doc in snapshot.docs) {
      String status = doc['description'];
      if (count.containsKey(status)) count[status] = count[status]! + 1;
    }

    count['checkIn'] = snapshot.docs.length;

    return count;
  }

  Future<Map<String, int>> checkOutCount() async {
    String userId = _auth.currentUser!.uid;
    Map<String, int> count = {
      'checkOut': 0,
      'Sick': 0,
      'Permission': 0,
      'Other': 0,
    };

    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('attendance')
        .where('description', whereIn: ['Sick', 'Permission', 'Other']).get();

    for (var doc in snapshot.docs) {
      String status = doc['description'];
      if (count.containsKey(status)) count[status] = count[status]! + 1;
    }

    count['checkOut'] = snapshot.docs.length;

    return count;
  }

  Stream<Map<String, List<DocumentSnapshot>>> getGroupAttendanceStream() {
    String userId = _auth.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('attendance')
        .snapshots()
        .map((snapshot) {
      Map<String, List<DocumentSnapshot>> groupedData = {
        'Attendance': [],
        'Late': [],
        'Absent': [],
        'Sick': [],
        'Permission': [],
        'Other': [],
      };

      for (var doc in snapshot.docs) {
        String status = doc['description'];
        if (groupedData.containsKey(status)) groupedData[status]!.add(doc);
      }

      return groupedData;
    });
  }
}
