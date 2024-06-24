import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:observerit/core/helpers/ViewUtils.dart';
import 'package:observerit/core/services/URLRequesterService.dart';
import 'package:observerit/core/services/ViewService.dart';
import 'package:observerit/entities/Request.dart';
import 'package:observerit/entities/StatisticsView.dart';
import 'package:observerit/entities/UrlResponse.dart';
import 'package:observerit/entities/User.dart';
import 'package:observerit/entities/View.dart';
import 'package:observerit/shared/widgets/Buttons/DefaultButton.dart';
import 'package:observerit/shared/widgets/Buttons/SecondButton.dart';
import 'package:observerit/shared/widgets/Inputs/AppInput.dart';
import 'package:observerit/views/CreateView/CreateViewValidators.dart';

class CreateView extends StatefulWidget {

  UserObserverIt user;

  CreateView({super.key, required this.user});

  @override
  State<CreateView> createState() => _CreateViewState();
}

class _CreateViewState extends State<CreateView> {

  UserObserverIt get user => widget.user;

  final aliasControl = TextEditingController();
  final urlControl = TextEditingController();
  final periodControl = TextEditingController();
  final periodTypeControl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool urlVerified = false;

  UrlResponse? urlResponse = null;

  UrlRequesterService urlRequesterService = UrlRequesterService();
  ViewObserverItService viewObserverItService = ViewObserverItService();

  @override
  void initState() {
    super.initState();
    periodTypeControl.text = 'Hours';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View"),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Create View",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Configure the initial settings for your view",
                    style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppInput(
                      labelText: "Alias",
                      hintText: "Type your View Alias",
                      validator: CreateViewValidators.aliasValidator,
                      controller: aliasControl,
                    ),
                    SizedBox(height: 20),
                    AppInput(
                      labelText: "Url",
                      hintText: "Type your View Url",
                      controller: urlControl,
                      validator: CreateViewValidators.urlValidator,
                      onChanged: (value) {
                        if (urlVerified) {
                          setState(() {
                            urlVerified = false;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    AppInput(
                      labelText: "Total Period",
                      hintText: "Type the request frequency",
                      validator: (value) =>
                          CreateViewValidators.periodValidator(
                              value, periodTypeControl.text),
                      keyboardType: TextInputType.number,
                      controller: periodControl,
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField(
                      onChanged: (value) {
                        periodTypeControl.text = value;
                      },
                      value: periodTypeControl.text,
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: "Type Period",
                          labelStyle: TextStyle(
                            fontSize: 22,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                          hintText: "Choose the type period",
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xFF6A4AC5), width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16)),
                      items: ["Hours", "Days", "Weeks"]
                          .map<DropdownMenuItem>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 32),
                child: SecondButton(
                  text: "Test Route",
                  onPressed: () async {
                    bool? validForm =
                        CreateViewValidators.urlValidator(urlControl.text) ==
                            null;

                    if (validForm) {
                      UrlResponse? validUrl = await _dialogBuilder(context);

                      setState(() {
                        urlVerified = validUrl != null;
                        urlResponse = validUrl;
                      });
                    }
                  },
                  padding: "2",
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: DefaultButton(
                  onPressed: urlVerified
                      ? () async {
                          final bool? isValid =
                              _formKey.currentState?.validate();
                          if (isValid!) {

                            int totalHoursPeriod = ViewUtils.getTotalHoursPeriod( int.parse(periodControl.text), periodTypeControl.text);

                            ViewObserverIt view =
                                await viewObserverItService.createView(
                              ViewObserverIt.fromJson({
                                "alias": aliasControl.text,
                                "url": urlControl.text,
                                "verificationPeriod":
                                  totalHoursPeriod,
                                "nextExecution": DateTime.timestamp().add(Duration(hours: totalHoursPeriod)),
                                "requests": [
                                  Request.fromJson({
                                    "status": urlResponse!.statusCode == 200
                                        ? "Available"
                                        : "Error",
                                    "date": urlResponse!.runDate,
                                    "time": urlResponse!.timeMS
                                  })
                                ],
                                "statistics": StatisticsView.fromJson({
                                  "average": urlResponse!.timeMS!.toDouble(),
                                  "peak": urlResponse!.timeMS,
                                  "uptime": 0,
                                  "lastUpdate": urlResponse!.runDate,
                                  "createTime": urlResponse!.runDate,
                                  "total": 1
                                })
                              }),
                                  user
                            );

                            Navigator.of(context).pop(view);
                          }
                        }
                      : null,
                  text: 'Create Observation',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> _dialogBuilder(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder(
            future: urlRequesterService.requestUrl(urlControl.text),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.none) {
                return AlertDialog(
                  content: Container(
                    width: 200,
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          Text("Making request")
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                UrlResponse urlResponse = snapshot.data!;

                if (urlResponse.contentType!.contains('text/html') &&
                    urlResponse.statusCode == 200) {
                  return AlertDialog(
                    title: const Text('Valid Url'),
                    content: Container(
                      width: 200,
                      height: 50,
                      child: Column(
                        children: [Text("Your url is valid to be monitored")],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('close'),
                        onPressed: () {
                          Navigator.of(context).pop(urlResponse);
                        },
                      ),
                    ],
                  );
                } else {
                  return AlertDialog(
                    title: const Text('Invalid Url'),
                    content: Container(
                      width: 200,
                      height: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your url is not valid to be monitored",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          urlResponse.contentType!.contains('text/html')
                              ? Text("Invalid page (not of HTML type)")
                              : Text("Valid page"),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Status Code: ${urlResponse.statusCode}"),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('close'),
                        onPressed: () {
                          Navigator.of(context).pop(null);
                        },
                      ),
                    ],
                  );
                }
              }
            });
      },
    );
  }
}
