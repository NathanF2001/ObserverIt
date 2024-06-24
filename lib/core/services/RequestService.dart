import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:observerit/entities/Request.dart';
import 'package:observerit/entities/StatisticsView.dart';

class RequestService {

  FirebaseFirestore db = FirebaseFirestore.instance;
  addRequest(DocumentReference viewReference,StatisticsView statistics, Request request) async {

    await db.runTransaction((transaction) async {
      transaction.set(statistics.id!, statistics.toJson());

      DocumentReference requestReference = viewReference.collection('requests').doc();

      transaction.set(requestReference, {
        ...request.toJson(),
        "viewReference": viewReference
      });
    });

  }
}