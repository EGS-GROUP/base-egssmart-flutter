// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';

import 'dart:convert';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/Login/login_screen.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/event_json.dart';
import 'package:idempiere_app/Screens/app/shared_components/chatting_card.dart';
import 'package:idempiere_app/Screens/app/shared_components/list_profil_image.dart';
import 'package:idempiere_app/Screens/app/shared_components/progress_card.dart';
import 'package:idempiere_app/Screens/app/shared_components/progress_report_card.dart';
import 'package:idempiere_app/Screens/app/shared_components/project_card.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:idempiere_app/Screens/app/shared_components/selection_button.dart';
import 'package:idempiere_app/Screens/app/shared_components/task_card.dart';
import 'package:idempiere_app/Screens/app/shared_components/today_text.dart';
import 'package:idempiere_app/Screens/app/utils/helpers/app_helpers.dart';
//import 'package:idempiere_app/Screens/app/constans/app_constants.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
/* import 'package:nextcloud/nextcloud.dart';
import 'package:path_provider/path_provider.dart'; */

// binding
part '../../bindings/dashboard_binding.dart';

// controller
part '../../controllers/dashboard_controller.dart';

// models
part '../../models/profile.dart';

// component
//part '../components/active_project_card.dart';
part '../components/header.dart';
//part '../components/overview_header.dart';
part '../components/profile_tile.dart';
part '../components/recent_messages.dart';
part '../components/sidebar.dart';
part '../components/team_member.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.off(const LoginScreen());
        return false;
      },
      child: Scaffold(
        //key: controller.scaffoldKey,
        drawer: /* (ResponsiveBuilder.isDesktop(context))
            ? null
            : */
            Drawer(
          child: Padding(
            padding: const EdgeInsets.only(top: kSpacing),
            child: _Sidebar(data: controller.getSelectedProject()),
          ),
        ),
        body: SingleChildScrollView(
            child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return Column(children: [
              const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
              _buildHeader(
                  onPressedMenu: () => Scaffold.of(context).openDrawer()),
              const SizedBox(height: kSpacing / 2),
              const Divider(),
              Obx(() => _buildProfile(
                  data: controller.getProfil(),
                  counter: controller.notificationCounter.value)),
              //_buildProfile(data: controller.getProfil(), counter: 0),
              const SizedBox(height: kSpacing),
              Obx(() => Visibility(
                    visible: int.parse(controller.list[105], radix: 16)
                                .toRadixString(2)
                                .padLeft(4, "0")
                                .toString()[1] ==
                            "1"
                        ? true
                        : false,
                    child: _buildProgress(
                      axis: Axis.vertical,
                      text: controller.value.value,
                      function: controller.changeFilter,
                      done: controller.doneCount.value,
                      inprogress: controller.inProgressCount.value,
                      notYetStarted: controller.notDoneCount.value,
                    ),
                  )),

              const SizedBox(height: kSpacing * 1),

              Obx(
                () => Visibility(
                  visible: controller.workStartHour.value != "N/A" &&
                          int.parse(controller.list[105], radix: 16)
                                  .toRadixString(2)
                                  .padLeft(4, "0")
                                  .toString()[1] ==
                              "1"
                      ? true
                      : false,
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green)),
                    onPressed: () {},
                    icon: const Icon(
                      // <-- Icon
                      Icons.pending_actions_rounded,
                      size: 24.0,
                    ),
                    label: Text('You Started at '.tr +
                        controller.workStartHour.value), // <-- Text
                  ),
                ),
              ),

              Obx(
                () => Visibility(
                  visible: controller.workStartHour.value != "N/A" &&
                          int.parse(controller.list[105], radix: 16)
                                  .toRadixString(2)
                                  .padLeft(4, "0")
                                  .toString()[1] ==
                              "1"
                      ? true
                      : false,
                  child: Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.green)),
                      onPressed: () {},
                      icon: const Icon(
                        // <-- Icon
                        Icons.pending_actions_rounded,
                        size: 24.0,
                      ),
                      label: Text(
                          "${"You've done".tr} ${controller.totWorkHour.value} ${"hours today".tr}"), // <-- Text
                    ),
                  ),
                ),
              ),
              //  const SizedBox(height: kSpacing),
              //  _buildTeamMember(data: controller.getMember()),
              //  const SizedBox(height: kSpacing),
              /*  Padding(
                padding: const EdgeInsets.symmetric(horizontal: kSpacing),
                child: GetPremiumCard(onPressed: () {}),
              ), */
              /* const SizedBox(height: kSpacing * 1),
              _buildTaskOverview(
                data: controller.getAllTask(),
                headerAxis: Axis.vertical,
                crossAxisCount: 6,
                crossAxisCellCount: 6,
              ),
              const SizedBox(height: kSpacing * 2),
              _buildActiveProject(
                data: controller.getActiveProject(),
                crossAxisCount: 6,
                crossAxisCellCount: 6,
              ),
              const SizedBox(height: kSpacing),
              _buildRecentMessages(data: controller.getChatting()), */
            ]);
          },
          tabletBuilder: (context, constraints) {
            return Column(children: [
              const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
              _buildHeader(
                  onPressedMenu: () => Scaffold.of(context).openDrawer()),
              const SizedBox(height: kSpacing / 2),
              const Divider(),
              Obx(() => _buildProfile(
                  data: controller.getProfil(),
                  counter: controller.notificationCounter.value)),
              //_buildProfile(data: controller.getProfil(), counter: 0),
              const SizedBox(height: kSpacing),
              Obx(() => Visibility(
                    visible: int.parse(controller.list[105], radix: 16)
                                .toRadixString(2)
                                .padLeft(4, "0")
                                .toString()[1] ==
                            "1"
                        ? true
                        : false,
                    child: _buildProgress(
                      axis: Axis.vertical,
                      text: controller.value.value,
                      function: controller.changeFilter,
                      done: controller.doneCount.value,
                      inprogress: controller.inProgressCount.value,
                      notYetStarted: controller.notDoneCount.value,
                    ),
                  )),

              const SizedBox(height: kSpacing * 1),

              Obx(
                () => Visibility(
                  visible: controller.workStartHour.value != "N/A" &&
                          int.parse(controller.list[105], radix: 16)
                                  .toRadixString(2)
                                  .padLeft(4, "0")
                                  .toString()[1] ==
                              "1"
                      ? true
                      : false,
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green)),
                    onPressed: () {},
                    icon: const Icon(
                      // <-- Icon
                      Icons.pending_actions_rounded,
                      size: 24.0,
                    ),
                    label: Text('You Started at '.tr +
                        controller.workStartHour.value), // <-- Text
                  ),
                ),
              ),
              //  const SizedBox(height: kSpacing),
              //  _buildTeamMember(data: controller.getMember()),
              //  const SizedBox(height: kSpacing),
              /*  Padding(
                padding: const EdgeInsets.symmetric(horizontal: kSpacing),
                child: GetPremiumCard(onPressed: () {}),
              ), */
              /* const SizedBox(height: kSpacing * 1),
              _buildTaskOverview(
                data: controller.getAllTask(),
                headerAxis: Axis.vertical,
                crossAxisCount: 6,
                crossAxisCellCount: 6,
              ),
              const SizedBox(height: kSpacing * 2),
              _buildActiveProject(
                data: controller.getActiveProject(),
                crossAxisCount: 6,
                crossAxisCellCount: 6,
              ),
              const SizedBox(height: kSpacing),
              _buildRecentMessages(data: controller.getChatting()), */
            ]);
          },
          desktopBuilder: (context, constraints) {
            return Column(children: [
              const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
              _buildHeader(
                  onPressedMenu: () => Scaffold.of(context).openDrawer()),
              const SizedBox(height: kSpacing / 2),
              const Divider(),
              Obx(() => _buildProfile(
                  data: controller.getProfil(),
                  counter: controller.notificationCounter.value)),
              //_buildProfile(data: controller.getProfil(), counter: 0),
              const SizedBox(height: kSpacing),
              Obx(() => Visibility(
                    visible: int.parse(controller.list[105], radix: 16)
                                .toRadixString(2)
                                .padLeft(4, "0")
                                .toString()[1] ==
                            "1"
                        ? true
                        : false,
                    child: _buildProgress(
                      axis: Axis.vertical,
                      text: controller.value.value,
                      function: controller.changeFilter,
                      done: controller.doneCount.value,
                      inprogress: controller.inProgressCount.value,
                      notYetStarted: controller.notDoneCount.value,
                    ),
                  )),

              const SizedBox(height: kSpacing * 1),

              Obx(
                () => Visibility(
                  visible: controller.workStartHour.value != "N/A" &&
                          int.parse(controller.list[105], radix: 16)
                                  .toRadixString(2)
                                  .padLeft(4, "0")
                                  .toString()[1] ==
                              "1"
                      ? true
                      : false,
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green)),
                    onPressed: () {},
                    icon: const Icon(
                      // <-- Icon
                      Icons.pending_actions_rounded,
                      size: 24.0,
                    ),
                    label: Text('You Started at '.tr +
                        controller.workStartHour.value), // <-- Text
                  ),
                ),
              ),
              //  const SizedBox(height: kSpacing),
              //  _buildTeamMember(data: controller.getMember()),
              //  const SizedBox(height: kSpacing),
              /*  Padding(
                padding: const EdgeInsets.symmetric(horizontal: kSpacing),
                child: GetPremiumCard(onPressed: () {}),
              ), */
              /* const SizedBox(height: kSpacing * 1),
              _buildTaskOverview(
                data: controller.getAllTask(),
                headerAxis: Axis.vertical,
                crossAxisCount: 6,
                crossAxisCellCount: 6,
              ),
              const SizedBox(height: kSpacing * 2),
              _buildActiveProject(
                data: controller.getActiveProject(),
                crossAxisCount: 6,
                crossAxisCellCount: 6,
              ),
              const SizedBox(height: kSpacing),
              _buildRecentMessages(data: controller.getChatting()), */
            ]);
          },
        )),
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

  Widget _buildProgress({
    Axis axis = Axis.horizontal,
    required String text,
    required Function() function,
    int done = 0,
    int inprogress = 0,
    int notYetStarted = 0,
  }) {
    var totTask = done + inprogress + notYetStarted;
    var totUndone = notYetStarted + inprogress;
    double perc = (totTask - inprogress - notYetStarted) / totTask;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: (axis == Axis.horizontal)
          ? Row(
              children: [
                Flexible(
                  flex: 5,
                  child: ProgressCard(
                    data: ProgressCardData(
                      totalUndone: notYetStarted,
                      totalTaskInProress: inprogress,
                    ),
                    onPressedCheck: () {
                      //print("kiao");
                    },
                    text: text,
                  ),
                ),
                const SizedBox(width: kSpacing / 2),
                Flexible(
                  flex: 4,
                  child: ProgressReportCard(
                    data: ProgressReportCardData(
                      title: "For Today you have",
                      doneTask: done,
                      percent: perc,
                      task: totTask,
                      undoneTask: totUndone,
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                ProgressCard(
                  data: ProgressCardData(
                    totalUndone: notYetStarted,
                    totalTaskInProress: inprogress,
                  ),
                  onPressedCheck: () {},
                  text: text,
                ),
                /* const SizedBox(height: kSpacing / 2),
                ProgressReportCard(
                  data: ProgressReportCardData(
                    title: "For Today you have",
                    doneTask: done,
                    percent: perc,
                    task: totTask,
                    undoneTask: totUndone,
                  ),
                ), */
              ],
            ),
    );
  }

  /* Widget _buildTaskOverview({
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
  } */

  Widget _buildProfile({required _Profile data, required int counter}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: _ProfilTile(
        data: data,
        onPressedNotification: () {
          Get.offNamed('/Notification');
        },
        counter: counter,
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
