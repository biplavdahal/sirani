import 'package:bestfriend/bestfriend.dart';
import 'package:bestfriend/ui/view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/constants/api_urls.dart';
import 'package:mysirani/views/view_survey/view_survey.argument.dart';
import 'package:mysirani/views/view_survey/view_survey.model.dart';

class ViewSurveyView extends StatelessWidget {
  final Arguments? arguments;

  static String tag = 'view-survey-view';

  const ViewSurveyView(this.arguments, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<ViewSurveyModel>(
      onModelReady: (model) => model.init(arguments as ViewSurveyArgument),
      builder: (ctx, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Survey'),
          ),
          body: model.isLoading
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : ListView.separated(
                  itemBuilder: (context, index) {
                    final _survey = model.surveyQuestions[index];

                    return ListTile(
                      title: Text(_survey.question ?? "Attachment"),
                      subtitle: _survey.question != null
                          ? Text(_survey.answer)
                          : _survey.answer.split(".").length > 1
                              ? CachedNetworkImage(
                                  imageUrl: auImageBaseUrl + _survey.answer,
                                )
                              : Text(_survey.answer),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount: model.surveyQuestions.length,
                ),
        );
      },
    );
  }
}
