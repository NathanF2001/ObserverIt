import 'package:flutter/material.dart';
import 'package:observerit/core/services/ViewService.dart';
import 'package:observerit/entities/User.dart';
import 'package:observerit/entities/View.dart';
import 'package:observerit/views/CreateView/CreateView.dart';
import 'package:observerit/views/HomePage/SideMenu.dart';
import 'package:observerit/views/HomePage/widgets/CardView.dart';

class HomePage extends StatefulWidget {


  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {

    final ViewObserverItService viewObserverItService = ViewObserverItService();

    //final user = ModalRoute.of(context)!.settings.arguments as User;
    final user = User.fromJson({
      "username": "Joe Doe",
      "imageUrl": null,
      "id": 1,
      "email": "joedoe@gmail.com"
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Observations"),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      floatingActionButton: IconButton(
        icon: Icon(Icons.add),
        color: Colors.white,
        iconSize: 20,
        style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith((states) => Theme.of(context).primaryColor),
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateView(),
            ),
          );
        },
      ),
      drawer: SideMenu(user: user),
      body: FutureBuilder(
          future: viewObserverItService.getViewFromUser(user),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final List<ViewObserverIt> views = snapshot.data!;

              return ListView(
                children: [
                  SizedBox(height: 20,),
                  ...views.map((view) => CardView(view: view))
                ],
              );
            }
          }),
    );
  }
}
