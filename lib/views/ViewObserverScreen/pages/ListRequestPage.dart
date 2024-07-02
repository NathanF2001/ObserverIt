import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:observerit/core/exceptions/RequestException.dart';
import 'package:observerit/core/services/RequestService.dart';
import 'package:observerit/entities/Request.dart';
import 'package:observerit/entities/View.dart';
import 'package:observerit/shared/widgets/Buttons/DefaultButton.dart';
import 'package:observerit/shared/widgets/Dialog/DefaultDialog.dart';
import 'package:observerit/views/ViewObserverScreen/widgets/StatusPill.dart';

class ListRequestPage extends StatefulWidget {
  ViewObserverIt view;

  ListRequestPage({super.key, required this.view});

  @override
  State<ListRequestPage> createState() => _ListRequestPageState();
}

class _ListRequestPageState extends State<ListRequestPage> {
  RequestService requestService = RequestService();

  List<Request> requests = [];

  int limitRequest = 15;
  bool _hasNext = true;
  DocumentSnapshot? lastSnaphost = null;
  bool _isfetchingRequests = false;

  @override
  void initState() {
    super.initState();
    _isfetchingRequests = true;
    fetchRequests();
  }

  Future fetchRequests() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshotRequests =
          await requestService.ListPagedRequestsFromView(
              widget.view.id!, limitRequest, lastSnaphost);

      if (querySnapshotRequests.docs.length > 0)
        lastSnaphost = querySnapshotRequests.docs.last;

      if (querySnapshotRequests.docs.length < limitRequest) _hasNext = false;

      setState(() {
        querySnapshotRequests.docs.forEach((snapshot) {
          final dataRequest = snapshot.data();
          requests.add(Request.fromJson({
            "date": dataRequest['date'].toDate(),
            "status": dataRequest['status'],
            "time": dataRequest['time'],
            "id": snapshot.reference
          }));
        });

        if (requests.length == widget.view.statistics!.total) _hasNext = false;
      });

      _isfetchingRequests = false;
    } on RequestException catch (error) {
      print(error);
      DefaultDialog.build(context, "Request Failed", error.message);
    }
  }

  formatData(DateTime date) {
    return "${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Request History"),
          foregroundColor: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                Table(
          
                  columnWidths: const <int, TableColumnWidth>{
                    0: FlexColumnWidth(),
                    1: FlexColumnWidth(),
                    2: IntrinsicColumnWidth(),
                  },
          
                  children: [
                    TableRow(
          
                        children: [
                          Container(
                            height: 40,
                            child: const Text(
                              textAlign: TextAlign.center,
                              "Date",
                              style: TextStyle(
                                  color: Colors.black, fontWeight: FontWeight.w800, fontSize: 18),
                            ),
                          ),
                          Container(
                            height: 40,
                            child: const Text(
                              textAlign: TextAlign.center,
                              "Time",
                              style: TextStyle(
                                  color: Colors.black, fontWeight: FontWeight.w800, fontSize: 18),
                            ),
                          ),
                          Container(
                              height: 40,
                              child: const Text(
                                "Status",
                                style: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.w800, fontSize: 18),
                                textAlign: TextAlign.center,
                              ))
                        ]),
                    ...requests.map(
                      (request) => TableRow(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Colors.black12))),
                          children: [
                            Container(
                              height: 40,
                              child: Align(
                                child: Text(
                                  formatData(request.date!),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ),
                            ),
                            Container(
                              height: 40,
                              child: Align(
                                child: Text(
                                  "${request.time} ms",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ),
                            ),
                            Container(
                              height: 40,
                              child: Align(child: StatusPill(status: request.status!)),
                            )
                          ]),
                    ),
                  ],
                ),

                _hasNext && !_isfetchingRequests
                    ? Container(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: DefaultButton(
                    text: "Load more Requests",
                    onPressed: () {
                      _isfetchingRequests = true;
                      fetchRequests();
                    },
                  ),
                )
                    : Container(),
                _isfetchingRequests
                    ? Center(
                  child: CircularProgressIndicator(),
                )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
