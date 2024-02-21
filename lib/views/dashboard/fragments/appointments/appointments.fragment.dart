import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/views/dashboard/fragments/appointments/appointments.model.dart';
import 'package:mysirani/views/dashboard/fragments/appointments/widgets/appointment_item.widget.dart';

class AppointmentsFragment extends StatelessWidget {
  const AppointmentsFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<AppointmentsModel>(
      onModelReady: (model) => model.init(),
      killViewOnClose: false,
      builder: (ctx, model, child) {
        return model.isLoading
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : RefreshIndicator(
                onRefresh: model.init,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final appointment = model.appointments[index];

                    return AppointmentItem(
                      appointment,
                      onApprove: model.approveAppoitnmentPressed,
                      onDecline: model.declineAppoitnmentPressed,
                      onTap: () => model.viewDetail(appointment),
                    );
                  },
                  itemCount: model.appointments.length,
                ),
              );
      },
    );
  }
}
