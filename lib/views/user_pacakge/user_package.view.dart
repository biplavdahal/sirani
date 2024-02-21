import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/views/user_pacakge/user_package.model.dart';
import 'package:mysirani/views/user_pacakge/widgets/user_pacakge_item.widget.dart';

class UserPackageView extends StatelessWidget {
  static String tag = 'user-package-view';

  const UserPackageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<UserPackageModel>(
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Available Packages"),
          ),
          body: model.isLoading
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () => model.init(),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return UserPackageItem(model.availablePackages[index]);
                    },
                    itemCount: model.availablePackages.length,
                  ),
                ),
        );
      },
    );
  }
}
