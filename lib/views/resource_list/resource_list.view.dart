import 'package:bestfriend/bestfriend.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysirani/constants/api_urls.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/views/resource/resource.argument.dart';
import 'package:mysirani/views/resource/resource.view.dart';
import 'package:mysirani/views/resource_list/resource_list.argument.dart';
import 'package:mysirani/views/resource_list/resource_list.model.dart';
import 'package:mysirani/widgets/link_text.widget.dart';

class ResourceListView extends StatelessWidget {
  final Arguments? arguments;

  static String tag = 'resource-list-view';

  const ResourceListView(this.arguments, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<ResourceListModel>(
      onModelReady: (model) => model.init(arguments as ResourceListAgument?),
      builder: (ctx, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Resources'),
          ),
          body: model.isLoading
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : SingleChildScrollView(
                  controller: model.scrollController,
                  child: Column(
                    children: [
                      RefreshIndicator(
                        onRefresh: model.onRefresh,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) {
                            final resource = model.resources[index];

                            return GestureDetector(
                              onTap: () {
                                model.goto(
                                  ResourceView.tag,
                                  arguments: ResourceArgument(resource),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(16),
                                color: Colors.white,
                                child: Row(
                                  children: [
                                    Container(
                                      clipBehavior: Clip.antiAlias,
                                      width: 105,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            auImageBaseUrl + resource.image,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            resource.blogsName,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: AppColor.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: LinkText(
                                              "Read more >>",
                                              onPressed: () {
                                                model.goto(
                                                  ResourceView.tag,
                                                  arguments: ResourceArgument(
                                                      resource),
                                                );
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: model.resources.length,
                        ),
                      ),
                      if (model.canLoadMore)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CupertinoActivityIndicator(),
                            SizedBox(width: 16),
                            Text("Loading...")
                          ],
                        )
                    ],
                  ),
                ),
        );
      },
    );
  }
}
