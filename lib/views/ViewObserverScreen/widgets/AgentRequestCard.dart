import 'package:flutter/material.dart';
import 'package:observerit/entities/Agent.dart';
import 'package:observerit/entities/View.dart';
import 'package:observerit/shared/widgets/Buttons/SecondButton.dart';
import 'package:observerit/shared/widgets/Dialog/DefaultDialog.dart';
import 'package:observerit/views/AgentPage/AgentPage.dart';

class AgentRequestCard extends StatefulWidget {
  ViewObserverIt? view;

  AgentRequestCard({super.key, this.view});

  @override
  State<AgentRequestCard> createState() => _AgentRequestCardState();
}

class _AgentRequestCardState extends State<AgentRequestCard> {
  Agent? get agent => widget.view!.agent;
  ViewObserverIt? get view => widget.view;

  _formatDate(DateTime date) {
    return "${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}:${date.second}";
  }

  @override
  Widget build(BuildContext context) {

    Color color = Theme.of(context).primaryColorDark;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.white),
      child: Card(
        color: Colors.white,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 65,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Colors.black45))),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Content Agent",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () {
                            DefaultDialog.build(context, "Content Agent",
                                "With a content agent you can monitor changes made to your URL from an Xpath");
                          },
                          icon: Icon(Icons.info_outline))
                    ],
                  ),
                ),
              ),
            ),


            agent != null ?
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.only(left: 16, bottom: 32, top: 32,right: 16),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.all(Radius.circular(8))
                    ),
                    width: MediaQuery.sizeOf(context).width,
                    child: Column(
                      children: [
                        Container(
                          child: Text(
                              agent!.hasNewContent! ? "New content available!" : "Without new content",
                              style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text("Time Last Content",style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),),
                        SizedBox(height: 20,),
                        Text(_formatDate(agent!.lastUpdate!), style: TextStyle(fontSize: 16,  color: Colors.white),)
                      ],
                    ),
                  ),
                  SecondButton(
                    onPressed: () async {

                      final updatePage = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => AgentPage(view: view,)));

                      setState(() {

                      });
                    },
                    text: "See Configurations",
                  )
                ],
              ),
            ) :
            Container(
              height: 200,
              child: InkWell(
                onTap: () async {
                  final createPage = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => AgentPage(view: view,)));

                  setState(() {

                  });
                },
                child: Align(
                  child: Text(
                    "Click to create Agent",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
