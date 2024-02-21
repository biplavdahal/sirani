import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mysirani/helpers/date_time_format.helper.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/views/appointment_detail/appointment_detail.argument.dart';
import 'package:mysirani/widgets/link_text.widget.dart';
import 'package:mysirani/widgets/user_avatar.widget.dart';

class AppointmentDetailView extends StatelessWidget {
  final Arguments? arguments;

  static String tag = 'appointment-detail-view';

  const AppointmentDetailView(this.arguments, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _appointment = (arguments as AppointmentDetailArgument).appointment;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Appointment Detail'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              color: AppColor.primary,
            ),
            width: double.infinity,
            padding: const EdgeInsets.only(top: 14, bottom: 14),
            child: Column(
              children: [
                UserAvatar(
                  user: _appointment.secondParty,
                  size: 32,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  _appointment.secondParty.fullName!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Assingation: ${_appointment.info.type}",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                LinkText("View Survey", onPressed: () {}),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(MdiIcons.timelapse),
                const SizedBox(
                  width: 8,
                ),
                Text(formattedDateTime(
                  _appointment.info.time,
                )),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text("Detail: \n${_appointment.info.detail}"),
          )
        ],
      ),
    );
  }
}
