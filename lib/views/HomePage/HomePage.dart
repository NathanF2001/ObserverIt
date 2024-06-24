import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:observerit/core/services/LocalStorage.dart';
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
  UserObserverIt? user;
  Future<void>? fetchViews = null;

  bool firstLoad = true;


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    LocalStorage localStorage = LocalStorage();

    user = UserObserverIt.fromJson(localStorage.getValueJSON('user'));

    if (firstLoad) {
      fetchViews = viewObserverItService.getViewFromUser(user!).then( (response) {
        views = response;
      });

      firstLoad = false;
    }

    _updateViews() {
      setState(() {
        fetchViews = viewObserverItService.getViewFromUser(user!).then( (response) {
          views = response;
        });
      });

    }

    return SafeArea(
      child: Scaffold(
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
                builder: (context) => CreateView(user: user!),
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
        drawer: SideMenu(user: user!, selectedMenu: 'views',),
        body: FutureBuilder(
            future: fetchViews,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (views.length == 0) {
                  return Expanded(
                    child: Center(
                      child: Text("No Views", style: TextStyle(fontSize: 24, color: Colors.grey),),
                    ),
                  );
                } else {
                  return ListView(
                    children: [
                      SizedBox(height: 20,),
                      ...views.map((view) => CardView(view: view, updateViews: _updateViews))
                    ],
                  );
                }

              }
            }),
      ),
    );
  }
}
