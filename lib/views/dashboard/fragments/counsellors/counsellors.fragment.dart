import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/views/dashboard/fragments/counsellors/counsellors.model.dart';
import 'package:mysirani/views/dashboard/fragments/counsellors/widgets/counsellor_item.widget.dart';
import 'package:mysirani/views/dashboard/fragments/counsellors/widgets/selector.widget.dart';

class CounsellorsFragment extends StatefulWidget {
  const CounsellorsFragment({Key? key}) : super(key: key);

  @override
  _CounsellorsFragmentState createState() => _CounsellorsFragmentState();
}

class _CounsellorsFragmentState extends State<CounsellorsFragment> {
  @override
  Widget build(BuildContext context) {
    return View<CounsellorsModel>(
      onModelReady: (model) => model.init(),
      killViewOnClose: false,
      builder: (ctx, model, child) {
        return model.isLoading
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : Column(
                children: [
                  SelectorWidget(
                    items: model.types,
                    response: model.typeResponse,
                    selectedItem: model.selectedType,
                    onChanged: (value) => model.onSelectedType(value),
                  ),
                  if (model.isLoading)
                    const Center(
                      child: CupertinoActivityIndicator(),
                    )
                  else if (model.counsellors != null)
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 16,
                        ),
                        itemBuilder: (context, index) {
                          final counsellor = model.counsellors![index];

                          return CounsellorItem(
                            counsellor,
                            onTap: () =>
                                model.onCounsellorProfileTap(counsellor),
                            onBookAppointmentPressed: () =>
                                model.onBookAnAppointmentPressed(counsellor),
                          );
                        },
                        itemCount: model.counsellors!.length,
                      ),
                    ),
                ],
              );
      },
    );
  }
}
