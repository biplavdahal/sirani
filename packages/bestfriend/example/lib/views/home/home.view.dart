import 'package:bestfriend/bestfriend.dart';
import 'package:example/constants/routes_name.dart';
import 'package:example/views/home/home.model.dart';
import 'package:example/views/second/second.view.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<HomeModel>(
      builder: (ctx, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Home"),
          ),
          body: Center(
            child: Wrap(
              spacing: 12,
              children: [
                ElevatedButton(
                  onPressed: model.showSnackbar,
                  child: Text("Show Snackbar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Fluttertoast.showToast(msg: "Hello World!");
                  },
                  child: Text("Show toast"),
                ),
                TextButton(
                  onPressed: () {
                    model.goto(
                      SecondViewRoute,
                      arguments: SecondViewArguments(
                        "This message came from previous view.",
                      ),
                    );
                  },
                  child: Text("Go to next view"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
