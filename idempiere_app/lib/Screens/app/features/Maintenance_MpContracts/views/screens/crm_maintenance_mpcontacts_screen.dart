// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_MpContracts/models/mpmaintaincontractjson.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_MpContracts/views/screens/crm_edit_lmaintenance_mpcontacts.dart';
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
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

// binding
part '../../bindings/maintenance_mpcontracts_binding.dart';

// controller
part '../../controllers/maintenance_mpcontacts_controller.dart';

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

class MaintenanceMpContractsScreen
    extends GetView<MaintenanceMpContractsController> {
  const MaintenanceMpContractsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<dynamic> list = GetStorage().read('permission');
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed('/Dashboard');
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
                _buildProfile(data: controller.getProfil()),
                const SizedBox(height: kSpacing),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: Obx(() => controller.dataAvailable
                          ? Text(
                              "${"Plant Maint.".tr}: ${controller._trx.records!.length}")
                          : Text("${"Plant Maint.".tr}: ")),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: IconButton(
                        onPressed: () {
                          //Get.to(const CreateLead());
                          Get.toNamed("/MaintenanceMpContractsCreateContract");
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.lightBlue,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: IconButton(
                        onPressed: () {
                          controller.syncMaintain();
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: Obx(
                        () => TextButton(
                          onPressed: () {
                            controller.changeFilter();
                            //print("hello");
                          },
                          child: Text(controller.value.value),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      //padding: const EdgeInsets.all(10),
                      //width: 20,
                      /* decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ), */
                      child: Obx(
                        () => DropdownButton(
                          icon: const Icon(Icons.filter_alt_sharp),
                          value: controller.dropdownValue.value,
                          elevation: 16,
                          onChanged: (String? newValue) {
                            controller.dropdownValue.value = newValue!;

                            //print(dropdownValue);
                          },
                          items: controller.dropDownList.map((list) {
                            return DropdownMenuItem<String>(
                              value: list.id,
                              child: Text(
                                list.name.toString(),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: TextField(
                          controller: controller.searchFieldController,
                          onSubmitted: (String? value) {
                            controller.searchFilterValue.value =
                                controller.searchFieldController.text;
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search_outlined),
                            border: const OutlineInputBorder(),
                            //labelText: 'Product Value',
                            hintText: 'Search'.tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kSpacing),
                Obx(
                  () => controller.dataAvailable
                      ? ListView.builder(
                          primary: false,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: controller._trx.records!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Obx(
                              () => Visibility(
                                visible: controller.searchFilterValue.value ==
                                        ""
                                    ? true
                                    : controller.dropdownValue.value == "1"
                                        ? controller._trx.records![index]
                                            .cBPartnerID!.identifier
                                            .toString()
                                            .toLowerCase()
                                            .contains(controller
                                                .searchFilterValue.value
                                                .toLowerCase())
                                        : controller.dropdownValue.value == "2"
                                            ? controller
                                                ._trx.records![index].documentNo
                                                .toString()
                                                .toLowerCase()
                                                .contains(controller
                                                    .searchFilterValue.value
                                                    .toLowerCase())
                                            : controller.dropdownValue.value ==
                                                    "3"
                                                ? controller
                                                    ._trx.records![index].phone
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains(
                                                        controller.searchFilterValue.value.toLowerCase())
                                                : controller.dropdownValue.value == "4" && controller.trx.records![index].cSalesRegionID != null
                                                    ? controller._trx.records![index].cSalesRegionID!.identifier.toString().toLowerCase().contains(controller.searchFilterValue.value.toLowerCase())
                                                    : true,
                                child: Card(
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
                                        padding:
                                            const EdgeInsets.only(right: 12.0),
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
                                          tooltip: 'Edit Lead'.tr,
                                          onPressed: () {
                                            Get.to(
                                                const EditMaintenanceMpContracts(),
                                                arguments: {
                                                  "maintainId": controller
                                                      ._trx.records![index].id,
                                                  "businesspartnerId":
                                                      controller
                                                          ._trx
                                                          .records![index]
                                                          .cBPartnerID
                                                          ?.id,
                                                  "businesspartnerName":
                                                      controller
                                                          ._trx
                                                          .records![index]
                                                          .cBPartnerID
                                                          ?.identifier,
                                                  "date": controller
                                                      ._trx
                                                      .records![index]
                                                      .dateNextRun,
                                                  "technicianId": controller
                                                      ._trx
                                                      .records![index]
                                                      .adUserID
                                                      ?.id,
                                                  "technicianName": controller
                                                      ._trx
                                                      .records![index]
                                                      .adUserID
                                                      ?.identifier,
                                                  "help": controller
                                                      ._trx
                                                      .records![index]
                                                      .litMpMaintainHelp,
                                                });
                                            //log("info button pressed");
                                            /*   Get.to(const EditLead(),
                                                arguments: {
                                                  "id": controller.trx
                                                      .windowrecords![index].id,
                                                  "name": controller
                                                          .trx
                                                          .windowrecords![index]
                                                          .name ??
                                                      "",
                                                  "leadStatus": controller
                                                          .trx
                                                          .windowrecords![index]
                                                          .leadStatus
                                                          ?.id ??
                                                      "",
                                                  "bpName": controller
                                                      .trx
                                                      .windowrecords![index]
                                                      .bPName,
                                                  "Tel": controller
                                                          .trx
                                                          .windowrecords![index]
                                                          .phone ??
                                                      "",
                                                  "eMail": controller
                                                          .trx
                                                          .windowrecords![index]
                                                          .eMail ??
                                                      "",
                                                  "salesRep": controller
                                                          .trx
                                                          .windowrecords![index]
                                                          .salesRepID
                                                          ?.identifier ??
                                                      ""
                                                }); */
                                          },
                                        ),
                                      ),
                                      title: Text(
                                        controller._trx.records![index]
                                                .cBPartnerID!.identifier ??
                                            "???",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                      subtitle: Row(
                                        children: <Widget>[
                                          const Icon(EvaIcons.hashOutline,
                                              color: Colors.yellowAccent),
                                          Text(
                                            controller._trx.records![index]
                                                    .documentNo ??
                                                "??",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        tooltip: 'Zoom Work Order',
                                        onPressed: () {
                                          if (controller._trx.records![index]
                                                  .latestWorkOrderId !=
                                              null) {
                                            if (int.parse(list[24], radix: 16)
                                                    .toRadixString(2)
                                                    .padLeft(4, "0")
                                                    .toString()[1] ==
                                                "1") {
                                              Get.offNamed('/MaintenanceMptask',
                                                  arguments: {
                                                    'notificationId': controller
                                                        ._trx
                                                        .records![index]
                                                        .latestWorkOrderId
                                                  });
                                            } else if (int.parse(list[31],
                                                        radix: 16)
                                                    .toRadixString(2)
                                                    .padLeft(4, "0")
                                                    .toString()[1] ==
                                                "1") {
                                              Get.offNamed(
                                                  '/MaintenanceMptaskStandard',
                                                  arguments: {
                                                    'notificationId': controller
                                                        ._trx
                                                        .records![index]
                                                        .latestWorkOrderId
                                                  });
                                            }
                                          }
                                        },
                                        icon: Icon(
                                          controller._trx.records![index]
                                                      .latestWorkOrderId !=
                                                  null
                                              ? Icons.search
                                              : Icons.search_off,
                                          color: controller._trx.records![index]
                                                      .latestWorkOrderId ==
                                                  null
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                      ),
                                      childrenPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 10.0),
                                      children: [
                                        Column(
                                          children: [
                                            /* Row(
                                              children: [
                                                const Text(
                                                  "Address: ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(controller
                                                          .trx
                                                          .records![index]
                                                          .cbPartnerLocationID
                                                          ?.identifier ??
                                                      ""),
                                                ),
                                              ],
                                            ), */
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.call,
                                                    color: Colors.green,
                                                  ),
                                                  tooltip: 'Call',
                                                  onPressed: () {
                                                    //log("info button pressed");
                                                    if (controller
                                                            ._trx
                                                            .records![index]
                                                            .phone ==
                                                        null) {
                                                      log("info button pressed");
                                                    } else {
                                                      controller.makePhoneCall(
                                                          controller
                                                              ._trx
                                                              .records![index]
                                                              .phone
                                                              .toString());
                                                    }
                                                  },
                                                ),
                                                Text(controller
                                                        ._trx
                                                        .records![index]
                                                        .phone ??
                                                    ""),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "${'Note Plant'.tr}: ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(controller
                                                          ._trx
                                                          .records![index]
                                                          .litMpMaintainHelp ??
                                                      ""),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                /* const Text(
                                              "BPartner: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ), */
                                                Icon(Icons.location_pin,
                                                    color: Colors.red.shade700),
                                                Expanded(
                                                  child: Text(
                                                      "${controller._trx.records![index].cLocationAddress1}, ${controller.trx.records![index].cLocationPostal} ${controller.trx.records![index].cLocationCity}"),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "${"Team".tr}:  ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(controller
                                                          ._trx
                                                          .records![index]
                                                          .team ??
                                                      ""),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "${"Selling Area".tr}:  ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(controller
                                                          ._trx
                                                          .records![index]
                                                          .cSalesRegionID
                                                          ?.identifier ??
                                                      ""),
                                                )
                                              ],
                                            ),
                                            /* Row(
                                              children: [
                                                Text(
                                                  "${"Contract Type".tr}:  ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(controller.trx.records![index].lit),
                                                )
                                              ],
                                            ), */
                                            Row(
                                              children: [
                                                Text(
                                                  "${"Date Next Run".tr}:  ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(controller
                                                              ._trx
                                                              .records![index]
                                                              .dateNextRun !=
                                                          null
                                                      ? DateFormat('dd-MM-yyyy')
                                                          .format(DateTime
                                                              .parse(controller
                                                                  ._trx
                                                                  .records![
                                                                      index]
                                                                  .dateNextRun!))
                                                      : "-"),
                                                )
                                              ],
                                            ),
                                            Visibility(
                                              visible: controller
                                                      ._trx
                                                      .records![index]
                                                      .latestWorkOrderDocNo !=
                                                  null,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "${"N° WO".tr}:  ",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Expanded(
                                                    child: Text(controller
                                                            ._trx
                                                            .records![index]
                                                            .latestWorkOrderDocNo ??
                                                        ""),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Visibility(
                                              visible: controller
                                                      ._trx
                                                      .records![index]
                                                      .cContractID
                                                      ?.id !=
                                                  null,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "${"Contract".tr}:  ",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Expanded(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        Get.offNamed(
                                                            '/Contract',
                                                            arguments: {
                                                              'notificationId':
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .cContractID
                                                                      ?.id,
                                                            });
                                                      },
                                                      child: Text(
                                                        '${controller._trx.records![index].cContractID?.identifier}',
                                                        style: const TextStyle(
                                                            color: kNotifColor),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "${"Latest Work Order".tr}:  ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(controller
                                                              .trx
                                                              .records![index]
                                                              .latestWorkOrder !=
                                                          null
                                                      ? DateFormat('dd-MM-yyyy')
                                                          .format(DateTime
                                                              .parse(controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .latestWorkOrder!))
                                                      : "-"),
                                                )
                                              ],
                                            ),
                                            ButtonBar(
                                              alignment:
                                                  MainAxisAlignment.center,
                                              overflowDirection:
                                                  VerticalDirection.down,
                                              overflowButtonSpacing: 5,
                                              children: [
                                                ElevatedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.green),
                                                  ),
                                                  onPressed: () async {
                                                    controller
                                                        .createWorkOrder(index);
                                                  },
                                                  child: Text(
                                                      "Create Work Order".tr),
                                                ),
                                              ],
                                            )
                                            /* Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.mail,
                                                    color: Colors.white,
                                                  ),
                                                  tooltip: 'EMail',
                                                  onPressed: () {
                                                    if (controller
                                                            .trx
                                                            .records![
                                                                index]
                                                            .eMail ==
                                                        null) {
                                                      log("mail button pressed");
                                                    } else {
                                                      controller.writeMailTo(
                                                          controller
                                                              .trx
                                                              .records![
                                                                  index]
                                                              .eMail
                                                              .toString());
                                                    }
                                                  },
                                                ),
                                                Text(controller
                                                        .trx
                                                        .windowrecords![index]
                                                        .eMail ??
                                                    ""),
                                              ],
                                            ), */
                                            /*  Row(
                                              children: [
                                                Text(
                                                  "SalesRep".tr,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(controller
                                                        .trx
                                                        .windowrecords![index]
                                                        .salesRepID
                                                        ?.identifier ??
                                                    ""),
                                              ],
                                            ), */
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
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
                const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
                _buildHeader(
                    onPressedMenu: () => Scaffold.of(context).openDrawer()),
                const SizedBox(height: kSpacing / 2),
                const Divider(),
                _buildProfile(data: controller.getProfil()),
                const SizedBox(height: kSpacing),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: Obx(() => controller.dataAvailable
                          ? Text(
                              "${"Plant Maint.".tr}: ${controller._trx.records!.length}")
                          : Text("${"Plant Maint.".tr}: ")),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: IconButton(
                        onPressed: () {
                          //Get.to(const CreateLead());
                          Get.toNamed("/MaintenanceMpContractsCreateContract");
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.lightBlue,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: IconButton(
                        onPressed: () {
                          controller.syncMaintain();
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: Obx(
                        () => TextButton(
                          onPressed: () {
                            controller.changeFilter();
                            //print("hello");
                          },
                          child: Text(controller.value.value),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      //padding: const EdgeInsets.all(10),
                      //width: 20,
                      /* decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ), */
                      child: Obx(
                        () => DropdownButton(
                          icon: const Icon(Icons.filter_alt_sharp),
                          value: controller.dropdownValue.value,
                          elevation: 16,
                          onChanged: (String? newValue) {
                            controller.dropdownValue.value = newValue!;

                            //print(dropdownValue);
                          },
                          items: controller.dropDownList.map((list) {
                            return DropdownMenuItem<String>(
                              value: list.id,
                              child: Text(
                                list.name.toString(),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: TextField(
                          controller: controller.searchFieldController,
                          onSubmitted: (String? value) {
                            controller.searchFilterValue.value =
                                controller.searchFieldController.text;
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search_outlined),
                            border: const OutlineInputBorder(),
                            //labelText: 'Product Value',
                            hintText: 'Search'.tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kSpacing),
                Obx(
                  () => controller.dataAvailable
                      ? ListView.builder(
                          primary: false,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: controller._trx.records!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Obx(
                              () => Visibility(
                                visible: controller.searchFilterValue.value ==
                                        ""
                                    ? true
                                    : controller.dropdownValue.value == "1"
                                        ? controller._trx.records![index]
                                            .cBPartnerID!.identifier
                                            .toString()
                                            .toLowerCase()
                                            .contains(controller
                                                .searchFilterValue.value
                                                .toLowerCase())
                                        : controller.dropdownValue.value == "2"
                                            ? controller
                                                ._trx.records![index].documentNo
                                                .toString()
                                                .toLowerCase()
                                                .contains(controller
                                                    .searchFilterValue.value
                                                    .toLowerCase())
                                            : controller.dropdownValue.value ==
                                                    "3"
                                                ? controller
                                                    ._trx.records![index].phone
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains(
                                                        controller.searchFilterValue.value.toLowerCase())
                                                : controller.dropdownValue.value == "4" && controller.trx.records![index].cSalesRegionID != null
                                                    ? controller._trx.records![index].cSalesRegionID!.identifier.toString().toLowerCase().contains(controller.searchFilterValue.value.toLowerCase())
                                                    : true,
                                child: Card(
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
                                        padding:
                                            const EdgeInsets.only(right: 12.0),
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
                                          tooltip: 'Edit Lead'.tr,
                                          onPressed: () {
                                            Get.to(
                                                const EditMaintenanceMpContracts(),
                                                arguments: {
                                                  "maintainId": controller
                                                      ._trx.records![index].id,
                                                  "businesspartnerId":
                                                      controller
                                                          ._trx
                                                          .records![index]
                                                          .cBPartnerID
                                                          ?.id,
                                                  "businesspartnerName":
                                                      controller
                                                          ._trx
                                                          .records![index]
                                                          .cBPartnerID
                                                          ?.identifier,
                                                  "date": controller
                                                      ._trx
                                                      .records![index]
                                                      .dateNextRun,
                                                  "technicianId": controller
                                                      ._trx
                                                      .records![index]
                                                      .adUserID
                                                      ?.id,
                                                  "technicianName": controller
                                                      ._trx
                                                      .records![index]
                                                      .adUserID
                                                      ?.identifier,
                                                  "help": controller
                                                      ._trx
                                                      .records![index]
                                                      .litMpMaintainHelp,
                                                });
                                            //log("info button pressed");
                                            /*   Get.to(const EditLead(),
                                                arguments: {
                                                  "id": controller.trx
                                                      .windowrecords![index].id,
                                                  "name": controller
                                                          .trx
                                                          .windowrecords![index]
                                                          .name ??
                                                      "",
                                                  "leadStatus": controller
                                                          .trx
                                                          .windowrecords![index]
                                                          .leadStatus
                                                          ?.id ??
                                                      "",
                                                  "bpName": controller
                                                      .trx
                                                      .windowrecords![index]
                                                      .bPName,
                                                  "Tel": controller
                                                          .trx
                                                          .windowrecords![index]
                                                          .phone ??
                                                      "",
                                                  "eMail": controller
                                                          .trx
                                                          .windowrecords![index]
                                                          .eMail ??
                                                      "",
                                                  "salesRep": controller
                                                          .trx
                                                          .windowrecords![index]
                                                          .salesRepID
                                                          ?.identifier ??
                                                      ""
                                                }); */
                                          },
                                        ),
                                      ),
                                      title: Text(
                                        controller._trx.records![index]
                                                .cBPartnerID!.identifier ??
                                            "???",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                      subtitle: Row(
                                        children: <Widget>[
                                          const Icon(EvaIcons.hashOutline,
                                              color: Colors.yellowAccent),
                                          Text(
                                            controller._trx.records![index]
                                                    .documentNo ??
                                                "??",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        tooltip: 'Zoom Work Order',
                                        onPressed: () {
                                          if (controller._trx.records![index]
                                                  .latestWorkOrderId !=
                                              null) {
                                            if (int.parse(list[24], radix: 16)
                                                    .toRadixString(2)
                                                    .padLeft(4, "0")
                                                    .toString()[1] ==
                                                "1") {
                                              Get.offNamed('/MaintenanceMptask',
                                                  arguments: {
                                                    'notificationId': controller
                                                        ._trx
                                                        .records![index]
                                                        .latestWorkOrderId
                                                  });
                                            } else if (int.parse(list[31],
                                                        radix: 16)
                                                    .toRadixString(2)
                                                    .padLeft(4, "0")
                                                    .toString()[1] ==
                                                "1") {
                                              Get.offNamed(
                                                  '/MaintenanceMptaskStandard',
                                                  arguments: {
                                                    'notificationId': controller
                                                        ._trx
                                                        .records![index]
                                                        .latestWorkOrderId
                                                  });
                                            }
                                          }
                                        },
                                        icon: Icon(
                                          controller._trx.records![index]
                                                      .latestWorkOrderId !=
                                                  null
                                              ? Icons.search
                                              : Icons.search_off,
                                          color: controller._trx.records![index]
                                                      .latestWorkOrderId ==
                                                  null
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                      ),
                                      childrenPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 10.0),
                                      children: [
                                        Column(
                                          children: [
                                            /* Row(
                                              children: [
                                                const Text(
                                                  "Address: ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(controller
                                                          .trx
                                                          .records![index]
                                                          .cbPartnerLocationID
                                                          ?.identifier ??
                                                      ""),
                                                ),
                                              ],
                                            ), */
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.call,
                                                    color: Colors.green,
                                                  ),
                                                  tooltip: 'Call',
                                                  onPressed: () {
                                                    //log("info button pressed");
                                                    if (controller
                                                            ._trx
                                                            .records![index]
                                                            .phone ==
                                                        null) {
                                                      log("info button pressed");
                                                    } else {
                                                      controller.makePhoneCall(
                                                          controller
                                                              ._trx
                                                              .records![index]
                                                              .phone
                                                              .toString());
                                                    }
                                                  },
                                                ),
                                                Text(controller
                                                        ._trx
                                                        .records![index]
                                                        .phone ??
                                                    ""),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "${'Note Plant'.tr}: ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(controller
                                                          ._trx
                                                          .records![index]
                                                          .litMpMaintainHelp ??
                                                      ""),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                /* const Text(
                                              "BPartner: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ), */
                                                Icon(Icons.location_pin,
                                                    color: Colors.red.shade700),
                                                Expanded(
                                                  child: Text(
                                                      "${controller._trx.records![index].cLocationAddress1}, ${controller.trx.records![index].cLocationPostal} ${controller.trx.records![index].cLocationCity}"),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "${"Team".tr}:  ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(controller
                                                          ._trx
                                                          .records![index]
                                                          .team ??
                                                      ""),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "${"Selling Area".tr}:  ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(controller
                                                          ._trx
                                                          .records![index]
                                                          .cSalesRegionID
                                                          ?.identifier ??
                                                      ""),
                                                )
                                              ],
                                            ),
                                            /* Row(
                                              children: [
                                                Text(
                                                  "${"Contract Type".tr}:  ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(controller.trx.records![index].lit),
                                                )
                                              ],
                                            ), */
                                            Row(
                                              children: [
                                                Text(
                                                  "${"Date Next Run".tr}:  ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(controller
                                                              ._trx
                                                              .records![index]
                                                              .dateNextRun !=
                                                          null
                                                      ? DateFormat('dd-MM-yyyy')
                                                          .format(DateTime
                                                              .parse(controller
                                                                  ._trx
                                                                  .records![
                                                                      index]
                                                                  .dateNextRun!))
                                                      : "-"),
                                                )
                                              ],
                                            ),
                                            Visibility(
                                              visible: controller
                                                      ._trx
                                                      .records![index]
                                                      .latestWorkOrderDocNo !=
                                                  null,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "${"N° WO".tr}:  ",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Expanded(
                                                    child: Text(controller
                                                            ._trx
                                                            .records![index]
                                                            .latestWorkOrderDocNo ??
                                                        ""),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Visibility(
                                              visible: controller
                                                      ._trx
                                                      .records![index]
                                                      .cContractID
                                                      ?.id !=
                                                  null,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "${"Contract".tr}:  ",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Expanded(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        Get.offNamed(
                                                            '/Contract',
                                                            arguments: {
                                                              'notificationId':
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .cContractID
                                                                      ?.id,
                                                            });
                                                      },
                                                      child: Text(
                                                        '${controller._trx.records![index].cContractID?.identifier}',
                                                        style: const TextStyle(
                                                            color: kNotifColor),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "${"Latest Work Order".tr}:  ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(controller
                                                              .trx
                                                              .records![index]
                                                              .latestWorkOrder !=
                                                          null
                                                      ? DateFormat('dd-MM-yyyy')
                                                          .format(DateTime
                                                              .parse(controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .latestWorkOrder!))
                                                      : "-"),
                                                )
                                              ],
                                            ),
                                            ButtonBar(
                                              alignment:
                                                  MainAxisAlignment.center,
                                              overflowDirection:
                                                  VerticalDirection.down,
                                              overflowButtonSpacing: 5,
                                              children: [
                                                ElevatedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.green),
                                                  ),
                                                  onPressed: () async {
                                                    controller
                                                        .createWorkOrder(index);
                                                  },
                                                  child: Text(
                                                      "Create Work Order".tr),
                                                ),
                                              ],
                                            )
                                            /* Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.mail,
                                                    color: Colors.white,
                                                  ),
                                                  tooltip: 'EMail',
                                                  onPressed: () {
                                                    if (controller
                                                            .trx
                                                            .records![
                                                                index]
                                                            .eMail ==
                                                        null) {
                                                      log("mail button pressed");
                                                    } else {
                                                      controller.writeMailTo(
                                                          controller
                                                              .trx
                                                              .records![
                                                                  index]
                                                              .eMail
                                                              .toString());
                                                    }
                                                  },
                                                ),
                                                Text(controller
                                                        .trx
                                                        .windowrecords![index]
                                                        .eMail ??
                                                    ""),
                                              ],
                                            ), */
                                            /*  Row(
                                              children: [
                                                Text(
                                                  "SalesRep".tr,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(controller
                                                        .trx
                                                        .windowrecords![index]
                                                        .salesRepID
                                                        ?.identifier ??
                                                    ""),
                                              ],
                                            ), */
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
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
                const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
                _buildHeader(
                    onPressedMenu: () => Scaffold.of(context).openDrawer()),
                const SizedBox(height: kSpacing / 2),
                const Divider(),
                _buildProfile(data: controller.getProfil()),
                const SizedBox(height: kSpacing),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: Obx(() => controller.dataAvailable
                          ? Text(
                              "${"Plant Maint.".tr}: ${controller._trx.records!.length}")
                          : Text("${"Plant Maint.".tr}: ")),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: IconButton(
                        onPressed: () {
                          //Get.to(const CreateLead());
                          Get.toNamed("/MaintenanceMpContractsCreateContract");
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.lightBlue,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: IconButton(
                        onPressed: () {
                          controller.syncMaintain();
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: Obx(
                        () => TextButton(
                          onPressed: () {
                            controller.changeFilter();
                            //print("hello");
                          },
                          child: Text(controller.value.value),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      //padding: const EdgeInsets.all(10),
                      //width: 20,
                      /* decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ), */
                      child: Obx(
                        () => DropdownButton(
                          icon: const Icon(Icons.filter_alt_sharp),
                          value: controller.dropdownValue.value,
                          elevation: 16,
                          onChanged: (String? newValue) {
                            controller.dropdownValue.value = newValue!;

                            //print(dropdownValue);
                          },
                          items: controller.dropDownList.map((list) {
                            return DropdownMenuItem<String>(
                              value: list.id,
                              child: Text(
                                list.name.toString(),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: TextField(
                          controller: controller.searchFieldController,
                          onSubmitted: (String? value) {
                            controller.searchFilterValue.value =
                                controller.searchFieldController.text;
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search_outlined),
                            border: const OutlineInputBorder(),
                            //labelText: 'Product Value',
                            hintText: 'Search'.tr,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kSpacing),
                Obx(
                  () => controller.dataAvailable
                      ? ListView.builder(
                          primary: false,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: controller._trx.records!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Obx(
                              () => Visibility(
                                visible: controller.searchFilterValue.value ==
                                        ""
                                    ? true
                                    : controller.dropdownValue.value == "1"
                                        ? controller._trx.records![index]
                                            .cBPartnerID!.identifier
                                            .toString()
                                            .toLowerCase()
                                            .contains(controller
                                                .searchFilterValue.value
                                                .toLowerCase())
                                        : controller.dropdownValue.value == "2"
                                            ? controller
                                                ._trx.records![index].documentNo
                                                .toString()
                                                .toLowerCase()
                                                .contains(controller
                                                    .searchFilterValue.value
                                                    .toLowerCase())
                                            : controller.dropdownValue.value ==
                                                    "3"
                                                ? controller
                                                    ._trx.records![index].phone
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains(
                                                        controller.searchFilterValue.value.toLowerCase())
                                                : controller.dropdownValue.value == "4" && controller.trx.records![index].cSalesRegionID != null
                                                    ? controller._trx.records![index].cSalesRegionID!.identifier.toString().toLowerCase().contains(controller.searchFilterValue.value.toLowerCase())
                                                    : true,
                                child: Card(
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
                                        padding:
                                            const EdgeInsets.only(right: 12.0),
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
                                          tooltip: 'Edit Lead'.tr,
                                          onPressed: () {
                                            Get.to(
                                                const EditMaintenanceMpContracts(),
                                                arguments: {
                                                  "maintainId": controller
                                                      ._trx.records![index].id,
                                                  "businesspartnerId":
                                                      controller
                                                          ._trx
                                                          .records![index]
                                                          .cBPartnerID
                                                          ?.id,
                                                  "businesspartnerName":
                                                      controller
                                                          ._trx
                                                          .records![index]
                                                          .cBPartnerID
                                                          ?.identifier,
                                                  "date": controller
                                                      ._trx
                                                      .records![index]
                                                      .dateNextRun,
                                                  "technicianId": controller
                                                      ._trx
                                                      .records![index]
                                                      .adUserID
                                                      ?.id,
                                                  "technicianName": controller
                                                      ._trx
                                                      .records![index]
                                                      .adUserID
                                                      ?.identifier,
                                                  "help": controller
                                                      ._trx
                                                      .records![index]
                                                      .litMpMaintainHelp,
                                                });
                                            //log("info button pressed");
                                            /*   Get.to(const EditLead(),
                                                arguments: {
                                                  "id": controller.trx
                                                      .windowrecords![index].id,
                                                  "name": controller
                                                          .trx
                                                          .windowrecords![index]
                                                          .name ??
                                                      "",
                                                  "leadStatus": controller
                                                          .trx
                                                          .windowrecords![index]
                                                          .leadStatus
                                                          ?.id ??
                                                      "",
                                                  "bpName": controller
                                                      .trx
                                                      .windowrecords![index]
                                                      .bPName,
                                                  "Tel": controller
                                                          .trx
                                                          .windowrecords![index]
                                                          .phone ??
                                                      "",
                                                  "eMail": controller
                                                          .trx
                                                          .windowrecords![index]
                                                          .eMail ??
                                                      "",
                                                  "salesRep": controller
                                                          .trx
                                                          .windowrecords![index]
                                                          .salesRepID
                                                          ?.identifier ??
                                                      ""
                                                }); */
                                          },
                                        ),
                                      ),
                                      title: Text(
                                        controller._trx.records![index]
                                                .cBPartnerID!.identifier ??
                                            "???",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                      subtitle: Row(
                                        children: <Widget>[
                                          const Icon(EvaIcons.hashOutline,
                                              color: Colors.yellowAccent),
                                          Text(
                                            controller._trx.records![index]
                                                    .documentNo ??
                                                "??",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        tooltip: 'Zoom Work Order',
                                        onPressed: () {
                                          if (controller._trx.records![index]
                                                  .latestWorkOrderId !=
                                              null) {
                                            if (int.parse(list[24], radix: 16)
                                                    .toRadixString(2)
                                                    .padLeft(4, "0")
                                                    .toString()[1] ==
                                                "1") {
                                              Get.offNamed('/MaintenanceMptask',
                                                  arguments: {
                                                    'notificationId': controller
                                                        ._trx
                                                        .records![index]
                                                        .latestWorkOrderId
                                                  });
                                            } else if (int.parse(list[31],
                                                        radix: 16)
                                                    .toRadixString(2)
                                                    .padLeft(4, "0")
                                                    .toString()[1] ==
                                                "1") {
                                              Get.offNamed(
                                                  '/MaintenanceMptaskStandard',
                                                  arguments: {
                                                    'notificationId': controller
                                                        ._trx
                                                        .records![index]
                                                        .latestWorkOrderId
                                                  });
                                            }
                                          }
                                        },
                                        icon: Icon(
                                          controller._trx.records![index]
                                                      .latestWorkOrderId !=
                                                  null
                                              ? Icons.search
                                              : Icons.search_off,
                                          color: controller._trx.records![index]
                                                      .latestWorkOrderId ==
                                                  null
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                      ),
                                      childrenPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 10.0),
                                      children: [
                                        Column(
                                          children: [
                                            /* Row(
                                              children: [
                                                const Text(
                                                  "Address: ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(controller
                                                          .trx
                                                          .records![index]
                                                          .cbPartnerLocationID
                                                          ?.identifier ??
                                                      ""),
                                                ),
                                              ],
                                            ), */
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.call,
                                                    color: Colors.green,
                                                  ),
                                                  tooltip: 'Call',
                                                  onPressed: () {
                                                    //log("info button pressed");
                                                    if (controller
                                                            ._trx
                                                            .records![index]
                                                            .phone ==
                                                        null) {
                                                      log("info button pressed");
                                                    } else {
                                                      controller.makePhoneCall(
                                                          controller
                                                              ._trx
                                                              .records![index]
                                                              .phone
                                                              .toString());
                                                    }
                                                  },
                                                ),
                                                Text(controller
                                                        ._trx
                                                        .records![index]
                                                        .phone ??
                                                    ""),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "${'Note Plant'.tr}: ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(controller
                                                          ._trx
                                                          .records![index]
                                                          .litMpMaintainHelp ??
                                                      ""),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                /* const Text(
                                              "BPartner: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ), */
                                                Icon(Icons.location_pin,
                                                    color: Colors.red.shade700),
                                                Expanded(
                                                  child: Text(
                                                      "${controller._trx.records![index].cLocationAddress1}, ${controller.trx.records![index].cLocationPostal} ${controller.trx.records![index].cLocationCity}"),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "${"Team".tr}:  ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(controller
                                                          ._trx
                                                          .records![index]
                                                          .team ??
                                                      ""),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "${"Selling Area".tr}:  ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(controller
                                                          ._trx
                                                          .records![index]
                                                          .cSalesRegionID
                                                          ?.identifier ??
                                                      ""),
                                                )
                                              ],
                                            ),
                                            /* Row(
                                              children: [
                                                Text(
                                                  "${"Contract Type".tr}:  ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(controller.trx.records![index].lit),
                                                )
                                              ],
                                            ), */
                                            Row(
                                              children: [
                                                Text(
                                                  "${"Date Next Run".tr}:  ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(controller
                                                              ._trx
                                                              .records![index]
                                                              .dateNextRun !=
                                                          null
                                                      ? DateFormat('dd-MM-yyyy')
                                                          .format(DateTime
                                                              .parse(controller
                                                                  ._trx
                                                                  .records![
                                                                      index]
                                                                  .dateNextRun!))
                                                      : "-"),
                                                )
                                              ],
                                            ),
                                            Visibility(
                                              visible: controller
                                                      ._trx
                                                      .records![index]
                                                      .latestWorkOrderDocNo !=
                                                  null,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "${"N° WO".tr}:  ",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Expanded(
                                                    child: Text(controller
                                                            ._trx
                                                            .records![index]
                                                            .latestWorkOrderDocNo ??
                                                        ""),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Visibility(
                                              visible: controller
                                                      ._trx
                                                      .records![index]
                                                      .cContractID
                                                      ?.id !=
                                                  null,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "${"Contract".tr}:  ",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Expanded(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        Get.offNamed(
                                                            '/Contract',
                                                            arguments: {
                                                              'notificationId':
                                                                  controller
                                                                      ._trx
                                                                      .records![
                                                                          index]
                                                                      .cContractID
                                                                      ?.id,
                                                            });
                                                      },
                                                      child: Text(
                                                        '${controller._trx.records![index].cContractID?.identifier}',
                                                        style: const TextStyle(
                                                            color: kNotifColor),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "${"Latest Work Order".tr}:  ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(controller
                                                              .trx
                                                              .records![index]
                                                              .latestWorkOrder !=
                                                          null
                                                      ? DateFormat('dd-MM-yyyy')
                                                          .format(DateTime
                                                              .parse(controller
                                                                  .trx
                                                                  .records![
                                                                      index]
                                                                  .latestWorkOrder!))
                                                      : "-"),
                                                )
                                              ],
                                            ),
                                            ButtonBar(
                                              alignment:
                                                  MainAxisAlignment.center,
                                              overflowDirection:
                                                  VerticalDirection.down,
                                              overflowButtonSpacing: 5,
                                              children: [
                                                ElevatedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.green),
                                                  ),
                                                  onPressed: () async {
                                                    controller
                                                        .createWorkOrder(index);
                                                  },
                                                  child: Text(
                                                      "Create Work Order".tr),
                                                ),
                                              ],
                                            )
                                            /* Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.mail,
                                                    color: Colors.white,
                                                  ),
                                                  tooltip: 'EMail',
                                                  onPressed: () {
                                                    if (controller
                                                            .trx
                                                            .records![
                                                                index]
                                                            .eMail ==
                                                        null) {
                                                      log("mail button pressed");
                                                    } else {
                                                      controller.writeMailTo(
                                                          controller
                                                              .trx
                                                              .records![
                                                                  index]
                                                              .eMail
                                                              .toString());
                                                    }
                                                  },
                                                ),
                                                Text(controller
                                                        .trx
                                                        .windowrecords![index]
                                                        .eMail ??
                                                    ""),
                                              ],
                                            ), */
                                            /*  Row(
                                              children: [
                                                Text(
                                                  "SalesRep".tr,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(controller
                                                        .trx
                                                        .windowrecords![index]
                                                        .salesRepID
                                                        ?.identifier ??
                                                    ""),
                                              ],
                                            ), */
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
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
