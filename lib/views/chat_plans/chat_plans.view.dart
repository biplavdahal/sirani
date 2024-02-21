import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/views/chat_plans/chat_plans.model.dart';
import 'package:mysirani/views/chat_plans/widgets/chat_plan_item.widget.dart';

class ChatPlansView extends StatelessWidget {
  static String tag = 'chat-plans-view';

  const ChatPlansView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<ChatPlansModel>(
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Chat Plans'),
          ),
          body: model.isLoading
              ? const Center(child: CupertinoActivityIndicator())
              : RefreshIndicator(
                  onRefresh: () => model.init(),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return ChatPlanItem(
                        plan: model.chatPlans[index],
                        onBuyPressed: (planRate) => model.onBuyPressed(
                          model.chatPlans[index],
                          planRate: planRate,
                        ),
                      );
                    },
                    itemCount: model.chatPlans.length,
                  ),
                ),
        );
      },
    );
  }
}
