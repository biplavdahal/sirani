import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/helpers/format_currenecy.helper.dart';
import 'package:mysirani/services/authentication.service.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/views/load_fund/load_fund.view.dart';
import 'package:mysirani/views/statement/statement.model.dart';
import 'package:mysirani/views/statement/widgets/statement_item.widget.dart';
import 'package:mysirani/widgets/link_text.widget.dart';

class StatementView extends StatelessWidget {
  static String tag = 'statement-view';

  const StatementView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<StatementModel>(
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: AppColor.primary,
          appBar: AppBar(
            title: const Text('Wallet Statement'),
          ),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      "Available Balance",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Rs. ${formatCurrency(locator<AuthenticationService>().auth!.balance)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              LinkText(
                "Load Balance",
                onPressed: () async {
                  await model.goto(LoadFundView.tag);
                  model.setIdle();
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: model.isLoading
                      ? const Center(
                          child: CupertinoActivityIndicator(),
                        )
                      : RefreshIndicator(
                          onRefresh: () => model.init(forceRefresh: true),
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: model.statements?.length ?? 0,
                            separatorBuilder: (ctx, index) => const Divider(),
                            itemBuilder: (ctx, index) {
                              final _statemnent = model.statements![index];
                              return StatementItem(_statemnent);
                            },
                          ),
                        ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
