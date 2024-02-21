import 'package:agora_uikit/agora_uikit.dart';
import 'package:bestfriend/bestfriend.dart';
import 'package:bestfriend/ui/view.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/views/call/call.argument.dart';
import 'package:mysirani/views/call/call.model.dart';

class CallView extends StatelessWidget {
  static String tag = 'call-view';

  final Arguments? arguments;

  const CallView(this.arguments, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<CallModel>(
      onDispose: (model) => model.dispose(),
      onModelReady: (model) => model.init(arguments as CallArgument),
      builder: (ctx, model, child) {
        return Scaffold(
          body: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Stack(
              children: [
                AgoraVideoViewer(
                  client: model.client,
                ),
                // if (model.remoteVideoDisabled)
                //   Positioned(
                //     top: MediaQuery.of(context).size.height / 2,
                //     right: 0,
                //     left: 0,
                //     bottom: 0,
                //     child: AbsorbPointer(
                //       absorbing: true,
                //       ignoringSemantics: true,
                //       child: Container(
                //         color: Colors.black,
                //         alignment: Alignment.center,
                //         child: Text(
                //           '${model.secondPartyName}\'s video stream is not available.',
                //           style: const TextStyle(color: Colors.white),
                //         ),
                //       ),
                //     ),
                //   ),
                Positioned(
                  right: 0,
                  top: MediaQuery.of(context).size.height / 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (model.remoteAudioMuted)
                          const Chip(
                            label: Text("Muted"),
                            backgroundColor: Colors.red,
                            labelStyle: TextStyle(color: Colors.white),
                            avatar: Icon(
                              MdiIcons.microphoneOff,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                AgoraVideoButtons(
                  client: model.client,
                  autoHideButtons: true,
                  switchCameraButtonChild: FloatingActionButton(
                    child: const Icon(MdiIcons.cameraFlip),
                    onPressed: () {
                      model.client.sessionController.switchCamera();
                    },
                  ),
                  disconnectButtonChild: FloatingActionButton(
                    child: const Icon(MdiIcons.phoneHangup),
                    onPressed: () async {
                      await model.client.sessionController.endCall();
                      model.goBack();
                    },
                    backgroundColor: Colors.red,
                  ),
                  enabledButtons: const [],
                  extraButtons: [
                    FloatingActionButton(
                      elevation: 0,
                      hoverElevation: 0,
                      focusElevation: 0,
                      backgroundColor: Colors.white,
                      tooltip: "End Call",
                      child: const Icon(
                        MdiIcons.phoneHangup,
                        color: Colors.red,
                      ),
                      onPressed: model.onEndCall,
                    ),
                    const SizedBox(width: 8),
                    if (!locator<AuthenticationService>().isNormalUser)
                      FloatingActionButton(
                        elevation: 0,
                        hoverElevation: 0,
                        focusElevation: 0,
                        backgroundColor: Colors.white,
                        tooltip: "Session extend options",
                        child: const Icon(
                          MdiIcons.exportVariant,
                          color: AppColor.primary,
                        ),
                        onPressed: model.onExtendPressed,
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
