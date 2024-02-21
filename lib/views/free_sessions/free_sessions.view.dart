import 'package:bestfriend/ui/view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/constants/api_urls.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/views/free_sessions/free_sessions.model.dart';
import 'package:mysirani/views/message_board/message_board.argument.dart';
import 'package:mysirani/views/message_board/message_board.view.dart';

class FreeSessionsView extends StatelessWidget {
  static String tag = 'chat-sessions-view';

  const FreeSessionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<FreeSessionsModel>(
      killViewOnClose: false,
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Free Sessions'),
          ),
          body: model.isLoading
              ? const Center(child: CupertinoActivityIndicator())
              : RefreshIndicator(
                  onRefresh: model.init,
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      final _thread = model.freeSessionThreads[index];

                      return Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: ListTile(
                          onTap: () {
                            model.goto(
                              MessageBoardView.tag,
                              arguments: MessageBoardArgument(
                                receiverId: _thread.id,
                                receiverName: _thread.fullName,
                              ),
                            );
                          },
                          leading: SizedBox(
                            height: 50,
                            width: 50,
                            child: CachedNetworkImage(
                              fadeInDuration: const Duration(milliseconds: 300),
                              imageUrl: auImageBaseUrl + _thread.image,
                              imageBuilder: (context, imageProvider) {
                                return CircleAvatar(
                                  backgroundColor:
                                      AppColor.primary.withOpacity(0.8),
                                  backgroundImage: imageProvider,
                                );
                              },
                              errorWidget: (context, url, error) {
                                return CircleAvatar(
                                  backgroundColor:
                                      AppColor.primary.withOpacity(0.8),
                                  child:
                                      Text(_thread.fullName[0].toUpperCase()),
                                );
                              },
                            ),
                          ),
                          subtitle: Text(_thread.email),
                          title: Text(_thread.fullName),
                          trailing: Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: _thread.status == "Online"
                                  ? Colors.green
                                  : Colors.grey,
                              border: Border.all(
                                width: 1,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: model.freeSessionThreads.length,
                  ),
                ),
        );
      },
    );
  }
}
