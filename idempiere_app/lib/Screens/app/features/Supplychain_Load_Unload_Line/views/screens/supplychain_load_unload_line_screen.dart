library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Load_Unload_Line/models/loadunloadjsonline.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Load_Unload_Line/views/screens/supplychain_create_load_unload_line.dart';
import 'package:idempiere_app/Screens/app/shared_components/chatting_card.dart';
import 'package:idempiere_app/Screens/app/shared_components/get_premium_card.dart';
import 'package:idempiere_app/Screens/app/shared_components/list_profil_image.dart';
import 'package:idempiere_app/Screens/app/shared_components/progress_card.dart';
import 'package:idempiere_app/Screens/app/shared_components/progress_report_card.dart';
import 'package:idempiere_app/Screens/app/shared_components/project_card.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:idempiere_app/Screens/app/shared_components/search_field.dart';
import 'package:idempiere_app/Screens/app/shared_components/selection_button.dart';
import 'package:idempiere_app/Screens/app/shared_components/task_card.dart';
import 'package:idempiere_app/Screens/app/shared_components/today_text.dart';
import 'package:idempiere_app/Screens/app/utils/helpers/app_helpers.dart';
//import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// binding
part '../../bindings/supplychain_load_unload_line_binding.dart';

// controller
part '../../controllers/supplychain_load_unload_line_controller.dart';

// models
part '../../models/profile.dart';

// component
part '../components/active_project_card.dart';
part '../components/header.dart';
part '../components/overview_header.dart';
part '../components/profile_tile.dart';
part '../components/recent_messages.dart';
part '../components/sidebar.dart';
part '../components/team_member.dart';

