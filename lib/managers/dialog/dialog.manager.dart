import 'dart:async';
import 'dart:ui';

import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mysirani/managers/dialog/dialog.model.dart';
import 'package:mysirani/managers/dialog/dialog.service.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/views/call/call.argument.dart';
import 'package:mysirani/views/call/call.view.dart';
import 'package:mysirani/widgets/primary_button.widget.dart';
import 'package:vibration/vibration.dart';

class DialogManager extends StatefulWidget {
  final Widget child;

  const DialogManager({Key? key, required this.child}) : super(key: key);

  @override
  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  final DialogService _dialogService = locator<DialogService>();

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showDialog, _hideDialog);
  }

  void _showDialog(DialogRequest request) {
    if (request.type == DialogType.progressDialog) {
      _baseDialog(child: _buildProgressType(request));
    } else if (request.type == DialogType.selection) {
      _baseDialog(
        dismissable: request.dismissable,
        title: Text(request.title),
        child: _buildSelectionType(request),
      );
    } else if (request.type == DialogType.incomingCall) {
      _baseDialog(
        dismissable: false,
        child: _buildIncomingCallType(request),
        bgColor: AppColor.primary,
      );
    }
  }

  _baseDialog(
      {Widget? title,
      Widget? child,
      Color? bgColor,
      bool dismissable = false}) {
    showDialog(
      barrierDismissible: dismissable,
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            backgroundColor: bgColor ?? Colors.white,
            title: title,
            content: child,
          ),
        );
      },
    );
  }

  _buildSelectionType(DialogRequest request) {
    final payload = request.payload as List;
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: payload
            .map((item) => ListTile(
                  title: Text(item),
                  onTap: () {
                    _dialogService.hideDialog(
                        DialogResponse(result: item), false);
                    Navigator.pop(context);
                  },
                ))
            .toList());
  }

  _buildProgressType(DialogRequest request) {
    return Row(
      children: [
        const CupertinoActivityIndicator(
          animating: true,
        ),
        const SizedBox(width: 32),
        Expanded(child: Text(request.title)),
      ],
    );
  }

  _buildIncomingCallType(DialogRequest request) {
    Timer _timer = request.payload["timer"] as Timer;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Icon(
              MdiIcons.phoneRing,
              color: Colors.green,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Test",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Calling...",
                    style: Theme.of(context).textTheme.overline!.copyWith(
                          color: Colors.white60,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: PrimaryButton(
                label: "Answer",
                onPressed: () {
                  FlutterRingtonePlayer.stop();
                  Vibration.cancel();

                  _timer.cancel();
                  Navigator.pop(context);
                  locator<NavigationService>().navigateTo(
                    CallView.tag,
                    arguments: CallArgument(
                      request.payload["token"],
                      request.payload["channel"],
                      secondPartyName: request.payload["caller"],
                      callerId: int.parse(request.payload["caller_id"]),
                      remainingDuration: request.payload["remaining_duration"],
                    ),
                  );
                },
                backgroundColor: Colors.green,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: PrimaryButton(
                label: "Decline",
                onPressed: () {
                  // Decline call
                  FlutterRingtonePlayer.stop();
                  Vibration.cancel();

                  _timer.cancel();
                  Navigator.pop(context);
                },
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _hideDialog() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
