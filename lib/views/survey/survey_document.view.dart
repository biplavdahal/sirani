import 'package:bestfriend/ui/view.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mysirani/views/survey/survey.model.dart';
import 'package:mysirani/widgets/primary_button.widget.dart';

class SurveyDocumentView extends StatelessWidget {
  static String tag = 'survey-document-view';

  const SurveyDocumentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<SurveyModel>(
      builder: (ctx, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Document Upload'),
          ),
          body: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "For indentification purpose, please upload your indentification document image. Once you're verified, our counsellors will view your appointment.",
                ),
                const Divider(),
                const Text(
                  "Identity document",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: model.onDocumentAddPressed,
                  child: AspectRatio(
                    aspectRatio: 500 / 300,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        color: Colors.black12,
                        boxShadow: [
                          if (model.document != null)
                            const BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                        ],
                      ),
                      child: model.document == null
                          ? const Center(
                              child: Icon(
                                MdiIcons.image,
                                size: 120,
                                color: Colors.grey,
                              ),
                            )
                          : Image.file(
                              model.document!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  label: "Upload Document",
                  onPressed: model.onUploadDocumentPressed,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
