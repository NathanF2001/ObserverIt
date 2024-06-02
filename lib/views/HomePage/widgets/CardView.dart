import 'package:flutter/material.dart';
import 'package:observerit/entities/View.dart';
import 'package:observerit/views/HomePage/widgets/AvailabilityView.dart';
import 'package:observerit/views/HomePage/widgets/InformationViewCard.dart';

class CardView extends StatelessWidget {
  ViewObserverIt view;

  CardView({super.key, required this.view});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              title: Text(view.alias!),
              titleTextStyle: TextStyle(fontSize: 20),
            ),
            AvailabilityView(requests: view.requests!),

            InformationViewCard(
                title: "Request Uptime",
                value: view.statistics!.uptime.toString() + " days",
                icon: Icons.update),
            InformationViewCard(
                title: "Average Time",
                value: view.statistics!.average.toString() + "ms",
                icon: Icons.timelapse),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              margin: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                border: Border.all(width: 1, color: Color(0xffb9b9b9)),
              ),
              child: Text(
                view.url!,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
