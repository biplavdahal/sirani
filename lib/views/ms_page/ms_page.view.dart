import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mysirani/views/ms_page/ms_page.argument.dart';
import 'package:mysirani/views/ms_page/ms_page.model.dart';

class MSPageView extends StatelessWidget {
  final Arguments? arguments;

  static String tag = 'page-view';

  const MSPageView(this.arguments, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<MSPageModel>(
      onModelReady: (model) => model.init(arguments as MSPageArgument?),
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(model.title),
          ),
          body: model.isLoading
              ? const Center(child: CupertinoActivityIndicator())
              : SingleChildScrollView(
                  child: Html(
                    data: model.content,
                  ),
                ),
        );
      },
    );
  }
}
