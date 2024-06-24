import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:observerit/core/exceptions/RequestException.dart';
import 'package:observerit/entities/Request.dart';
import 'package:observerit/entities/StatisticsView.dart';

class RequestService {
  FirebaseFirestore db = FirebaseFirestore.instance;
  addRequest(DocumentReference viewReference, StatisticsView statistics,
      Request request) async {
    await db.runTransaction((transaction) async {
      transaction.set(statistics.id!, statistics.toJson());

      DocumentReference requestReference =
          viewReference.collection('requests').doc();

      transaction.set(requestReference,
          {...request.toJson(), "viewReference": viewReference});
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> ListPagedRequestsFromView(
      DocumentReference viewReference,
      int totalViews,
      DocumentSnapshot? lastRequest) async {
    try {
      Query<Map<String, dynamic>> query = viewReference
          .collection('requests')
          .orderBy('date', descending: true)
          .limit(totalViews);

      QuerySnapshot<Map<String, dynamic>> requestFirebase;
      if (lastRequest == null) {
        requestFirebase = await query.get();
      } else {
        requestFirebase = await query.startAfterDocument(lastRequest).get();
      }

      return requestFirebase;
    } catch (error) {
      throw RequestException('Error to Load Requests');
    }
  }
}
