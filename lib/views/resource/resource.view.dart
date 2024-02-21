import 'package:bestfriend/bestfriend.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mysirani/constants/api_urls.dart';
import 'package:mysirani/helpers/date_time_format.helper.dart';
import 'package:mysirani/theme.dart';
import 'package:mysirani/views/resource/resource.argument.dart';
import 'package:mysirani/views/resource/resource.model.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceView extends StatelessWidget {
  final Arguments? arguments;

  static String tag = 'resource-view';

  const ResourceView(this.arguments, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<ResourceModel>(
      onModelReady: (model) => model.init(arguments as ResourceArgument),
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Resource'),
          ),
          body: Stack(
            children: [
              SizedBox(
                height: 200,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: auImageBaseUrl + model.resource.image,
                  fit: BoxFit.cover,
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 182),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, -2),
                            color: Colors.black12,
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.resource.blogsName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                MdiIcons.calendar,
                                color: AppColor.secondaryTextColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                formattedDateTime(
                                  model.resource.addedDate,
                                  showTime: false,
                                ),
                                style: const TextStyle(
                                  color: AppColor.secondaryTextColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (model.resource.youtube != null &&
                              model.resource.youtube!.isNotEmpty)
                            ActionChip(
                              label: const Text("Watch Video On YouTube"),
                              onPressed: () {
                                launch(model.resource.youtube!);
                              },
                              backgroundColor: Colors.red,
                              avatar: const Icon(
                                MdiIcons.youtube,
                                color: Colors.white,
                              ),
                              labelStyle: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          const SizedBox(height: 16),
                          Html(
                            data: model.resource.blogsDesc,
                            onLinkTap:
                                (url, context, attributes, element) async {
                              if (await canLaunch(url!)) {
                                await launch(url);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
