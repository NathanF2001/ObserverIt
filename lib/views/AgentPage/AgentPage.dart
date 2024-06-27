import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:observerit/core/exceptions/AgentException.dart';
import 'package:observerit/core/services/AgentService.dart';
import 'package:observerit/entities/Agent.dart';
import 'package:observerit/entities/View.dart';
import 'package:observerit/shared/widgets/Buttons/DefaultButton.dart';
import 'package:observerit/shared/widgets/Buttons/SecondButton.dart';
import 'package:observerit/shared/widgets/Dialog/ConfirmDialog.dart';
import 'package:observerit/shared/widgets/Dialog/DefaultDialog.dart';
import 'package:observerit/shared/widgets/Inputs/AppInput.dart';
import 'package:url_launcher/url_launcher.dart';

class AgentPage extends StatefulWidget {

  ViewObserverIt? view;

  AgentPage({super.key, this.view});

  @override
  State<AgentPage> createState() => _AgentPageState();
}

class _AgentPageState extends State<AgentPage> {

  ViewObserverIt? get view => widget.view;
  Agent? get agent => widget.view!.agent;

  AgentService agentService = AgentService();

  final _formKey = GlobalKey<FormState>();
  final expressionControl = TextEditingController();


  _visitPage(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
    launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void initState() {
    super.initState();

    if (agent != null) {
      expressionControl.text = agent!.expression!;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Agent"),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          agent != null ? IconButton(onPressed: () async{
            bool deleteAgent = await ConfirmDialog.build(context, "Delete Agent", "Are you sure you want to delete the agent?");

            if (deleteAgent){

              agentService.deleteAgent(agent!.id!);

              Navigator.of(context).pop("DELETE");
            }
          }, icon: Icon(Icons.delete)) : Container()
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
                    "Configuration",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Configure your agent expression",
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
                      labelText: "Expression",
                      hintText: "Type your Expression",
                      controller: expressionControl,
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              agent?.hasNewContent == true ? SecondButton(
                text: "See New Content",
                onPressed: () async {

                  await _visitPage(view!.url!);


                  await agentService.updateViewContent(agent!.id!);
                  setState(() {
                    view!.agent!.hasNewContent = false;
                  });
                },
              ) : Container(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: DefaultButton(
                  onPressed: () async {
                    try{
                      if (agent == null || expressionControl.text != agent?.expression! ) {
                        if (agent == null) {

                          view!.agent = Agent.fromJson({
                            "expression": expressionControl.text,
                            "hasNewContent": false,
                            "lastUpdate": DateTime.timestamp(),
                            "payload": ""
                          });

                          await agentService.addAgent(view!.id!, view!.agent!);
                          await DefaultDialog.build(context, "Agent created", "Agent created successfully!");
                          Navigator.of(context).pop("CREATE");
                        } else {

                          view!.agent!.expression = expressionControl.text;

                          await agentService.updateExpression(agent!.id!, view!.agent!.expression!);
                          await DefaultDialog.build(context, "Agent updated", "Agent updated successfully! In the next scheduled execution it will be updated");
                          Navigator.of(context).pop("UPDATE");
                        }

                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Configuration not changed'),
                        ));
                      }
                    } catch (error) {
                      print(error);
                      DefaultDialog.build(context, "Operation failed", "Unable to proceed with agent configuration");
                    }
                  },
                  text: agent == null ? 'Create View Configuration' : 'Update View Configuration',


                ),
              ),
              SizedBox(
                height: 50,
              ),
              InkWell(
                onTap: () async {

                  await _visitPage('https://www.ibm.com/docs/en/app-connect/11.0.0?topic=xpath-overview');
                },
                child: Text(
                    'What is Xpath?',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () async {
                  await _visitPage('https://www.appsierra.com/blog/how-to-get-xpath-in-chrome');
                },
                child: Text(
                    'How to get your Xpath',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
