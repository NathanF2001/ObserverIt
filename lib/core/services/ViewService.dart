import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:observerit/core/exceptions/ViewException.dart';
import 'package:observerit/entities/Request.dart';
import 'package:observerit/entities/StatisticsView.dart';
import 'package:observerit/entities/User.dart';
import 'package:observerit/entities/View.dart';

class ViewObserverItService {

  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<ViewObserverIt>> getViewFromUser(UserObserverIt user) async {
    try{

      QuerySnapshot<Map<String, dynamic>> viewFirebase = await db.collection('views').where('userId', isEqualTo: user.id).get();

      List<Future<ViewObserverIt>> newViews =  viewFirebase.docs.map((view)  async {
        final dataView = view.data();

        List<Request> requests = await this.loadRequestsFromViewReference(view.reference);

        StatisticsView statistics = await view.reference.collection('statistics').get().then((snapshot) {
          final snapshotData = snapshot.docs.first.data();
          snapshotData['createTime'] = snapshotData['createTime'].toDate();
          snapshotData['lastUpdate'] = snapshotData['lastUpdate'].toDate();

          return StatisticsView.fromJson({
            ...snapshotData,
            "id": snapshot.docs.first.reference
          });
        });

        return ViewObserverIt.fromJson({
          "alias": dataView['alias'],
          "creationTime": dataView['creationTime'].toDate(),
          "url": dataView['url'],
          "verificationPeriod": dataView['verificationPeriod'],
          "id": view.reference,
          "statistics": statistics,
          "requests": requests
        });
      }).toList();

      List<ViewObserverIt> views = await Future.wait(newViews);

      return views;
    } catch( error){
      print(error);
      return [];
    }
  }

  Future<List<Request>> loadRequestsFromViewReference(DocumentReference viewReference) async {
    QuerySnapshot<Map<String, dynamic>> requestFirebase = await viewReference
        .collection('requests')
        .orderBy('date', descending: true)
        .limit(20)
        .get();

    List<Request> requests =  requestFirebase.docs.map((request) {
      final dataRequest = request.data();

      return Request.fromJson({
        "date": dataRequest['date'].toDate(),
        "status": dataRequest['status'],
        "time": dataRequest['time'],
        "id": request.reference
      });
    }).toList();

    return requests;
  }




  Future<ViewObserverIt> createView(ViewObserverIt viewObserverIt, UserObserverIt user) async {
    try {
      await db.runTransaction((transaction) async {

        DocumentReference viewReference = await db.collection('views').doc();
        transaction.set(viewReference, {
          "userId": user.id,
          "url": viewObserverIt.url,
          "alias": viewObserverIt.alias,
          "verificationPeriod": viewObserverIt.verificationPeriod,
          "nextExecution": viewObserverIt.nextExecution,
          "creationTime":  viewObserverIt.creationTime,
        });

        viewObserverIt.id = viewReference;

        DocumentReference statisticsReference = await viewReference.collection('statistics').doc();

        transaction.set(statisticsReference,{
          ...viewObserverIt.statistics!.toJson(),
        });

        viewObserverIt.statistics!.id = statisticsReference;

        DocumentReference requestReference = await viewReference.collection('requests').doc();
        transaction.set(requestReference, {
          ...viewObserverIt.requests![0].toJson(),
          "viewReference": viewReference
        });

        viewObserverIt.requests![0].id = requestReference;

      });

      return viewObserverIt;
    } catch (error) {
      throw  ViewException("Unable to create View");
    }
  }

  updateNextExecutation(DocumentReference viewReference, DateTime nextExecutation) async {

    await viewReference.update({
      "nextExecutation": nextExecutation
    });
  }

  updateViewConfiguration(
      DocumentReference viewReference,
      String alias,
      int period
      ) async {

    await viewReference.update({
      "alias": alias,
      "verificationPeriod": period
    });
  }

  deleteView(DocumentReference viewReference) async {
    await viewReference.delete();
  }


}