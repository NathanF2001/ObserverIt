import 'package:flutter/material.dart';
import 'package:observerit/entities/View.dart';
import 'package:observerit/shared/widgets/Dialog/DefaultDialog.dart';

class CardUrlView extends StatelessWidget {
  ViewObserverIt view;

  CardUrlView({super.key, required this.view});

  getPeriodRuleFormatted(int period) {
    List<Map<String, dynamic>> periodFormated = [];

    int totalPeriod = period;

    if (totalPeriod % 168 == 0) {
      final totalWeeks = totalPeriod ~/ 168;
      periodFormated.add(
          {"type": totalWeeks == 1 ? 'week' : 'weeks', "value": totalWeeks});

      totalPeriod -= totalWeeks * 168;
    }

    if (totalPeriod % 24 == 0) {
      final totalDays = totalPeriod ~/ 24;
      periodFormated
          .add({"type": totalDays == 1 ? 'day' : 'days', "value": totalDays});
      totalPeriod -= totalDays * 24;
    }

    if (totalPeriod > 0) {
      periodFormated.add(
          {"type": totalPeriod == 1 ? 'hour' : 'hours', "value": totalPeriod});
    }

    return periodFormated
        .map((format) => "${format["value"]} ${format['type']}")
        .join(", ");
  }

  @override
  Widget build(BuildContext context) {
    String formattedPeriod = getPeriodRuleFormatted(view.verificationPeriod!);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.white),
      child: InkWell(
        onTap: () {
          DefaultDialog.build(context, "Current URL", view.url!);
        },
        child: Card(
          color: Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black12),
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 50,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: Colors.black45))),
                child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        "Url Configuration",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
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
              Container(
                padding: EdgeInsets.all(16),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Request rule each ${formattedPeriod}", style: TextStyle(color: Colors.black54),)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
