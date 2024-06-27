import 'package:flutter/material.dart';
import 'package:observerit/entities/View.dart';
import 'package:observerit/shared/widgets/Buttons/DefaultButton.dart';
import 'package:observerit/views/HomePage/widgets/AvailabilityView.dart';
import 'package:observerit/views/ViewObserverScreen/pages/ListRequestPage.dart';
import 'package:observerit/views/ViewObserverScreen/widgets/StatusPill.dart';

class CardRequestAvailability extends StatelessWidget {
  ViewObserverIt view;

  CardRequestAvailability({super.key, required this.view});

  formatData(DateTime date) {
    return "${date.year}/${date.day}/${date.month} ${date.hour}:${date.minute}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.white),
      child: InkWell(
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
                      "Last Requests",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              AvailabilityView(requests: view.requests!),
              ...view.requests!.sublist(0, view.requests!.length > 4 ? 4 : view.requests!.length).map(
                    (request) => Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 1, color: Colors.black12))),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatData(request.date!),
                            style: TextStyle(color: Colors.black54),
                          ),
                          StatusPill(status: request.status!)
                        ],
                      ),
                    ),
                  ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: DefaultButton(
                  text: 'See more',
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ListRequestPage(view: view,),
                        ),);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
