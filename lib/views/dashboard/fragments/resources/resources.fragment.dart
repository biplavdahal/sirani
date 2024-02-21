import 'package:bestfriend/bestfriend.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/views/dashboard/fragments/resources/resources.model.dart';
import 'package:mysirani/views/dashboard/fragments/resources/widgets/resource_item.widget.dart';
import 'package:mysirani/widgets/horizontal_list_view.widget.dart';
import 'package:mysirani/widgets/section.widget.dart';

class ResoucesFragment extends StatelessWidget {
  const ResoucesFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<ResoucesModel>(
      onModelReady: (model) => model.init(),
      killViewOnClose: false,
      builder: (ctx, model, child) {
        return model.isLoading
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    if (model.blogs.isNotEmpty)
                      Section(
                        title: "Blogs",
                        child: HorizontalListView(
                            fillerCount: 0,
                            seprator: (context, index) => const SizedBox(
                                  width: 16,
                                ),
                            itemCount:
                                model.blogs.length > 4 ? 4 : model.blogs.length,
                            itemBuilder: (context, index) {
                              final blog = model.blogs[index];

                              return ResourceItem(
                                blog,
                                onTap: () => model.onResourcePressed(blog),
                              );
                            }),
                        onViewMorePressed: () =>
                            model.onViewMorePressed("blog"),
                      ),
                    if (model.videos.isNotEmpty)
                      Section(
                        title: "Videos",
                        child: HorizontalListView(
                            fillerCount: 0,
                            seprator: (context, index) => const SizedBox(
                                  width: 8,
                                ),
                            itemCount: model.videos.length > 4
                                ? 4
                                : model.videos.length,
                            itemBuilder: (context, index) {
                              final video = model.videos[index];

                              return ResourceItem(
                                video,
                                isVideo: true,
                                onTap: () => model.onResourcePressed(video),
                              );
                            }),
                        onViewMorePressed: () =>
                            model.onViewMorePressed("video"),
                      ),
                  ],
                ),
              );
      },
    );
  }
}
