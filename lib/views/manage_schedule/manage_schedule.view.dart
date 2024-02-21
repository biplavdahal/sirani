import 'package:bestfriend/ui/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/views/manage_schedule/manage_schedule.model.dart';
import 'package:mysirani/views/update_schedule/update_schedule.argument.dart';
import 'package:mysirani/views/update_schedule/update_schedule.view.dart';

class ManageScheduleView extends StatelessWidget {
  static String tag = 'manage-schedule-view';

  const ManageScheduleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<ManageScheduleModel>(
      killViewOnClose: false,
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Manage Schedule'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  await model.goto(
                    UpdateScheduleView.tag,
                    arguments: UpdateScheduleArgument(null),
                  );
                  model.setIdle();
                },
              )
            ],
          ),
          body: model.isLoading
              ? const Center(child: CupertinoActivityIndicator())
              : ListView.builder(
                  itemBuilder: (context, index) {
                    final day = model.schedules.keys.toList()[index];

                    return ExpansionTile(
                      leading: const Icon(MdiIcons.calendarClockOutline),
                      subtitle: Text(
                        "${model.schedules[day]!.length} sessions",
                        style:
                            const TextStyle(color: AppColor.secondaryTextColor),
                      ),
                      title: Text(day),
                      children: model.schedules[day]!.map((schedule) {
                        return ListTile(
                          subtitle: Text(schedule.status),
                          title:
                              Text("${schedule.fromTime} - ${schedule.toTime}"),
                          trailing: SizedBox(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    await model.goto(
                                      UpdateScheduleView.tag,
                                      arguments:
                                          UpdateScheduleArgument(schedule),
                                    );
                                    model.setIdle();
                                  },
                                  icon: const Icon(
                                    MdiIcons.fileEdit,
                                    color: AppColor.primaryTextColor,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    model.onDeletePressed(schedule);
                                  },
                                  icon: const Icon(
                                    MdiIcons.trashCan,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                  itemCount: model.schedules.length,
                ),
        );
      },
    );
  }
}
