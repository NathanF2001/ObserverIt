import 'dart:math';
import 'package:collection/collection.dart';
import 'package:observerit/entities/Request.dart';
import 'package:observerit/entities/StatisticsView.dart';
import 'package:observerit/entities/User.dart';
import 'package:observerit/entities/View.dart';

class ViewObserverItService {

  Future<List<ViewObserverIt>> getViewFromUser(User user) async {
    try{
      //await Future.delayed(Duration(seconds: 2));

      List<ViewObserverIt> views = [
        {
          "alias": "UFRPE",
          "url": "www.ufrpe.br",
          "verificationPeriod": 84600
        },
        {
          "alias": "INEP",
          "url": "https://www.gov.br/inep/pt-br/assuntos/noticias",
          "verificationPeriod": 84600
        },
      ].map((jsonValue) {
        int average = Random().nextInt(1000);
        return ViewObserverIt.fromJson({
          ...jsonValue,
          "requests": List.filled(20, null).mapIndexed((index, request) {

            String status = Random().nextDouble() <= 0.8 ? "Available" : "Error";

            return Request.fromJson({
              "status": status,
              "time": Random().nextInt(1000),
              "date": DateTime.parse("2024-06-02").add(Duration(hours: index))
            });
          }).toList(),
          "statistics": StatisticsView.fromJson({
            "average": average,
            "peak": average + Random().nextInt(100) ,
            "uptime": Random().nextInt(300),
            "lastUpdate": DateTime.now()
          })
        });
      }).toList();

      return views;
    } catch( error){
      print(error);
      return [];
    }
  }

  Future<ViewObserverIt> createView(ViewObserverIt viewObserverIt) async {
    await Future.delayed(Duration(seconds: 1));

    return viewObserverIt;
  }
}