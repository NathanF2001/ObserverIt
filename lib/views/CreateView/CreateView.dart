import 'package:flutter/material.dart';
import 'package:observerit/shared/widgets/Inputs/AppInput.dart';

class CreateView extends StatefulWidget {
  const CreateView({super.key});

  @override
  State<CreateView> createState() => _CreateViewState();
}

class _CreateViewState extends State<CreateView> {
  @override
  Widget build(BuildContext context) {
    final aliasControl = TextEditingController();
    final urlControl = TextEditingController();
    final periodControl = TextEditingController();
    final periodTypeControl = TextEditingController();

    periodTypeControl.text = 'Hours';

    final _formKey = GlobalKey<FormState>();

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
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppInput(
                        labelText: "Alias",
                        hintText: "Type your View Alias",
                        controller: aliasControl,
                      ),
                      SizedBox(height: 20),
                      AppInput(
                        labelText: "Url",
                        hintText: "Type your View Url",
                        controller: urlControl,
                      ),
                      SizedBox(height: 20),
                      AppInput(
                        labelText: "Total Period",
                        hintText: "Type the request frequency",
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF6A4AC5), width: 2),
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
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
