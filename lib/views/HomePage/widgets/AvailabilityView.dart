import 'package:flutter/material.dart';
import 'package:observerit/entities/Request.dart';

class AvailabilityView extends StatelessWidget {

  List<Request> requests;

  AvailabilityView({super.key, required this.requests});

  @override
  Widget build(BuildContext context) {

    List<Request> localRequests = [...requests];

    while (localRequests.length < 20) {
      localRequests.insert(0,Request.fromJson({
        "status": "Empty",
        "time": 0,
        "date": DateTime.now()
      }));
    }

    Map<String, MaterialColor> color_map = {
      "Available": Colors.green,
      "Error": Colors.red,
      "Empty": Colors.grey
    };

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Text("Availability History", textAlign: TextAlign.start, style: TextStyle(color: Colors.black45),),
            alignment: Alignment.centerLeft,
          ),
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ...localRequests.map((request) => Container(
                decoration: BoxDecoration(
                    color: color_map[request.status],
                    borderRadius: BorderRadius.all(Radius.circular(50))
                ),
                width: 8,
                height: 20,
              ))
            ],
          )
        ],
      ),
    );
  }
}
