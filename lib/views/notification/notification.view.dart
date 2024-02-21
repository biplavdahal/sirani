import 'package:bestfriend/ui/view.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/views/notification/notification.model.dart';

class NotificationView extends StatelessWidget {
  static String tag = 'notification-view';

  const NotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<NotificationModel>(
      builder: (ctx, model, child) {
        return Scaffold(
            appBar: AppBar(
          title: const Text('Notifications'),
        ));
      },
    );
  }
}
