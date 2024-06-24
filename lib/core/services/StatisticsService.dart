import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:observerit/entities/StatisticsView.dart';

class StatisticsService {

  FirebaseFirestore db = FirebaseFirestore.instance;

  updateStatistics(StatisticsView statistics) async {
    await statistics.id!.set(statistics.toJson());
  }
}