class SupplychainLoadUnloadLineScreen
    extends GetView<SupplychainLoadUnloadLineController> {
  const SupplychainLoadUnloadLineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed('/Dashboard');
        return false;
      },
      child: Scaffold(
        //key: controller.scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(Get.arguments["docNo"]),
          leading: IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              Get.offNamed('/SupplychainLoadUnload');
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: IconButton(
                onPressed: () {
                  Get.to(const CreateSupplychainLoadUnloadLine(), arguments: {
                    "id": Get.arguments["id"],
                  });
                },
                icon: const Icon(
                  Icons.add,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: ResponsiveBuilder(
            mobileBuilder: (context, constraints) {
              return Column(children: [
                const SizedBox(height: kSpacing),
                Obx(
                  () => controller.dataAvailable
                      ? ListView.builder(
                          primary: false,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: controller.trx.rowcount,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 8.0,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Color.fromRGBO(64, 75, 96, .9)),
                                child: ExpansionTile(
                                  tilePadding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  leading: Container(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            right: BorderSide(
                                                width: 1.0,
                                                color: Colors.white24))),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.green,
                                      ),
                                      tooltip: 'Edit',
                                      onPressed: () {
                                        //log("info button pressed");
                                      },
                                    ),
                                  ),
                                  title: Text(
                                    controller.trx.records![index].mProductID
                                            ?.identifier ??
                                        "???",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                                  /* trailing: IconButton(
                                    icon: Icon(
                                      Icons.article,
                                      color: controller.trx.records![index]
                                                  .docStatus?.id ==
                                              "CO"
                                          ? Colors.green
                                          : Colors.yellow,
                                    ),
                                    onPressed: () {},
                                  ), */
                                  subtitle: Row(
                                    children: <Widget>[
                                      const Icon(Icons.linear_scale_outlined),
                                      Text(
                                        controller
                                                .trx
                                                .records![index]
                                                .mAttributeSetInstanceID
                                                ?.identifier ??
                                            "??",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  /* trailing: const Icon(
                                      Icons.keyboard_arrow_right,
                                      color: Colors.white,
                                      size: 30.0,
                                    ), */
                                  childrenPadding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              "Stock Area: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(controller.trx.records![index]
                                                    .mLocatorID?.identifier ??
                                                ""),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Quantity: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(controller.trx.records![index]
                                                .qtyInternalUse
                                                .toString()),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
              ]);
            },
            tabletBuilder: (context, constraints) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: (constraints.maxWidth < 950) ? 6 : 9,
                    child: Column(
                      children: [
                        const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
                        _buildHeader(
                            onPressedMenu: () =>
                                Scaffold.of(context).openDrawer()),
                        const SizedBox(height: kSpacing * 2),
                        _buildProgress(
                          axis: (constraints.maxWidth < 950)
                              ? Axis.vertical
                              : Axis.horizontal,
                        ),
                        const SizedBox(height: kSpacing * 2),
                        _buildTaskOverview(
                          data: controller.getAllTask(),
                          headerAxis: (constraints.maxWidth < 850)
                              ? Axis.vertical
                              : Axis.horizontal,
                          crossAxisCount: 6,
                          crossAxisCellCount: (constraints.maxWidth < 950)
                              ? 6
                              : (constraints.maxWidth < 1100)
                                  ? 3
                                  : 2,
                        ),
                        const SizedBox(height: kSpacing * 2),
                        _buildActiveProject(
                          data: controller.getActiveProject(),
                          crossAxisCount: 6,
                          crossAxisCellCount: (constraints.maxWidth < 950)
                              ? 6
                              : (constraints.maxWidth < 1100)
                                  ? 3
                                  : 2,
                        ),
                        const SizedBox(height: kSpacing),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Column(
                      children: [
                        const SizedBox(height: kSpacing * (kIsWeb ? 0.5 : 1.5)),
                        _buildProfile(data: controller.getProfil()),
                        const Divider(thickness: 1),
                        const SizedBox(height: kSpacing),
                        _buildTeamMember(data: controller.getMember()),
                        const SizedBox(height: kSpacing),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: kSpacing),
                          child: GetPremiumCard(onPressed: () {}),
                        ),
                        const SizedBox(height: kSpacing),
                        const Divider(thickness: 1),
                        const SizedBox(height: kSpacing),
                        _buildRecentMessages(data: controller.getChatting()),
                      ],
                    ),
                  )
                ],
              );
            },
            desktopBuilder: (context, constraints) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: (constraints.maxWidth < 1360) ? 4 : 3,
                    child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(kBorderRadius),
                          bottomRight: Radius.circular(kBorderRadius),
                        ),
                        child: _Sidebar(data: controller.getSelectedProject())),
                  ),
                  Flexible(
                    flex: 9,
                    child: Column(
                      children: [
                        const SizedBox(height: kSpacing),
                        _buildHeader(),
                        const SizedBox(height: kSpacing * 2),
                        _buildProgress(),
                        const SizedBox(height: kSpacing * 2),
                        _buildTaskOverview(
                          data: controller.getAllTask(),
                          crossAxisCount: 6,
                          crossAxisCellCount:
                              (constraints.maxWidth < 1360) ? 3 : 2,
                        ),
                        const SizedBox(height: kSpacing * 2),
                        _buildActiveProject(
                          data: controller.getActiveProject(),
                          crossAxisCount: 6,
                          crossAxisCellCount:
                              (constraints.maxWidth < 1360) ? 3 : 2,
                        ),
                        const SizedBox(height: kSpacing),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Column(
                      children: [
                        const SizedBox(height: kSpacing / 2),
                        _buildProfile(data: controller.getProfil()),
                        const Divider(thickness: 1),
                        const SizedBox(height: kSpacing),
                        _buildTeamMember(data: controller.getMember()),
                        const SizedBox(height: kSpacing),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: kSpacing),
                          child: GetPremiumCard(onPressed: () {}),
                        ),
                        const SizedBox(height: kSpacing),
                        const Divider(thickness: 1),
                        const SizedBox(height: kSpacing),
                        _buildRecentMessages(data: controller.getChatting()),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader({Function()? onPressedMenu}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Row(
        children: [
          if (onPressedMenu != null)
            Padding(
              padding: const EdgeInsets.only(right: kSpacing),
              child: IconButton(
                onPressed: onPressedMenu,
                icon: const Icon(EvaIcons.menu),
                tooltip: "menu",
              ),
            ),
          const Expanded(child: _Header()),
        ],
      ),
    );
  }

  Widget _buildProgress({Axis axis = Axis.horizontal}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: (axis == Axis.horizontal)
          ? Row(
              children: [
                Flexible(
                  flex: 5,
                  child: ProgressCard(
                    data: const ProgressCardData(
                      totalUndone: 10,
                      totalTaskInProress: 2,
                    ),
                    onPressedCheck: () {},
                  ),
                ),
                const SizedBox(width: kSpacing / 2),
                Flexible(
                  flex: 4,
                  child: ProgressReportCard(
                    data: ProgressReportCardData(
                      title: "1st Sprint",
                      doneTask: 5,
                      percent: .3,
                      task: 3,
                      undoneTask: 2,
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                ProgressCard(
                  data: const ProgressCardData(
                    totalUndone: 10,
                    totalTaskInProress: 2,
                  ),
                  onPressedCheck: () {},
                ),
                const SizedBox(height: kSpacing / 2),
                ProgressReportCard(
                  data: ProgressReportCardData(
                    title: "1st Sprint",
                    doneTask: 5,
                    percent: .3,
                    task: 3,
                    undoneTask: 2,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTaskOverview({
    required List<TaskCardData> data,
    int crossAxisCount = 6,
    int crossAxisCellCount = 2,
    Axis headerAxis = Axis.horizontal,
  }) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: crossAxisCount,
      itemCount: data.length + 1,
      addAutomaticKeepAlives: false,
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return (index == 0)
            ? Padding(
                padding: const EdgeInsets.only(bottom: kSpacing),
                child: _OverviewHeader(
                  axis: headerAxis,
                  onSelected: (task) {},
                ),
              )
            : TaskCard(
                data: data[index - 1],
                onPressedMore: () {},
                onPressedTask: () {},
                onPressedContributors: () {},
                onPressedComments: () {},
              );
      },
      staggeredTileBuilder: (int index) =>
          StaggeredTile.fit((index == 0) ? crossAxisCount : crossAxisCellCount),
    );
  }

  Widget _buildActiveProject({
    required List<ProjectCardData> data,
    int crossAxisCount = 6,
    int crossAxisCellCount = 2,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: _ActiveProjectCard(
        onPressedSeeAll: () {},
        child: StaggeredGridView.countBuilder(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          itemCount: data.length,
          addAutomaticKeepAlives: false,
          mainAxisSpacing: kSpacing,
          crossAxisSpacing: kSpacing,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ProjectCard(data: data[index]);
          },
          staggeredTileBuilder: (int index) =>
              StaggeredTile.fit(crossAxisCellCount),
        ),
      ),
    );
  }

  Widget _buildProfile({required _Profile data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: _ProfilTile(
        data: data,
        onPressedNotification: () {},
      ),
    );
  }

  Widget _buildTeamMember({required List<ImageProvider> data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TeamMember(
            totalMember: data.length,
            onPressedAdd: () {},
          ),
          const SizedBox(height: kSpacing / 2),
          ListProfilImage(maxImages: 6, images: data),
        ],
      ),
    );
  }

  Widget _buildRecentMessages({required List<ChattingCardData> data}) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: kSpacing),
        child: _RecentMessages(onPressedMore: () {}),
      ),
      const SizedBox(height: kSpacing / 2),
      ...data
          .map(
            (e) => ChattingCard(data: e, onPressed: () {}),
          )
          .toList(),
    ]);
  }
}
