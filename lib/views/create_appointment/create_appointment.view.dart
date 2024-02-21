import 'package:bestfriend/bestfriend.dart';
import 'package:bestfriend/ui/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mysirani/helpers/field_validator.helper.dart';
import 'package:mysirani/helpers/format_currenecy.helper.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/views/create_appointment/create_appointment.model.dart';
import 'package:mysirani/widgets/input_field.widget.dart';
import 'package:mysirani/widgets/ms_selectables.widget.dart';
import 'package:mysirani/widgets/primary_button.widget.dart';

class CreateAppointmentView extends StatelessWidget {
  static String tag = 'create-appointment-view';

  const CreateAppointmentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<CreateAppointmentModel>(
      enableTouchRepeal: true,
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Create Appointment'),
          ),
          body: model.isLoading
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: model.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InputField(
                            controller: model.typeController,
                            labelText: "Appointment Type",
                            onTap: model.onAppointmentTypePressed,
                            suffix: const Icon(MdiIcons.chevronDown),
                            validator: FieldValidator.isRequired,
                          ),
                          const SizedBox(height: 10),
                          InputField(
                            controller: model.dateController,
                            labelText: "Appointment Date",
                            onTap: () {
                              model.onAppointmentDatePressed(context);
                            },
                            validator: FieldValidator.isRequired,
                          ),
                          if (model.availableTimes.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            MSSelectables<String>(
                              onSelected: (value) => model.selectedTime = value,
                              items: model.availableTimes.toList(),
                              value: model.selectedTime,
                              unSelectedWidget: (item) {
                                return ActionChip(
                                  label: Text(item),
                                  onPressed: () {
                                    model.selectedTime = item;
                                  },
                                );
                              },
                              selectedWidget: (item) {
                                return ActionChip(
                                  backgroundColor: AppColor.accent,
                                  label: Text(item),
                                  onPressed: () {
                                    model.selectedTime = item;
                                  },
                                );
                              },
                            )
                          ],
                          const SizedBox(height: 10),
                          InputField(
                            controller: model.detailController,
                            labelText: "Appointment Detail",
                            inputType: TextInputType.multiline,
                          ),
                          const SizedBox(height: 16),
                          if (model.selectedTime.isNotEmpty)
                            if (model.counsellorRate >
                                locator<AuthenticationService>().auth!.balance)
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColor.secondaryTextColor
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(MdiIcons.informationVariant),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            "You do not have sufficient balance to book this counsellor. You must have atleast Rs.${formatCurrency(model.counsellorRate)}. Your current balance is Rs.${locator<AuthenticationService>().auth!.balance}",
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: model.loadFund,
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.green,
                                      ),
                                      child: Text(
                                          "Load Rs.${formatCurrency(model.counsellorRate - locator<AuthenticationService>().auth!.balance)}"),
                                    )
                                  ],
                                ),
                              )
                            else ...[
                              const SizedBox(height: 16),
                              PrimaryButton(
                                label: "Add Appointment",
                                onPressed: model.onAddAppointmentPressed,
                              ),
                            ]
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
