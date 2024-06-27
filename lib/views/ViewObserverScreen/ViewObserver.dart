import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:observerit/core/exceptions/RequestException.dart';
import 'package:observerit/core/helpers/ViewUtils.dart';
import 'package:observerit/core/services/RequestService.dart';
import 'package:observerit/core/services/StatisticsService.dart';
import 'package:observerit/core/services/URLRequesterService.dart';
import 'package:observerit/core/services/ViewService.dart';
import 'package:observerit/entities/Request.dart';
import 'package:observerit/entities/UrlResponse.dart';
import 'package:observerit/entities/View.dart';
import 'package:observerit/shared/widgets/Buttons/DefaultButton.dart';
import 'dart:math';

import 'package:observerit/shared/widgets/Dialog/DefaultDialog.dart';
import 'package:observerit/shared/widgets/Dialog/LoadingDialog.dart';
import 'package:observerit/views/CreateView/UpdateView.dart';
import 'package:observerit/views/ViewObserverScreen/widgets/AgentRequestCard.dart';
import 'package:observerit/views/ViewObserverScreen/widgets/CardRequestAvailability.dart';
import 'package:observerit/views/ViewObserverScreen/widgets/CardUrlView.dart';
import 'package:observerit/views/ViewObserverScreen/widgets/RequestHistoryStatistics.dart';

class ViewObserverScreen extends StatefulWidget {
  ViewObserverIt viewObserverIt;

  ViewObserverScreen({super.key, required this.viewObserverIt});

  @override
  State<ViewObserverScreen> createState() => _ViewObserverScreenState();
}

class _ViewObserverScreenState extends State<ViewObserverScreen> {
  ViewObserverIt get viewObserverIt => widget.viewObserverIt;
  UrlRequesterService urlRequesterService = UrlRequesterService();
  StatisticsService statisticsService = StatisticsService();
  RequestService requestService = RequestService();
  ViewObserverItService viewObserverItService = ViewObserverItService();

  addRequest(Request request) async {
    try {
      updateStatistics(request);

      await requestService.addRequest(viewObserverIt.id!, viewObserverIt.statistics!, request);

      int totalHoursPeriod = viewObserverIt.verificationPeriod!;

      viewObserverIt.nextExecution = DateTime.timestamp().add(Duration(hours: totalHoursPeriod));

      await viewObserverItService.updateNextExecutation(viewObserverIt.id!, viewObserverIt.nextExecution!);
    } catch (error){
      print(error);
      throw const RequestException("Unable to save request status. Try again later");
    }

  }

  updateStatistics(Request request) async {
    int total = viewObserverIt.statistics!.total!;

    double newAverage = (total*viewObserverIt.statistics!.average! + request.time!) / (total+1);
    int newPeak = max(viewObserverIt.statistics!.peak!, request.time!);

    viewObserverIt.statistics!.peak = newPeak;
    viewObserverIt.statistics!.average = newAverage;
    viewObserverIt.statistics!.total = total + 1;
    viewObserverIt.statistics!.lastUpdate = request.date!;

  }

  Future<UrlResponse> makeRequest(BuildContext context) async {
    try {
      bool loadingClosed = true;

      LoadingDialog.build(context, "Making Request").then((value) {
        loadingClosed = false;
      });

      UrlResponse urlResponse = await urlRequesterService.requestUrl(viewObserverIt.url!);

      if (loadingClosed) Navigator.of(context).pop();

      return urlResponse;
    } catch (error) {
      throw const RequestException("Unable to request URL. Try again later");
    }
  }

  @override
  Widget build(BuildContext context) {
    final String nameScreen = viewObserverIt.alias!;

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(nameScreen),
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).primaryColor,
            actions: [
              IconButton(onPressed: () async{
                final updatePage = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => UpdateView(view: widget.viewObserverIt,),
                  ),
                );

                if (updatePage == "UPDATE") {
                  setState(() {

                  });
                } else if (updatePage == "DELETE") {
                  Navigator.of(context).pop("DELETE");
                }
              }, icon: Icon(Icons.settings))
            ],
          ),
          body: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: DefaultButton(
                  text: "Run one request now",
                  onPressed: () async {

                    try {
                      UrlResponse urlResponse = await makeRequest(context);

                      Request request = Request.fromJson({
                        "status": urlResponse.statusCode.toString()[0] == "2"
                            ? "Available"
                            : "Error",
                        "date": urlResponse.runDate,
                        "time": urlResponse.timeMS
                      });

                      await addRequest(request);

                      viewObserverIt.requests!.add(request);

                      if (viewObserverIt.requests!.length > 20) {
                        viewObserverIt.requests = viewObserverIt.requests!.sublist(1);
                      }

                      DefaultDialog.build(context, "Request Success", "The request was successful!");
                    } on RequestException catch (error) {
                      DefaultDialog.build(context, "Request Failed", error.message);
                    }
                  },
                ),
              ),
              CardUrlView(view: viewObserverIt),
              SizedBox(height: 20,),
              AgentRequestCard(view: viewObserverIt,),
              SizedBox(height: 20,),
              CardRequestAvailability(view: viewObserverIt,),
              SizedBox(height: 20,),
              RequestHistoryStatistics(requests: viewObserverIt.requests!, statistics: viewObserverIt.statistics!,),
              SizedBox(height: 20,),

            ],
          )),
    );
  }
}
