import 'package:bestfriend/ui/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mysirani/views/survey/survey.model.dart';

class SurveyView extends StatelessWidget {
  static String tag = 'survey-view';

  const SurveyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<SurveyModel>(
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Survey"),
          ),
          body: model.isLoading
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black12,
                              ),
                            ),
                          ),
                          child: Text(
                            "Question ${model.currentQuestionIndex + 1}/${model.surveyQuestions.length}",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                model
                                    .surveyQuestions[model.currentQuestionIndex]
                                    .question,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: model
                                    .surveyQuestions[model.currentQuestionIndex]
                                    .options
                                    .length,
                                itemBuilder: (context, index) {
                                  return RadioListTile<int>(
                                    groupValue: model.getGroupValueAnswer(),
                                    value: model
                                        .surveyQuestions[
                                            model.currentQuestionIndex]
                                        .options[index]
                                        .id,
                                    onChanged: (value) {
                                      model.setAnswer(
                                        answerId: model
                                            .surveyQuestions[
                                                model.currentQuestionIndex]
                                            .options[index]
                                            .id,
                                      );
                                    },
                                    title: Text(
                                      model
                                          .surveyQuestions[
                                              model.currentQuestionIndex]
                                          .options[index]
                                          .text,
                                    ),
                                    dense: true,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: FloatingActionButton(
                        onPressed: model.onNextPressed,
                        child: Icon(
                          model.currentQuestionIndex ==
                                  model.surveyQuestions.length - 1
                              ? MdiIcons.contentSave
                              : MdiIcons.arrowRight,
                        ),
                      ),
                    ),
                    if (model.currentQuestionIndex > 0)
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: FloatingActionButton(
                          backgroundColor: Colors.white,
                          onPressed: model.onPreviousPressed,
                          child: const Icon(
                            MdiIcons.arrowLeft,
                            color: Colors.black,
                          ),
                        ),
                      )
                  ],
                ),
        );
      },
    );
  }
}
