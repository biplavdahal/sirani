import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/helpers/field_validator.helper.dart';
import 'package:mysirani/views/write_thread/write_thread.argument.dart';
import 'package:mysirani/views/write_thread/write_thread.model.dart';
import 'package:mysirani/widgets/input_field.widget.dart';
import 'package:mysirani/widgets/ms_checkbox.widget.dart';
import 'package:mysirani/widgets/primary_button.widget.dart';

class WriteThreadView extends StatelessWidget {
  final Arguments? arguments;

  static String tag = 'write-thread-view';

  const WriteThreadView(this.arguments, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<WriteThreadModel>(
      enableTouchRepeal: true,
      onModelReady: (model) => model.init(arguments as WriteThreadArgument?),
      builder: (ctx, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              model.currentThread == null
                  ? 'Write your feeling'
                  : 'Edit your feeling',
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: model.writeThreadFormKey,
                child: Column(
                  children: [
                    InputField(
                      labelText: "How are you feeling?",
                      controller: model.descriptionController,
                      inputType: TextInputType.multiline,
                      validator: FieldValidator.isRequired,
                    ),
                    const SizedBox(height: 16),
                    MSCheckBox(
                      value: model.isAnonymous,
                      onChanged: (value) => model.isAnonymous = value,
                      label: "Share as anonymous",
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      label: model.currentThread == null ?  "Share" : "Update",
                      onPressed: model.currentThread == null ?  model.onSharePressed : model.onUpdatePressed,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
