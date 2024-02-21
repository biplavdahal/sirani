import 'package:bestfriend/ui/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/views/program/program.argument.dart';
import 'package:mysirani/views/program/program.view.dart';
import 'package:mysirani/views/programs/programs.model.dart';
import 'package:mysirani/views/programs/widgets/program_item.widget.dart';

class ProgramsView extends StatelessWidget {
  static String tag = 'programs-view';

  const ProgramsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<ProgramsModel>(
      killViewOnClose: false,
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) {
        return Scaffold(
            appBar: AppBar(
              title: const Text('Programs'),
            ),
            body: model.isLoading
                ? const Center(
                    child: CupertinoActivityIndicator(),
                  )
                : SingleChildScrollView(
                    controller: model.scrollController,
                    child: Column(
                      children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final program = model.programs[index];
                            return GestureDetector(
                                onTap: () {
                                  model.goto(
                                    ProgramView.tag,
                                    arguments: ProgramArgument(program),
                                  );
                                },
                                child: ProgramItem(program));
                          },
                          itemCount: model.programs.length,
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        if (model.hasMore)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              CupertinoActivityIndicator(),
                              SizedBox(width: 10),
                              Text(
                                "Loading more...",
                                style: TextStyle(
                                  color: AppColor.secondaryTextColor,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ));
      },
    );
  }
}
