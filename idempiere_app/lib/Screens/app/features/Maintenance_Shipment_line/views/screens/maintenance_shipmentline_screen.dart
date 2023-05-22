// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Shipment_line/models/shipmentline_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Shipment_line/views/screens/crm_shipmentline_edit.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Shipment_line/views/screens/maintenance_shipmentline_create.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Shipment_line/views/screens/maintenance_shipmentline_edit.dart';
import 'package:idempiere_app/Screens/app/shared_components/chatting_card.dart';
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
import 'package:url_launcher/url_launcher.dart';

// binding
part '../../bindings/maintenance_shipmentline_binding.dart';

// controller
part '../../controllers/maintenance_shipmentline_controller.dart';

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

class MaintenanceShipmentlineScreen
    extends GetView<MaintenanceShipmentlineController> {
  const MaintenanceShipmentlineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shipments Lines"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () async {
                Get.to(const CreateMaintenanceShipmentline(), arguments: {
                  "id": Get.arguments["id"],
                });
              },
              icon: const Icon(
                Icons.add,
              ),
            ),
          ),
        ],
        /* leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Get.offNamed('/MaintenanceMptask');
          },
        ), */
      ),
      //key: controller.scaffoldKey,
      /* drawer: (ResponsiveBuilder.isDesktop(context))
          ? null
          : Drawer(
              child: Padding(
                padding: const EdgeInsets.only(top: kSpacing),
                child: _Sidebar(data: controller.getSelectedProject()),
              ),
            ), */
      body: SingleChildScrollView(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return Column(children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  //maxLines: 5,
                  readOnly: true,
                  controller: controller.bpFieldController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.handshake),
                    border: const OutlineInputBorder(),
                    labelText: 'Business Partner'.tr,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  readOnly: true,
                  //maxLines: 5,
                  controller: controller.documentFieldController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.note_alt),
                    border: const OutlineInputBorder(),
                    labelText: 'Document N°'.tr,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),

              /* const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
              _buildHeader(
                  onPressedMenu: () => Scaffold.of(context).openDrawer()),
              const SizedBox(height: kSpacing / 2),
              const Divider(),
              _buildProfile(data: controller.getProfil()), */

              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Obx(() => controller.dataAvailable
                        ? Text("Shipment Lines: ".tr +
                            controller.trx.rowcount.toString())
                        : Text("Shipment Lines: ".tr)),
                  ),
                  /* Container(
                    margin: const EdgeInsets.only(left: 40),
                    child: IconButton(
                      onPressed: () {
                        Get.to(const CreateLead());
                      },
                      icon: const Icon(
                        Icons.person_add,
                        color: Colors.lightBlue,
                      ),
                    ),
                  ), */
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: IconButton(
                      onPressed: () {
                        controller.getShipmentlines();
                      },
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.yellow,
                      ),
                    ),
                  ),
                  /* Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Obx(
                      () => TextButton(
                        onPressed: () {
                          controller.changeFilter();
                          //print("hello");
                        },
                        child: Text(controller.value.value),
                      ),
                    ),
                  ), */
                ],
              ),
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
                                  child: Column(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.green,
                                        ),
                                        tooltip: 'Edit Shipment'.tr,
                                        onPressed: () {
                                          //log("info button pressed");
                                          Get.to(
                                              const EditMaintenanceShipmentline(),
                                              arguments: {
                                                "id": controller
                                                    .trx.records![index].id,
                                                "qtyEntered": controller
                                                        .trx
                                                        .records![index]
                                                        .plannedQty ??
                                                    0,
                                                "description": controller
                                                        .trx
                                                        .records![index]
                                                        .description ??
                                                    "",
                                                "isSelected": controller
                                                        .trx
                                                        .records![index]
                                                        .isSelected ??
                                                    false,
                                              });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: controller.trx.records![index]
                                                  .isSelected ==
                                              null ||
                                          controller.trx.records![index]
                                                  .isSelected ==
                                              false
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.grey,
                                        )
                                      : const Icon(
                                          Icons.done_all,
                                          color: Colors.green,
                                        ),
                                  onPressed: () {},
                                ),
                                title: Text(
                                  controller.trx.records![index].mProductID
                                          ?.identifier ??
                                      '',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                subtitle: Column(children: [
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "- ${"Quantity".tr}: ".tr,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      Expanded(
                                        child: Text(
                                          controller
                                              .trx.records![index].qtyEntered
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
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
                                          Text(
                                            "Description: ".tr,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Expanded(
                                            child: Text(controller
                                                    .trx
                                                    .records![index]
                                                    .description ??
                                                ""),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${"Help".tr}: ".tr,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Expanded(
                                            child: Text(controller
                                                    .trx.records![index].help ??
                                                ""),
                                          ),
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
            return Column(children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  //maxLines: 5,
                  readOnly: true,
                  controller: controller.bpFieldController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.handshake),
                    border: const OutlineInputBorder(),
                    labelText: 'Business Partner'.tr,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  readOnly: true,
                  //maxLines: 5,
                  controller: controller.documentFieldController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.note_alt),
                    border: const OutlineInputBorder(),
                    labelText: 'Document N°'.tr,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),

              /* const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
              _buildHeader(
                  onPressedMenu: () => Scaffold.of(context).openDrawer()),
              const SizedBox(height: kSpacing / 2),
              const Divider(),
              _buildProfile(data: controller.getProfil()), */

              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Obx(() => controller.dataAvailable
                        ? Text("Shipment Lines: ".tr +
                            controller.trx.rowcount.toString())
                        : Text("Shipment Lines: ".tr)),
                  ),
                  /* Container(
                    margin: const EdgeInsets.only(left: 40),
                    child: IconButton(
                      onPressed: () {
                        Get.to(const CreateLead());
                      },
                      icon: const Icon(
                        Icons.person_add,
                        color: Colors.lightBlue,
                      ),
                    ),
                  ), */
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: IconButton(
                      onPressed: () {
                        controller.getShipmentlines();
                      },
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.yellow,
                      ),
                    ),
                  ),
                  /* Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Obx(
                      () => TextButton(
                        onPressed: () {
                          controller.changeFilter();
                          //print("hello");
                        },
                        child: Text(controller.value.value),
                      ),
                    ),
                  ), */
                ],
              ),
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
                                  child: Column(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.green,
                                        ),
                                        tooltip: 'Edit Shipment'.tr,
                                        onPressed: () {
                                          //log("info button pressed");
                                          Get.to(
                                              const EditMaintenanceShipmentline(),
                                              arguments: {
                                                "id": controller
                                                    .trx.records![index].id,
                                                "qtyEntered": controller
                                                        .trx
                                                        .records![index]
                                                        .plannedQty ??
                                                    0,
                                                "description": controller
                                                        .trx
                                                        .records![index]
                                                        .description ??
                                                    "",
                                                "isSelected": controller
                                                        .trx
                                                        .records![index]
                                                        .isSelected ??
                                                    false,
                                              });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: controller.trx.records![index]
                                                  .isSelected ==
                                              null ||
                                          controller.trx.records![index]
                                                  .isSelected ==
                                              false
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.grey,
                                        )
                                      : const Icon(
                                          Icons.done_all,
                                          color: Colors.green,
                                        ),
                                  onPressed: () {},
                                ),
                                title: Text(
                                  controller.trx.records![index].mProductID
                                          ?.identifier ??
                                      '',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                subtitle: Column(children: [
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "- ${"Quantity".tr}: ".tr,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      Expanded(
                                        child: Text(
                                          controller
                                              .trx.records![index].qtyEntered
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
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
                                          Text(
                                            "Description: ".tr,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Expanded(
                                            child: Text(controller
                                                    .trx
                                                    .records![index]
                                                    .description ??
                                                ""),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${"Help".tr}: ".tr,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Expanded(
                                            child: Text(controller
                                                    .trx.records![index].help ??
                                                ""),
                                          ),
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
          desktopBuilder: (context, constraints) {
            return Column(children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  //maxLines: 5,
                  readOnly: true,
                  controller: controller.bpFieldController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.handshake),
                    border: const OutlineInputBorder(),
                    labelText: 'Business Partner'.tr,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  readOnly: true,
                  //maxLines: 5,
                  controller: controller.documentFieldController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.note_alt),
                    border: const OutlineInputBorder(),
                    labelText: 'Document N°'.tr,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),

              /* const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
              _buildHeader(
                  onPressedMenu: () => Scaffold.of(context).openDrawer()),
              const SizedBox(height: kSpacing / 2),
              const Divider(),
              _buildProfile(data: controller.getProfil()), */

              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Obx(() => controller.dataAvailable
                        ? Text("Shipment Lines: ".tr +
                            controller.trx.rowcount.toString())
                        : Text("Shipment Lines: ".tr)),
                  ),
                  /* Container(
                    margin: const EdgeInsets.only(left: 40),
                    child: IconButton(
                      onPressed: () {
                        Get.to(const CreateLead());
                      },
                      icon: const Icon(
                        Icons.person_add,
                        color: Colors.lightBlue,
                      ),
                    ),
                  ), */
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: IconButton(
                      onPressed: () {
                        controller.getShipmentlines();
                      },
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.yellow,
                      ),
                    ),
                  ),
                  /* Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Obx(
                      () => TextButton(
                        onPressed: () {
                          controller.changeFilter();
                          //print("hello");
                        },
                        child: Text(controller.value.value),
                      ),
                    ),
                  ), */
                ],
              ),
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
                                  child: Column(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.green,
                                        ),
                                        tooltip: 'Edit Shipment'.tr,
                                        onPressed: () {
                                          //log("info button pressed");
                                          Get.to(
                                              const EditMaintenanceShipmentline(),
                                              arguments: {
                                                "id": controller
                                                    .trx.records![index].id,
                                                "qtyEntered": controller
                                                        .trx
                                                        .records![index]
                                                        .plannedQty ??
                                                    0,
                                                "description": controller
                                                        .trx
                                                        .records![index]
                                                        .description ??
                                                    "",
                                                "isSelected": controller
                                                        .trx
                                                        .records![index]
                                                        .isSelected ??
                                                    false,
                                              });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: controller.trx.records![index]
                                                  .isSelected ==
                                              null ||
                                          controller.trx.records![index]
                                                  .isSelected ==
                                              false
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.grey,
                                        )
                                      : const Icon(
                                          Icons.done_all,
                                          color: Colors.green,
                                        ),
                                  onPressed: () {},
                                ),
                                title: Text(
                                  controller.trx.records![index].mProductID
                                          ?.identifier ??
                                      '',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                subtitle: Column(children: [
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "- ${"Quantity".tr}: ".tr,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      Expanded(
                                        child: Text(
                                          controller
                                              .trx.records![index].qtyEntered
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
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
                                          Text(
                                            "Description: ".tr,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Expanded(
                                            child: Text(controller
                                                    .trx
                                                    .records![index]
                                                    .description ??
                                                ""),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${"Help".tr}: ".tr,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Expanded(
                                            child: Text(controller
                                                    .trx.records![index].help ??
                                                ""),
                                          ),
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
