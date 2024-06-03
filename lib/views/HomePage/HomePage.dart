import 'package:flutter/material.dart';
import 'package:observerit/core/services/ViewService.dart';
import 'package:observerit/entities/User.dart';
import 'package:observerit/entities/View.dart';
import 'package:observerit/shared/widgets/Dialog/DefaultDialog.dart';
import 'package:observerit/views/CreateView/CreateView.dart';
import 'package:observerit/views/HomePage/SideMenu.dart';
import 'package:observerit/views/HomePage/widgets/CardView.dart';

class HomePage extends StatefulWidget {


  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ViewObserverItService viewObserverItService = ViewObserverItService();
  List<ViewObserverIt> views = [];
  Future<void>? fetchViews = null;
  final user = User.fromJson({
    "username": "Joe Doe",
    "imageUrl": null,
    "id": 1,
    "email": "joedoe@gmail.com"
  });

  @override
  void initState() {
    super.initState();

    fetchViews = viewObserverItService.getViewFromUser(user).then( (response) {
      views = response;
    });

  }

  @override
  Widget build(BuildContext context) {

    //final user = ModalRoute.of(context)!.settings.arguments as User;

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
        onPressed: () async {
          ViewObserverIt? view = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateView(),
            ),
          );

          if (view != null) {
            setState(() {
              views = [view,...views];
            });
            DefaultDialog.build(context, "Created", "Your View has been created successfully!");
          }
        },
      ),
      drawer: SideMenu(user: user),
      body: FutureBuilder(
          future: fetchViews,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
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
