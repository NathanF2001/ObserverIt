import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:observerit/core/helpers/ViewUtils.dart';
import 'package:observerit/core/services/URLRequesterService.dart';
import 'package:observerit/core/services/ViewService.dart';
import 'package:observerit/entities/UrlResponse.dart';
import 'package:observerit/entities/User.dart';
import 'package:observerit/entities/View.dart';
import 'package:observerit/shared/widgets/Buttons/DefaultButton.dart';
import 'package:observerit/shared/widgets/Dialog/ConfirmDialog.dart';
import 'package:observerit/shared/widgets/Dialog/DefaultDialog.dart';
import 'package:observerit/shared/widgets/Inputs/AppInput.dart';
import 'package:observerit/views/CreateView/CreateViewValidators.dart';

class UpdateView extends StatefulWidget {

  ViewObserverIt view;

  UpdateView({super.key, required this.view});

  @override
  State<UpdateView> createState() => _UpdateViewState();
}

class _UpdateViewState extends State<UpdateView> {

  ViewObserverIt get view => widget.view;

  final aliasControl = TextEditingController();
  final periodControl = TextEditingController();
  final periodTypeControl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  ViewObserverItService viewObserverItService = ViewObserverItService();

  String initialAlias = '';
  String initialPeriod = '';
  String initialTypePeriod = '';

  @override
  void initState() {
    super.initState();
    aliasControl.text = view.alias!;
    initialAlias = view.alias!;

    final periodConfig = ViewUtils.getPeriodAndTypeByTotal(view.verificationPeriod!);
    initialTypePeriod =  periodConfig["type"];
    periodTypeControl.text  = periodConfig["type"];
    periodControl.text  = periodConfig["period"];
    initialPeriod = periodConfig['period'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View"),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(onPressed: () async{
            bool deleteView = await ConfirmDialog.build(context, "Delete View", "Are you sure you want to delete the view?");

            if (deleteView){

              viewObserverItService.deleteView(view.id!);

              Navigator.of(context).pop("DELETE");
            }
          }, icon: Icon(Icons.delete))
        ],
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
                    "Update View",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Update the settings for your view",
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
                        print(initialTypePeriod);
                        print(initialPeriod);
                        print(initialAlias);
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
                padding: const EdgeInsets.all(16),
                child: DefaultButton(
                  onPressed: () async {
                    final bool? isValid =
                    _formKey.currentState?.validate();
                    if (isValid! && (initialAlias != aliasControl.text || initialPeriod != periodControl.text || initialTypePeriod != periodTypeControl.text)) {

                      int totalHoursPeriod = ViewUtils.getTotalHoursPeriod( int.parse(periodControl.text), periodTypeControl.text);

                      viewObserverItService.updateViewConfiguration(view.id!, aliasControl.text, totalHoursPeriod);

                      view.alias = aliasControl.text;
                      view.verificationPeriod = totalHoursPeriod;
                      
                      await DefaultDialog.build(context, "View Updated", "Your changes were applied successfully");
                      Navigator.of(context).pop("UPDATE");
                    } else {

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Configuration not changed'),
                      ));
                    }
                  },
                  text: 'Update View Configuration',


                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
