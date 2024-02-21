import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mysirani/helpers/field_validator.helper.dart';
import 'package:mysirani/views/update_schedule/update_schedule.argument.dart';
import 'package:mysirani/views/update_schedule/update_schedule.model.dart';
import 'package:mysirani/widgets/input_field.widget.dart';
import 'package:mysirani/widgets/ms_checkbox.widget.dart';
import 'package:mysirani/widgets/primary_button.widget.dart';

class UpdateScheduleView extends StatelessWidget {
  final Arguments? arguments;

  static String tag = 'update_schedule';

  const UpdateScheduleView(this.arguments, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<UpdateScheduleModel>(
      enableTouchRepeal: true,
      onModelReady: (model) => model.init(arguments as UpdateScheduleArgument),
      builder: (ctx, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(model.isEdit ? 'Edit Schedule' : 'Add Schedule'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: model.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputField(
                      controller: model.weekdayController,
                      labelText: "Select Weekday",
                      onTap: model.onWeekdayPressed,
                      suffix: const Icon(MdiIcons.chevronDown),
                      validator: FieldValidator.isRequired,
                    ),
                    const SizedBox(height: 10),
                    InputField(
                      controller: model.fromTimeController,
                      labelText: "Starting From",
                      onTap: () {
                        model.onFromTimePressed(context);
                      },
                      validator: FieldValidator.isRequired,
                    ),
                    const SizedBox(height: 10),
                    InputField(
                      controller: model.toTimeController,
                      labelText: "Up to",
                      onTap: () {},
                      validator: FieldValidator.isRequired,
                    ),
                    if (model.isEdit) ...[
                      const SizedBox(height: 10),
                      MSCheckBox(
                        value: model.selectedStatus,
                        onChanged: model.setSelectedStatus,
                        label: "Keep it active",
                      ),
                    ],
                    const SizedBox(height: 16),
                    PrimaryButton(
                      label: model.isEdit ? "Update" : "Add",
                      onPressed: !model.isEdit
                          ? model.onAddPressed
                          : model.onUpdatePressed,
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
