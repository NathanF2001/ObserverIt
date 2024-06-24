import 'package:flutter/material.dart';
import 'package:observerit/entities/View.dart';
import 'package:observerit/views/HomePage/widgets/AvailabilityView.dart';
import 'package:observerit/views/HomePage/widgets/InformationViewCard.dart';
import 'package:observerit/views/ViewObserverScreen/ViewObserver.dart';

class CardView extends StatefulWidget {
  final Function updateViews;
  ViewObserverIt view;

  CardView({super.key, required this.view, required this.updateViews});

  @override
  State<CardView> createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () async {
          String? status = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ViewObserverScreen(viewObserverIt: widget.view),
            ),
          );

          if (status == "DELETE") {
            widget.updateViews();
          }

          setState(() {

          });
        },
        child: Card(
          elevation: 5,
          surfaceTintColor: Colors.white,
          child: Column(
            children: [
              ListTile(
                tileColor: Theme.of(context).primaryColorDark,
                iconColor: Colors.white,
                textColor: Colors.white,
                trailing: Icon(Icons.chevron_right),
                leading: Icon(Icons.remove_red_eye_outlined),
                title: Text(widget.view.alias!),
                titleTextStyle: TextStyle(fontSize: 20),
              ),
              AvailabilityView(requests: widget.view.requests!),
              InformationViewCard(
                  title: "Request Uptime",
                  value: widget.view.statistics!.createTime!.difference(DateTime.timestamp()).inDays.toString() + " days",
                  icon: Icons.update),
              InformationViewCard(
                  title: "Average Time",
                  value: widget.view.statistics!.average!.toStringAsFixed(2) + "ms",
                  icon: Icons.timelapse),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                margin: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  border: Border.all(width: 1, color: Color(0xffb9b9b9)),
                ),
                child: Text(
                  widget.view.url!,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
