import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mysirani/data_model/appointment.data.dart';
import 'package:mysirani/helpers/date_time_format.helper.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/views/call/call.argument.dart';
import 'package:mysirani/views/call/call.view.dart';
import 'package:mysirani/views/dashboard/fragments/appointments/appointments.model.dart';
import 'package:mysirani/views/message_board/message_board.argument.dart';
import 'package:mysirani/views/message_board/message_board.view.dart';
import 'package:mysirani/views/view_survey/view_survey.argument.dart';
import 'package:mysirani/views/view_survey/view_survey.view.dart';
import 'package:mysirani/widgets/link_text.widget.dart';
import 'package:mysirani/widgets/primary_button.widget.dart';
import 'package:mysirani/widgets/user_avatar.widget.dart';

class AppointmentItem extends StatelessWidget {
  final AppointmentData appointment;
  final VoidCallback? onTap;
  final ValueSetter<AppointmentData>? onApprove;
  final ValueSetter<AppointmentData>? onDecline;

  const AppointmentItem(
    this.appointment, {
    Key? key,
    this.onTap,
    this.onApprove,
    this.onDecline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formattedDateTime(appointment.info.time),
                  style: const TextStyle(
                    color: AppColor.secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserAvatar(
                      user: appointment.secondParty,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.secondParty.fullName ??
                                appointment.secondParty.displayName!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (appointment.secondParty.type != null) ...[
                            const SizedBox(width: 4),
                            Text(
                              appointment.secondParty.type!,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                          if (appointment.info.detail.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              appointment.info.detail,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                LinkText("View Survey", onPressed: () {
                  if (locator<AuthenticationService>().isNormalUser) {
                    locator<NavigationService>().navigateTo(
                      ViewSurveyView.tag,
                      arguments: ViewSurveyArgument(null),
                    );
                  } else {
                    locator<NavigationService>().navigateTo(
                      ViewSurveyView.tag,
                      arguments: ViewSurveyArgument(appointment.secondParty.id),
                    );
                  }
                }),
                if (appointment.info.status == "Pending" &&
                    !locator<AuthenticationService>().isNormalUser) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          label: "Decline",
                          onPressed: () {
                            onDecline?.call(appointment);
                          },
                          backgroundColor: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: PrimaryButton(
                          label: "Approve",
                          onPressed: () {
                            onApprove?.call(appointment);
                          },
                        ),
                      ),
                    ],
                  )
                ]
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColor.accent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                appointment.info.type == "Video Call"
                    ? MdiIcons.video
                    : MdiIcons.chat,
                color: Colors.white70,
              ),
            ),
          ),
          if (canStartSession(appointment.info.time) &&
              appointment.info.status == "Approved")
            Positioned(
              bottom: 20,
              right: 10,
              child: ActionChip(
                onPressed: () async {
                  if (appointment.info.type == "Chat") {
                    locator<AppointmentsModel>().goto(
                      MessageBoardView.tag,
                      arguments: MessageBoardArgument(
                        receiverId: appointment.secondParty.id,
                        receiverName: appointment.secondParty.fullName!,
                      ),
                    );
                  } else if (appointment.info.type == "Video Call") {
                    final token = await locator<AppointmentsModel>()
                        .joinVideoCall(appointment);

                    if (token != null) {
                      // Send notification
                      await locator<AppointmentsModel>()
                          .sendCallNotification(token, appointment);

                      // Get session run time
                      final remainingDuration =
                          await locator<AppointmentsModel>()
                              .remainingDuration(appointment);

                      if (remainingDuration != null) {
                        locator<AppointmentsModel>().goto(
                          CallView.tag,
                          arguments: CallArgument(
                            token,
                            locator<AuthenticationService>().auth!.username,
                            secondPartyName: appointment.secondParty.fullName!,
                            callerId: appointment.secondParty.id,
                            remainingDuration: remainingDuration,
                          ),
                        );
                      }
                    }
                  }
                },
                backgroundColor: AppColor.primary,
                label: const Text(
                  "Start Session",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            )
          else if (appointment.info.status == "Pending" &&
              locator<AuthenticationService>().isNormalUser)
            Positioned(
              bottom: 20,
              right: 10,
              child: Chip(
                backgroundColor: Colors.orange,
                label: Text(
                  appointment.info.status,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            )
          else if (appointment.info.status != "Pending")
            Positioned(
              bottom: 20,
              right: 10,
              child: Chip(
                backgroundColor: appointment.info.status == "Approved"
                    ? Colors.green
                    : appointment.info.status == "Declined"
                        ? Colors.red
                        : Colors.black,
                label: Text(
                  appointment.info.status,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
