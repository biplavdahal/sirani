import 'package:bestfriend/bestfriend.dart';
import 'package:bestfriend/ui/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mysirani/views/message_board/message_board.argument.dart';
import 'package:mysirani/views/message_board/message_board.model.dart';
import 'package:mysirani/views/message_board/widgets/message_item.widget.dart';
import 'package:mysirani/widgets/input_field.widget.dart';

class MessageBoardView extends StatelessWidget {
  final Arguments? arguments;

  static String tag = 'message-board-view';

  const MessageBoardView(this.arguments, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<MessageBoardModel>(
      onDispose: (model) => model.dispose(),
      enableTouchRepeal: true,
      onModelReady: (model) => model.init(arguments as MessageBoardArgument),
      builder: (ctx, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(model.receiverName),
          ),
          body: model.isLoading
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        restorationId: "12",
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        reverse: true,
                        itemBuilder: (context, index) {
                          return MessageItem(
                            model.messages[index],
                            showDateTime:
                                model.showDateTime(model.messages[index].id),
                            onTap: (id) => model.showDateTimeFor = id,
                          );
                        },
                        itemCount: model.messages.length,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Container(
                      width: null,
                      color: Colors.grey[50],
                      padding: const EdgeInsets.all(6),
                      child: Row(children: [
                        Expanded(
                          child: InputField(
                            labelText:
                                'Write message to ${model.receiverName}...',
                            controller: model.messageController,
                          ),
                        ),
                        if (model.enableSendButton)
                          IconButton(
                            onPressed: model.isBusyWidget('send-btn')
                                ? null
                                : model.sendMessage,
                            icon: model.isBusyWidget('send-btn')
                                ? const CupertinoActivityIndicator()
                                : const Icon(MdiIcons.send),
                          ),
                      ]),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
