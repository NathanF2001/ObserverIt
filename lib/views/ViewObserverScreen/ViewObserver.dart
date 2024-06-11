import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:observerit/core/services/URLRequesterService.dart';
import 'package:observerit/entities/Request.dart';
import 'package:observerit/entities/UrlResponse.dart';
import 'package:observerit/entities/View.dart';
import 'package:observerit/shared/widgets/Buttons/DefaultButton.dart';
import 'dart:math';

import 'package:observerit/shared/widgets/Dialog/DefaultDialog.dart';
import 'package:observerit/shared/widgets/Dialog/LoadingDialog.dart';

class ViewObserverScreen extends StatefulWidget {
  ViewObserverIt viewObserverIt;

  ViewObserverScreen({super.key, required this.viewObserverIt});

  @override
  State<ViewObserverScreen> createState() => _ViewObserverScreenState();
}

class _ViewObserverScreenState extends State<ViewObserverScreen> {
  ViewObserverIt get viewObserverIt => widget.viewObserverIt;
  UrlRequesterService urlRequesterService = UrlRequesterService();

  @override
  Widget build(BuildContext context) {
    final String nameScreen = viewObserverIt.alias!;

    return Scaffold(
        appBar: AppBar(
          title: Text(nameScreen),
          foregroundColor: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: DefaultButton(
                    text: "Run one request now",
                    onPressed: () async {

                      bool loadingClosed = true;

                      LoadingDialog.build(context, "Making Request").then((value) {
                        loadingClosed = false;
                      });

                      UrlResponse urlResponse = await urlRequesterService.requestUrl(viewObserverIt.url!);

                      if (loadingClosed) Navigator.of(context).pop();

                      viewObserverIt.requests!.add(Request.fromJson({
                        "status": urlResponse.statusCode == 200
                            ? "Available"
                            : "Error",
                        "date": urlResponse.runDate,
                        "time": urlResponse.timeMS
                      }));

                      viewObserverIt.statistics!.lastUpdate = urlResponse.runDate!;
                      
                      List<int> times = viewObserverIt.requests!.map((view) {
                        return view.time!;
                      }).toList();

                      if (viewObserverIt.requests!.length > 20) {
                        viewObserverIt.requests = viewObserverIt.requests!.sublist(1);
                      }
                      
                      viewObserverIt.statistics!.average = double.parse((times.reduce((a,b) => a + b) / times.length).toStringAsFixed(2));
                      viewObserverIt.statistics!.peak = times.reduce(max);

                      DefaultDialog.build(context, "Request Success", "The request was successful!");
                    },
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text("WIP", style: TextStyle(fontSize: 24, color: Colors.grey),),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
