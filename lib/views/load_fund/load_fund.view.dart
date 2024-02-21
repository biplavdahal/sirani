import 'package:bestfriend/bestfriend.dart';
import 'package:bestfriend/ui/view.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/helpers/field_validator.helper.dart';
import 'package:mysirani/views/load_fund/load_fund.model.dart';
import 'package:mysirani/widgets/input_field.widget.dart';
import 'package:mysirani/widgets/primary_button.widget.dart';

class LoadFundView extends StatelessWidget {
  static String tag = 'load_fund_view';

  const LoadFundView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<LoadFundModel>(
      enableTouchRepeal: true,
      builder: (ctx, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Load Fund'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: model.formKey,
              child: Column(
                children: [
                  InputField(
                    labelText: "Enter amount",
                    controller: model.amountController,
                    inputType: TextInputType.number,
                    validator: FieldValidator.isRequired,
                    prefix: const Text("Rs. "),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  PrimaryButton(
                    label: "Load from ESewa",
                    onPressed: model.onLoadFromESewaPressed,
                    backgroundColor: Colors.green,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
