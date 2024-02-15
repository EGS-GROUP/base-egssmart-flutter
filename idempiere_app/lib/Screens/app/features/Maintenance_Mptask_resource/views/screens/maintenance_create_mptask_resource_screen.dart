// ignore_for_file: prefer_typing_uninitialized_variables, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'dart:io';
//import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/leadstatus.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/models/businesspartner_json.dart';

import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/product_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/reflist_resource_type_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/resource_type_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/workorder_resource_local_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/models/workorder_resource_survey_lines_json.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/views/screens/maintenance_mptask_resource_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource_barcode/views/screens/maintenance_mptask_resource_barcode_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/constants.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class CreateMaintenanceMpResource extends StatefulWidget {
  const CreateMaintenanceMpResource({Key? key}) : super(key: key);

  @override
  State<CreateMaintenanceMpResource> createState() =>
      _CreateMaintenanceMpResourceState();
}

class _CreateMaintenanceMpResourceState
    extends State<CreateMaintenanceMpResource> {
  openResourceType() async {
    var dropDownValue = "A1";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/reflistresourcetypecategory.json');

    var _tt =
        RefListResourceTypeJson.fromJson(jsonDecode(file.readAsStringSync()));
    Get.defaultDialog(
      title: "Resource Type",
      //middleText: "Choose the type of Ticket you want to create",
      //contentPadding: const EdgeInsets.all(2.0),
      content: DropdownButton(
        value: dropDownValue,
        style: const TextStyle(fontSize: 12.0),
        elevation: 16,
        onChanged: (String? newValue) async {
          dropDownValue = newValue!;
          Get.back();
          const filename = "reflistresourcetype";
          final file = File(
              '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
          Get.to(const CreateMaintenanceMpResource(), arguments: {
            "id": dropDownValue,
            "reflistresourcetype": file,
          });
        },
        items: _tt.records!.map((list) {
          return DropdownMenuItem<String>(
            value: list.value,
            child: Text(
              list.name.toString(),
            ),
          );
        }).toList(),
      ),
      barrierDismissible: true,
      /* textCancel: "Cancel",
        textConfirm: "Confirm",
        onConfirm: () {
          Get.back();
          Get.to(const CreateTicketClientTicket(),
              arguments: {"id": dropdownValue});
        } */
    );
  }

  Future<void> syncWorkOrder() async {
    String ip = GetStorage().read('ip');
    var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mp_ot_v?\$filter= mp_ot_ad_user_id eq $userId');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      const filename = "workorder";
      final file = File(
          '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
      file.writeAsString(response.body);
      //GetStorage().write('workOrderSync', response.body);
      syncWorkOrderResource();
    }
  }

  /* Future<void> syncWorkOrderResource() async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://' + ip + '/api/v1/models/lit_mp_maintain_resource_v');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      GetStorage().write('workOrderResourceSync', response.body);
      //syncWorkOrderResourceSurveyLines();
      syncWorkOrderRefListResource();
    }
  } */

  Future<void> syncWorkOrderResource() async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url =
        Uri.parse('$protocol://$ip/api/v1/models/lit_mp_maintain_resource_v');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var json = WorkOrderResourceLocalJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      if (json.pagecount! > 1) {
        int index = 1;
        syncWorkOrderResourcePages(json, index);
      } else {
        const filename = "workorderresource";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(utf8.decode(response.bodyBytes));
        //productSync = false;

        //checkSyncData();
      }
      syncWorkOrderRefListResource();
    }
  }

  syncWorkOrderResourcePages(WorkOrderResourceLocalJson json, int index) async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mp_maintain_resource_v?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}&\$skip=${(index * 100)}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      index += 1;
      var pageJson = WorkOrderResourceLocalJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      for (var element in pageJson.records!) {
        json.records!.add(element);
      }

      if (json.pagecount! > index) {
        syncWorkOrderResourcePages(json, index);
      } else {
        const filename = "workorderresource";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(jsonEncode(json.toJson()));
        //workOrderSync = false;
        if (kDebugMode) {
          print('WorkOrderResource Checked');
        }
        //checkSyncData();
        syncWorkOrderRefListResource();
      }
    }
  }

  Future<void> syncWorkOrderRefListResource() async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/AD_Reference?\$filter= Name eq \'LIT_ResourceType\'');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);

      var json = jsonDecode(response.body);
      var id = json["records"][0]["id"];
      var url2 = Uri.parse(
          '$protocol://$ip/api/v1/models/AD_Ref_List?\$filter= AD_Reference_ID eq $id');

      var response2 = await http.get(
        url2,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );

      if (response2.statusCode == 200) {
        //print(response2.body);
        const filename = "reflistresourcetype";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsStringSync(response2.body);
        //GetStorage().write('refListResourceType', response2.body);
        syncWorkOrderRefListResourceCategory();
        /* var json = jsonDecode(response.body);
      var id = json["records"][0]["id"]; */
      } else {
        if (kDebugMode) {
          print(response2.body);
        }
      }
    } else {
      //print(response.body);
    }
  }

  Future<void> syncWorkOrderRefListResourceCategory() async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/AD_Reference?\$filter= Name eq \'C_BP_EDI EDI Type\'');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);

      var json = jsonDecode(response.body);
      var id = json["records"][0]["id"];
      var url2 = Uri.parse(
          '$protocol://$ip/api/v1/models/AD_Ref_List?\$filter= AD_Reference_ID eq $id');

      var response2 = await http.get(
        url2,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );

      if (response2.statusCode == 200) {
        //print(response2.body);
        const filename = "reflistresourcetypecategory";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsStringSync(response2.body);
        //GetStorage().write('refListResourceTypeCategory', response2.body);
        syncWorkOrderResourceSurveyLines();
        /* var json = jsonDecode(response.body);
      var id = json["records"][0]["id"]; */
      } else {
        if (kDebugMode) {
          print(response2.body);
        }
      }
    } else {
      //print(response.body); &\$orderby=
    }
  }

  /* Future<void> syncWorkOrderResourceSurveyLines() async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/mp_resource_survey_line?\$orderby= LineNo asc');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      const filename = "workorderresourcesurveylines";
      final file = File(
          '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
      //GetStorage().write('workOrderResourceSurveyLinesSync', response.body);
      file.writeAsStringSync(response.body);
      Get.find<MaintenanceMpResourceController>().getWorkOrders();
      Get.snackbar(
        "Done!".tr,
        "The record has been created".tr,
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
    }
  } */
  Future<void> syncWorkOrderResourceSurveyLines() async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/mp_resource_survey_line?\$orderby= LineNo asc');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var json = WorkOrderResourceSurveyLinesJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      if (json.pagecount! > 1) {
        int index = 1;
        syncWorkOrderResourceSurveyLinesPages(json, index);
      } else {
        const filename = "workorderresourcesurveylines";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(utf8.decode(response.bodyBytes));
        try {
          Get.find<MaintenanceMpResourceController>().getWorkOrders();
        } catch (e) {
          if (kDebugMode) {
            print("no page");
          }
        }
        try {
          Get.find<MaintenanceMpResourceBarcodeController>().getWorkOrders();
        } catch (e) {
          if (kDebugMode) {
            print("no page");
          }
        }
        Get.snackbar(
          "Done!".tr,
          "The record has been created".tr,
          icon: const Icon(
            Icons.done,
            color: Colors.green,
          ),
        );
      }
    }
  }

  syncWorkOrderResourceSurveyLinesPages(
      WorkOrderResourceSurveyLinesJson json, int index) async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/m_product?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}&\$skip=${(index * 100)}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      index += 1;
      var pageJson = WorkOrderResourceSurveyLinesJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      for (var element in pageJson.records!) {
        json.records!.add(element);
      }

      if (json.pagecount! > index) {
        syncWorkOrderResourceSurveyLinesPages(json, index);
      } else {
        if (kDebugMode) {
          print(json.records!.length);
        }
        const filename = "workorderresourcesurveylines";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsString(jsonEncode(json.toJson()));
        try {
          Get.find<MaintenanceMpResourceController>().getWorkOrders();
        } catch (e) {
          if (kDebugMode) {
            print("no page");
          }
        }
        try {
          Get.find<MaintenanceMpResourceBarcodeController>().getWorkOrders();
        } catch (e) {
          if (kDebugMode) {
            print("no page");
          }
        }
        Get.snackbar(
          "Done!".tr,
          "The record has been created".tr,
          icon: const Icon(
            Icons.done,
            color: Colors.green,
          ),
        );
      }
    }
  }

  createWorkOrderResource(bool isConnected) async {
    var inputFormat = DateFormat('dd/MM/yyyy');
    final protocol = GetStorage().read('protocol');
    //print(now);
    const filename = "workorderresource";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
    //print(GetStorage().read('selectedTaskId'));

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = {
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "MP_Maintain_ID": {
        "id": (args["propertyMaintain"] ?? false) && isPropertyMaintainId != "0"
            ? int.parse(isPropertyMaintainId)
            : GetStorage().read('selectedTaskDocNo')
      },
      "M_Product_ID": {"id": productId},
      "IsActive": true,
      "ResourceType": {"id": "BP"},
      "LIT_ResourceType": {"id": dropDownValue},
      "ResourceQty": 1,
      //"LIT_Control3DateFrom": date3,
      //"LIT_Control2DateFrom": date2,
      //"LIT_Control1DateFrom": date1,
      "Note": noteFieldController.text,
      "SerNo": sernoFieldController.text,
      "LocationComment": locationFieldController.text,
      //"Value": locationCodeFieldController.text,
      "Manufacturer": manufacturerFieldController.text,
      "ManufacturedYear": int.parse(manufacturedYearFieldController.text == ""
          ? "0"
          : manufacturedYearFieldController.text),
      "UseLifeYears": int.parse(useLifeYearsFieldController.text == ""
          ? "0"
          : useLifeYearsFieldController.text),
      "LIT_ProductModel": productModelFieldController.text,
      "Lot": lotFieldController.text,
      "DateOrdered": dateOrdered,
      "ServiceDate": firstUseDate,
      "UserName": userNameFieldController.text,
      "ProdCode": barcodeFieldController.text,
      "TextDetails": cartelFieldController.text,
      "V_Number": numberFieldController.text,
      "LineNo": int.parse(
          lineFieldController.text == "" ? "0" : lineFieldController.text),
      "Length": int.parse(
          lengthFieldController.text != "" ? lengthFieldController.text : "0"),
      "Width": int.parse(
          widthFieldController.text != "" ? widthFieldController.text : "0"),
      "WeightAmt": int.parse(weightAmtFieldController.text != ""
          ? weightAmtFieldController.text
          : "0"),
      "Height": int.parse(
          heightFieldController.text != "" ? heightFieldController.text : "0"),
      "Color": colorFieldController.text,
      "LIT_ResourceStatus": {
        "id": args["property"] == null || args["property"] == false
            ? "INS"
            : "NEW"
      },
      "IsOwned": isPropertyValue,
    };

    if (subCategoryDropDownValue != "") {
      msg.addAll({
        "LIT_M_Product_SubCategory_ID": {
          "id": int.parse(subCategoryDropDownValue)
        }
      });
    }

    if (cartelDropDownValue != "") {
      msg.addAll({
        "lit_cartel_format_ID": {"id": int.parse(cartelDropDownValue)}
      });
    }

    if (dateCheckFieldController.text != "") {
      try {
        var date1 = inputFormat.parse(dateCheckFieldController.text);

        msg.addAll(
            {"LIT_Control1DateFrom": DateFormat('yyyy-MM-dd').format(date1)});
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
    if (dateRevisionFieldController.text != "") {
      try {
        var date2 = inputFormat.parse(dateRevisionFieldController.text);

        msg.addAll(
            {"LIT_Control2DateFrom": DateFormat('yyyy-MM-dd').format(date2)});
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
    if (dateTestingFieldController.text != "") {
      try {
        var date3 = inputFormat.parse(dateTestingFieldController.text);

        msg.addAll(
            {"LIT_Control3DateFrom": DateFormat('yyyy-MM-dd').format(date3)});
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }

    if (dropdownValue3 != "") {
      msg.addAll({
        "lit_ResourceGroup_ID": {"id": int.parse(dropdownValue3)}
      });
    }
    final now = DateTime.now();
    final checkDate = inputFormat.parse(dateCheckFieldController.text);
    var revisionDate;
    try {
      revisionDate = inputFormat.parse(dateRevisionFieldController.text);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    var testDate;
    try {
      testDate = inputFormat.parse(dateTestingFieldController.text);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    final today = DateTime(now.year, now.month, now.day);

    if (DateTime(checkDate.year, checkDate.month, checkDate.day) == today) {
      msg.addAll({
        "AD_User_ID": {"id": GetStorage().read('userId')},
        "LIT_ResourceActivity": {"id": "CHK"},
      });
    }

    if (revisionDate != null) {
      if (DateTime(revisionDate.year, revisionDate.month, revisionDate.day) ==
          today) {
        msg.addAll({
          "AD_User_ID": {"id": GetStorage().read('userId')},
          "LIT_ResourceActivity": {"id": "REV"},
        });
      }
    }

    if (testDate != null) {
      if (DateTime(testDate.year, testDate.month, testDate.day) == today) {
        msg.addAll({
          "AD_User_ID": {"id": GetStorage().read('userId')},
          "LIT_ResourceActivity": {"id": "TST"},
        });
      }
    }

    if (testDate != null) {
      if (DateTime(testDate.year, testDate.month, testDate.day) == today &&
          int.parse(manufacturedYearFieldController.text == ""
                  ? "0"
                  : manufacturedYearFieldController.text) ==
              today.year) {
        msg.addAll({
          "AD_User_ID": {"id": GetStorage().read('userId')},
          "LIT_ResourceActivity": {"id": "CHK"},
        });
      }
    }

    WorkOrderResourceLocalJson trx = WorkOrderResourceLocalJson.fromJson(
        jsonDecode(file.readAsStringSync()));
    MProductID prod = MProductID(id: productId, identifier: productName);
    ResourceType res =
        ResourceType(id: "BP", identifier: "Parti Scheda Prodotto");

    EDIType edt = EDIType(id: args["id"]);
    RRecords record = RRecords(
        mProductID: prod,
        mpMaintainID: MPMaintainID(
            id: (args["propertyMaintain"] ?? false) &&
                    isPropertyMaintainId != "0"
                ? int.parse(isPropertyMaintainId)
                : GetStorage().read('selectedTaskDocNo')),
        //mpOtDocumentno: GetStorage().read('selectedTaskDocNo'),
        resourceType: res,
        resourceQty: 1,
        eDIType: edt,
        lITControl3DateFrom: date3,
        lITControl2DateFrom: date2,
        //lITControl1DateFrom: date1,
        note: noteFieldController.text,
        serNo: sernoFieldController.text,
        locationComment: locationFieldController.text,
        //value: locationCodeFieldController.text,
        manufacturer: manufacturerFieldController.text,
        manufacturedYear: int.parse(manufacturedYearFieldController.text == ""
            ? "0"
            : manufacturedYearFieldController.text),
        useLifeYears: int.parse(useLifeYearsFieldController.text == ""
            ? "0"
            : useLifeYearsFieldController.text),
        lITProductModel: productModelFieldController.text,
        number: numberFieldController.text,
        lineNo: int.parse(
            lineFieldController.text == "" ? "0" : lineFieldController.text),
        lot: lotFieldController.text,
        dateOrdered: dateOrdered,
        serviceDate: firstUseDate,
        userName: userNameFieldController.text,
        prodCode: barcodeFieldController.text,
        resourceStatus: ResourceStatus(id: "INS", identifier: "Installato"),
        length: int.parse(lengthFieldController.text != ""
            ? lengthFieldController.text
            : "0"),
        width: int.parse(
            widthFieldController.text != "" ? widthFieldController.text : "0"),
        weightAmt: int.parse(weightAmtFieldController.text != ""
            ? weightAmtFieldController.text
            : "0"),
        color: colorFieldController.text,
        textDetails: cartelFieldController.text,
        isOwned: isPropertyValue,
        toDoAction: "NEW",
        anomaliesCount: "0");

    if (cartelDropDownValue != "") {
      record.litCartelFormID =
          LitCartelFormID(id: int.parse(cartelDropDownValue));
    }

    if (subCategoryDropDownValue != "") {
      record.litmProductSubCategoryID =
          LITMProductSubCategoryID(id: int.parse(subCategoryDropDownValue));
    }

    if (dateCheckFieldController.text != "") {
      try {
        var date = inputFormat.parse(dateCheckFieldController.text);

        record.lITControl1DateFrom = DateFormat('yyyy-MM-dd').format(date);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
    if (dateRevisionFieldController.text != "") {
      try {
        var date = inputFormat.parse(dateRevisionFieldController.text);

        record.lITControl2DateFrom = DateFormat('yyyy-MM-dd').format(date);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }

    if (dateTestingFieldController.text != "") {
      try {
        var date = inputFormat.parse(dateTestingFieldController.text);

        record.lITControl3DateFrom = DateFormat('yyyy-MM-dd').format(date);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }

    if (dropdownValue3 != "") {
      record.litResourceGroupID =
          LitResourceGroupID(id: int.parse(dropdownValue3));
    }

    var url = Uri.parse(
        '$protocol://$ip/api/v1/windows/maintenance-item/tabs/${"maintenance".tr}/${GetStorage().read('selectedTaskDocNo')}/${"mp-resources".tr}');
    if (isConnected) {
      if (kDebugMode) {
        print(msg);
      }
      emptyAPICallStak();
      var response = await http.post(
        url,
        body: jsonEncode(msg),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );
      if (response.statusCode == 201) {
        //print("done!");
        if (kDebugMode) {
          print(response.body);
        }
        setState(() {
          saveFlag = false;
        });
        //syncWorkOrder();
        //print(response.body);
        RRecords rc = RRecords.fromJson(jsonDecode(response.body));
        rc.toDoAction = 'Nothing';
        rc.doneAction = 'NEW';
        rc.anomaliesCount = '0';
        rc.eDIType = edt;
        trx.records!.add(rc);
        trx.rowcount = trx.rowcount! + 1;
        var data = jsonEncode(trx.toJson());
        file.writeAsStringSync(data);
        try {
          Get.find<MaintenanceMpResourceController>().getWorkOrders();
          Get.find<MaintenanceMpResourceController>()
              .searchFieldController
              .text = barcodeFieldController.text;
          Get.find<MaintenanceMpResourceController>().searchFilterValue.value =
              barcodeFieldController.text;
        } catch (e) {
          if (kDebugMode) {
            print("no page");
          }
        }
        try {
          Get.find<MaintenanceMpResourceBarcodeController>().getWorkOrders();
        } catch (e) {
          if (kDebugMode) {
            print("no page");
          }
        }
        Get.snackbar(
          "Done!".tr,
          "The record has been created".tr,
          icon: const Icon(
            Icons.done,
            color: Colors.green,
          ),
        );
      } else {
        if (kDebugMode) {
          print(response.body);
        }
        Get.snackbar(
          "Error!".tr,
          "Record not created".tr,
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ),
        );
      }
    } else {
      record.offlineId = GetStorage().read('postCallId');
      List<dynamic> list = [];
      if (GetStorage().read('postCallList') == null) {
        var call = {
          "offlineid": GetStorage().read('postCallId'),
          "url":
              '$protocol://$ip/api/v1/windows/maintenance-item/tabs/${"maintenance".tr}/${GetStorage().read('selectedTaskDocNo')}/${"mp-resources".tr}',
          "AD_Org_ID": {"id": GetStorage().read("organizationid")},
          "AD_Client_ID": {"id": GetStorage().read("clientid")},
          "MP_Maintain_ID": {
            "id": (args["propertyMaintain"] ?? false) &&
                    isPropertyMaintainId != "0"
                ? int.parse(isPropertyMaintainId)
                : GetStorage().read('selectedTaskDocNo')
          },
          "M_Product_ID": {"id": productId},
          "IsActive": true,
          "ResourceType": {"id": "BP"},
          "LIT_ResourceType": {"id": dropDownValue},
          "ResourceQty": 1,
          "LIT_Control3DateFrom": date3,
          "LIT_Control2DateFrom": date2,
          "LIT_Control1DateFrom": date1,
          "Note": noteFieldController.text,
          "SerNo": sernoFieldController.text,
          "LocationComment": locationFieldController.text,
          //"Value": locationCodeFieldController.text,
          "Manufacturer": manufacturerFieldController.text,
          "ManufacturedYear": int.parse(
              manufacturedYearFieldController.text == ""
                  ? "0"
                  : manufacturedYearFieldController.text),
          "UseLifeYears": int.parse(useLifeYearsFieldController.text == ""
              ? "0"
              : useLifeYearsFieldController.text),
          "LIT_ProductModel": productModelFieldController.text,
          "Lot": lotFieldController.text,
          "DateOrdered": dateOrdered,
          "ServiceDate": firstUseDate,
          "UserName": userNameFieldController.text,
          "ProdCode": barcodeFieldController.text,
          "TextDetails": cartelFieldController.text,
          "V_Number": numberFieldController.text,
          "LineNo": int.parse(
              lineFieldController.text == "" ? "0" : lineFieldController.text),
          "LIT_ResourceStatus": {"id": "INS"},
          "Length": int.parse(lengthFieldController.text != ""
              ? lengthFieldController.text
              : "0"),
          "Width": int.parse(widthFieldController.text != ""
              ? widthFieldController.text
              : "0"),
          "WeightAmt": int.parse(weightAmtFieldController.text != ""
              ? weightAmtFieldController.text
              : "0"),
          "Height": int.parse(heightFieldController.text != ""
              ? heightFieldController.text
              : "0"),
          "Color": colorFieldController.text,
          "IsOwned": isPropertyValue,
        };

        if (subCategoryDropDownValue != "") {
          msg.addAll({
            "LIT_M_Product_SubCategory_ID": {
              "id": int.parse(subCategoryDropDownValue)
            }
          });
        }

        if (cartelDropDownValue != "") {
          call.addAll({
            "lit_cartel_format_ID": {"id": int.parse(cartelDropDownValue)}
          });
        }

        if (dateCheckFieldController.text != "") {
          try {
            var date = inputFormat.parse(dateCheckFieldController.text);

            call.addAll({
              "LIT_Control1DateFrom": DateFormat('yyyy-MM-dd').format(date)
            });
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
        }
        if (dateRevisionFieldController.text != "") {
          try {
            var date = inputFormat.parse(dateRevisionFieldController.text);

            call.addAll({
              "LIT_Control2DateFrom": DateFormat('yyyy-MM-dd').format(date)
            });
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
        }
        if (dateTestingFieldController.text != "") {
          try {
            var date = inputFormat.parse(dateTestingFieldController.text);

            call.addAll({
              "LIT_Control2DateFrom": DateFormat('yyyy-MM-dd').format(date)
            });
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
        }

        if (dropdownValue3 != "") {
          msg.addAll({
            "lit_ResourceGroup_ID": {"id": int.parse(dropdownValue3)}
          });
        }

        list.add(jsonEncode(call));
      } else {
        list = GetStorage().read('postCallList');
        var call = {
          "offlineid": GetStorage().read('postCallId'),
          "url":
              '$protocol://$ip/api/v1/windows/maintenance-item/tabs/${"maintenance".tr}/${GetStorage().read('selectedTaskDocNo')}/${"mp-resources".tr}',
          "AD_Org_ID": {"id": GetStorage().read("organizationid")},
          "AD_Client_ID": {"id": GetStorage().read("clientid")},
          "MP_Maintain_ID": {
            "id": (args["propertyMaintain"] ?? false) &&
                    isPropertyMaintainId != "0"
                ? int.parse(isPropertyMaintainId)
                : GetStorage().read('selectedTaskDocNo')
          },
          "M_Product_ID": {"id": productId},
          "IsActive": true,
          "ResourceType": {"id": "BP"},
          "LIT_ResourceType": {"id": dropDownValue},
          "ResourceQty": 1,
          "LIT_Control3DateFrom": date3,
          "LIT_Control2DateFrom": date2,
          //"LIT_Control1DateFrom": date1,
          "Note": noteFieldController.text,
          "SerNo": sernoFieldController.text,
          "LocationComment": locationFieldController.text,
          //"Value": locationCodeFieldController.text,
          "Manufacturer": manufacturerFieldController.text,
          "ManufacturedYear": int.parse(
              manufacturedYearFieldController.text == ""
                  ? "0"
                  : manufacturedYearFieldController.text),
          "UseLifeYears": int.parse(useLifeYearsFieldController.text == ""
              ? "0"
              : useLifeYearsFieldController.text),
          "LIT_ProductModel": productModelFieldController.text,
          "Lot": lotFieldController.text,
          "DateOrdered": dateOrdered,
          "ServiceDate": firstUseDate,
          "UserName": userNameFieldController.text,
          "ProdCode": barcodeFieldController.text,
          "TextDetails": cartelFieldController.text,
          "V_Number": numberFieldController.text,
          "LIT_ResourceStatus": {"id": "INS"},
          "LineNo": int.parse(
              lineFieldController.text == "" ? "0" : lineFieldController.text),
          "Length": int.parse(lengthFieldController.text != ""
              ? lengthFieldController.text
              : "0"),
          "Width": int.parse(widthFieldController.text != ""
              ? widthFieldController.text
              : "0"),
          "WeightAmt": int.parse(weightAmtFieldController.text != ""
              ? weightAmtFieldController.text
              : "0"),
          "Height": int.parse(heightFieldController.text != ""
              ? heightFieldController.text
              : "0"),
          "Color": colorFieldController.text,
          "IsOwned": isPropertyValue,
        };

        if (subCategoryDropDownValue != "") {
          call.addAll({
            "LIT_M_Product_SubCategory_ID": {
              "id": int.parse(subCategoryDropDownValue)
            }
          });
        }

        if (cartelDropDownValue != "") {
          call.addAll({
            "lit_cartel_format_ID": {"id": int.parse(cartelDropDownValue)}
          });
        }
        if (dateCheckFieldController.text != "") {
          try {
            var date = inputFormat.parse(dateCheckFieldController.text);

            call.addAll({
              "LIT_Control1DateFrom": DateFormat('yyyy-MM-dd').format(date)
            });
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
        }
        if (dateRevisionFieldController.text != "") {
          try {
            var date = inputFormat.parse(dateRevisionFieldController.text);

            call.addAll({
              "LIT_Control2DateFrom": DateFormat('yyyy-MM-dd').format(date)
            });
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
        }
        if (dateTestingFieldController.text != "") {
          try {
            var date = inputFormat.parse(dateTestingFieldController.text);

            call.addAll({
              "LIT_Control2DateFrom": DateFormat('yyyy-MM-dd').format(date)
            });
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
        }
        if (dropdownValue3 != "") {
          call.addAll({
            "lit_ResourceGroup_ID": {"id": int.parse(dropdownValue3)}
          });
        }

        list.add(jsonEncode(call));
      }
      GetStorage().write('postCallId', GetStorage().read('postCallId') + 1);
      GetStorage().write('postCallList', list);
      Get.snackbar(
        "Saved!".tr,
        "The record has been saved locally waiting for internet connection".tr,
        icon: const Icon(
          Icons.save,
          color: Colors.red,
        ),
      );
      trx.records!.add(record);
      trx.rowcount = trx.rowcount! + 1;
      var data = jsonEncode(trx.toJson());
      file.writeAsStringSync(data);
      try {
        Get.find<MaintenanceMpResourceController>().getWorkOrders();
        Get.find<MaintenanceMpResourceController>().searchFieldController.text =
            barcodeFieldController.text;
        Get.find<MaintenanceMpResourceController>().searchFilterValue.value =
            barcodeFieldController.text;
      } catch (e) {
        if (kDebugMode) {
          print("no page");
        }
      }
      try {
        Get.find<MaintenanceMpResourceBarcodeController>().getWorkOrders();
        Get.find<MaintenanceMpResourceController>().searchFieldController.text =
            barcodeFieldController.text;
        Get.find<MaintenanceMpResourceController>().searchFilterValue.value =
            barcodeFieldController.text;
      } catch (e) {
        if (kDebugMode) {
          print("no page");
        }
      }
      setState(() {
        saveFlag = false;
      });
    }
  }

  Future<List<Records>> getAllProducts() async {
    //print(response.body);
    const filename = "products";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

    var jsonResources =
        ProductJson.fromJson(jsonDecode(file.readAsStringSync()));

    jsonResources.records!.retainWhere((element) =>
        (element.mProductCategoryID?.identifier ?? "").contains(args["id"]));

    //print(jsonResources.records!.length);

    return jsonResources.records!;

    //print(list[0].eMail);

    //print(json.);
  }

  Future<List<Records>> getAllCartelFormats() async {
    const filename = "cartelformat";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

    var jsonResources =
        ProductJson.fromJson(jsonDecode(file.readAsStringSync()));

    return jsonResources.records!;
  }

  Future<List<Records>> getAllSubCategories() async {
    const filename = "resourcesubcategory";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

    var jsonResources =
        ProductJson.fromJson(jsonDecode(file.readAsStringSync()));

    return jsonResources.records!;
  }

  Future<List<RefRecords>> getResourceGroup() async {
    const filename = "listresourcegroup";
    final file2 = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

    var dJson =
        RefListResourceTypeJson.fromJson(jsonDecode(file2.readAsStringSync()));

    dJson.records!.retainWhere((element) =>
        element.mpMaintain3ID?.id == GetStorage().read('selectedTaskDocNo'));

    return dJson.records!;
  }

  Future<List<LSRecords>> getPropertyMaintains() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/mp_maintain?\$filter= contains(tolower(DocumentNo),\'sede\')');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      var json = LeadStatusJson.fromJson(jsonDecode(response.body));

      //print(json.rowcount);

      return json.records!;
    } else {
      throw Exception("Failed to load lead statuses");
    }

    //print(response.body);
  }

  /* void fillFields() {
    nameFieldController.text = args["name"];
    bPartnerFieldController.text = args["bpName"];
    phoneFieldController.text = args["Tel"];
    mailFieldController.text = args["eMail"];
    //dropdownValue = args["leadStatus"];
    salesrepValue = args["salesRep"];
    //salesRepFieldController.text = args["salesRep"];
  } */

  dynamic args = Get.arguments;
  var numberFieldController;
  var noteFieldController;
  var valueFieldController;
  var locationFieldController;
  var locationCodeFieldController;
  var sernoFieldController;
  var manufacturerFieldController;
  var manufacturedYearFieldController;
  var useLifeYearsFieldController;
  var productModelFieldController;
  var lotFieldController;
  var userNameFieldController;
  var barcodeFieldController;
  var cartelFieldController;
  var lineFieldController;
  var lengthFieldController;
  var widthFieldController;
  var weightAmtFieldController;
  var heightFieldController;
  var colorFieldController;
  late TextEditingController dateCheckFieldController;
  late TextEditingController dateRevisionFieldController;
  late TextEditingController dateTestingFieldController;
  String date3 = "";
  int dateCalc3 = 0;
  String date2 = "";
  int dateCalc2 = 0;
  String date1 = "";
  int dateCalc1 = 0;
  var productId;
  var productName;
  String cartelDropDownValue = "";
  String subCategoryDropDownValue = "";
  String dateOrdered = "";
  String firstUseDate = "";
  late ResourceTypeJson tt;
  late String dropDownValue;
  bool saveFlag = true;
  String dropdownValue3 = "";
  bool isPropertyValue = false;
  String isPropertyMaintainId = "0";
  late TextEditingController isPropertyMaintainFieldController;

  @override
  void initState() {
    super.initState();
    saveFlag = true;
    dropDownValue = "1.1.2";
    tt = ResourceTypeJson.fromJson(
        jsonDecode((args["reflistresourcetype"]).readAsStringSync()));
    noteFieldController = TextEditingController();
    valueFieldController = TextEditingController();
    locationFieldController = TextEditingController();
    locationCodeFieldController = TextEditingController();
    sernoFieldController = TextEditingController();
    manufacturerFieldController = TextEditingController();
    manufacturedYearFieldController = TextEditingController();
    useLifeYearsFieldController = TextEditingController();
    productModelFieldController = TextEditingController();
    lotFieldController = TextEditingController();
    userNameFieldController = TextEditingController();
    barcodeFieldController = TextEditingController();
    cartelFieldController = TextEditingController();
    numberFieldController = TextEditingController();
    lineFieldController = TextEditingController();
    lengthFieldController = TextEditingController(text: "0");
    widthFieldController = TextEditingController(text: "0");
    weightAmtFieldController = TextEditingController(text: "0");
    heightFieldController = TextEditingController(text: "0");
    colorFieldController = TextEditingController(text: "");
    dateCheckFieldController = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(DateTime.now()));
    dateRevisionFieldController = TextEditingController(
        text: (args["perm"])[16] == "N"
            ? ''
            : DateFormat('dd/MM/yyyy').format(DateTime.now()));
    dateTestingFieldController = TextEditingController(
        text: (args["perm"])[17] == "N"
            ? ''
            : DateFormat('dd/MM/yyyy').format(DateTime.now()));
    date3 = (args["perm"])[17] == "N"
        ? ''
        : (DateTime.now().toString()).substring(0, 10);
    dateCalc3 = 0;
    date2 = (args["perm"])[16] == "N"
        ? ''
        : (DateTime.now().toString()).substring(0, 10);
    dateCalc3 = 0;
    date1 = (DateTime.now().toString()).substring(0, 10);
    dateCalc3 = 0;
    productId = 0;
    productName = "";
    dateOrdered = "";
    firstUseDate = "";
    dropdownValue3 = "";
    cartelDropDownValue = "";
    subCategoryDropDownValue = "";
    isPropertyValue = args["property"] ?? false;
    isPropertyMaintainId = "0";
  }

  static String _displayStringForOption(Records option) =>
      "${option.value}_${option.name}";

  static int _setIdForOption(Records option) => option.id!;

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Add Resource'.tr),
        ),
        actions: [
          Visibility(
            visible: saveFlag == false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: IconButton(
                onPressed: () async {
                  Get.back();
                  try {
                    Get.find<MaintenanceMpResourceController>()
                        .openResourceType();
                  } catch (e) {
                    if (kDebugMode) {
                      print("no page");
                    }
                  }

                  try {
                    Get.find<MaintenanceMpResourceBarcodeController>()
                        .openResourceType();
                  } catch (e) {
                    if (kDebugMode) {
                      print("no page");
                    }
                  }
                },
                icon: const Icon(
                  Icons.add,
                ),
              ),
            ),
          ),
          Visibility(
            replacement: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: IconButton(
                onPressed: () async {
                  barcodeFieldController.text = "";
                  setState(() {
                    saveFlag = true;
                  });
                },
                icon: const Icon(
                  Icons.copy,
                ),
              ),
            ),
            visible: saveFlag,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: IconButton(
                onPressed: () async {
                  var isConnected = await checkConnection();
                  createWorkOrderResource(isConnected);
                },
                icon: const Icon(
                  Icons.save,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: (args["perm"])[0] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: numberFieldController,
                      onChanged: (value) {
                        if (int.tryParse(numberFieldController.text) != null) {
                          lineFieldController.text =
                              (int.parse(numberFieldController.text) * 10)
                                  .toString();
                        }
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'N°'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[1] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (string) {
                        setState(() {});
                      },
                      controller: lineFieldController,
                      decoration: InputDecoration(
                        prefixIconColor:
                            lineFieldController.text == "" ? Colors.red : null,
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Line N°'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Product".tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllProducts(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<Records>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<Records>(
                                initialValue: const TextEditingValue(text: ''),
                                displayStringForOption: _displayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<Records>.empty();
                                  }
                                  return snapshot.data!.where((Records option) {
                                    return "${option.value}_${option.name}"
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (Records selection) {
                                  setState(() {
                                    productId = _setIdForOption(selection);
                                    productName =
                                        _displayStringForOption(selection);
                                  });

                                  //print(salesrepValue);
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[3] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: noteFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Note'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[4] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: barcodeFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Barcode'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[5] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: sernoFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'SerNo'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[6] == "Y",
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Cartel".tr,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[6] == "Y",
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.all(10),
                    child: FutureBuilder(
                      future: getAllCartelFormats(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<Records>> snapshot) =>
                          snapshot.hasData
                              ? DropdownButton(
                                  hint: Text("Select a Cartel".tr),
                                  value: cartelDropDownValue == ""
                                      ? null
                                      : cartelDropDownValue,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      cartelDropDownValue = newValue!;
                                    });
                                    //print(dropdownValue);
                                  },
                                  items: snapshot.data!.map((list) {
                                    return DropdownMenuItem<String>(
                                      value: list.id.toString(),
                                      child: Text(
                                        list.name.toString(),
                                      ),
                                    );
                                  }).toList(),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[24] == "Y",
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Typology".tr,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[24] == "Y",
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.all(10),
                    child: FutureBuilder(
                      future: getAllSubCategories(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<Records>> snapshot) =>
                          snapshot.hasData
                              ? DropdownButton(
                                  hint: Text("Select a Typology".tr),
                                  value: subCategoryDropDownValue == ""
                                      ? null
                                      : subCategoryDropDownValue,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      subCategoryDropDownValue = newValue!;
                                    });
                                    //print(dropdownValue);
                                  },
                                  items: snapshot.data!.map((list) {
                                    return DropdownMenuItem<String>(
                                      value: list.id.toString(),
                                      child: Text(
                                        list.name.toString(),
                                      ),
                                    );
                                  }).toList(),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[7] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: productModelFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Product Model'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[8] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DateTimePicker(
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      type: DateTimePickerType.date,
                      initialValue: '',
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'Date Ordered'.tr,
                      icon: const Icon(Icons.event),
                      onChanged: (val) {
                        //print(DateTime.parse(val));
                        //print(val);
                        setState(() {
                          dateOrdered = val.substring(0, 10);
                        });
                        //print(date);
                      },
                      validator: (val) {
                        //print(val);
                        return null;
                      },
                      // ignore: avoid_print
                      onSaved: (val) => print(val),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[9] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DateTimePicker(
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      type: DateTimePickerType.date,
                      initialValue: '',
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'First Use Date'.tr,
                      icon: const Icon(Icons.event),
                      onChanged: (val) {
                        //print(DateTime.parse(val));
                        //print(val);
                        setState(() {
                          firstUseDate = val.substring(0, 10);
                        });
                        //print(date);
                      },
                      validator: (val) {
                        //print(val);
                        return null;
                      },
                      // ignore: avoid_print
                      onSaved: (val) => print(val),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[10] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: userNameFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'User Name'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[11] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (string) {
                        setState(() {});
                      },
                      controller: useLifeYearsFieldController,
                      decoration: InputDecoration(
                        prefixIconColor: useLifeYearsFieldController.text == ""
                            ? Colors.red
                            : null,
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Due Year'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[23] == "Y",
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Resource Group".tr,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[23] == "Y",
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.all(10),
                    child: FutureBuilder(
                      future: getResourceGroup(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<RefRecords>> snapshot) =>
                          snapshot.hasData
                              ? DropdownButton(
                                  hint: Text("Select a Destination".tr),
                                  value: dropdownValue3 == ""
                                      ? null
                                      : dropdownValue3,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue3 = newValue!;
                                    });
                                    //print(dropdownValue);
                                  },
                                  items: snapshot.data!.map((list) {
                                    return DropdownMenuItem<String>(
                                      value: list.id.toString(),
                                      child: Text(
                                        list.name.toString(),
                                      ),
                                    );
                                  }).toList(),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[12] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: locationFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Location'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[13] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: manufacturerFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Manufacturer'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[14] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (string) {
                        setState(() {});
                      },
                      controller: manufacturedYearFieldController,
                      decoration: InputDecoration(
                        prefixIconColor:
                            manufacturedYearFieldController.text == ""
                                ? Colors.red
                                : null,
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Manufactured Year'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[15] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      // maxLength: 10,
                      keyboardType: TextInputType.datetime,
                      controller: dateCheckFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(EvaIcons.calendarOutline),
                        border: const OutlineInputBorder(),
                        labelText: 'Check Date'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'DD/MM/YYYY',
                        counterText: '',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                        LengthLimitingTextInputFormatter(10),
                        _DateFormatterCustom(),
                      ],
                    ),
                  ),
                ),
                /* Visibility(
                  visible: (args["perm"])[15] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DateTimePicker(
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      type: DateTimePickerType.date,
                      initialValue: DateTime.now().toString(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'Check Date'.tr,
                      icon: const Icon(Icons.event),
                      onChanged: (val) {
                        //print(DateTime.parse(val));
                        //print(val);
                        setState(() {
                          date1 = val.substring(0, 10);
                        });
                        //print(date);
                      },
                      validator: (val) {
                        //print(val);
                        return null;
                      },
                      // ignore: avoid_print
                      onSaved: (val) => print(val),
                    ),
                  ),
                ), */
                Visibility(
                  visible: (args["perm"])[16] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      // maxLength: 10,
                      keyboardType: TextInputType.datetime,
                      controller: dateRevisionFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(EvaIcons.calendarOutline),
                        border: const OutlineInputBorder(),
                        labelText: 'Revision Date'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'DD/MM/YYYY',
                        counterText: '',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                        LengthLimitingTextInputFormatter(10),
                        _DateFormatterCustom(),
                      ],
                    ),
                  ),
                ),
                /* Visibility(
                  visible: (args["perm"])[16] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DateTimePicker(
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      type: DateTimePickerType.date,
                      initialValue: (args["perm"])[16] == "N"
                          ? ''
                          : DateTime.now().toString(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'Revision Date'.tr,
                      icon: const Icon(Icons.event),
                      onChanged: (val) {
                        //print(DateTime.parse(val));
                        //print(val);
                        setState(() {
                          date2 = val.substring(0, 10);
                        });
                        //print(date);
                      },
                      validator: (val) {
                        //print(val);
                        return null;
                      },
                      // ignore: avoid_print
                      onSaved: (val) => print(val),
                    ),
                  ),
                ), */
                Visibility(
                  visible: (args["perm"])[17] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      // maxLength: 10,
                      keyboardType: TextInputType.datetime,
                      controller: dateTestingFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(EvaIcons.calendarOutline),
                        border: const OutlineInputBorder(),
                        labelText: 'Testing Date'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'DD/MM/YYYY',
                        counterText: '',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                        LengthLimitingTextInputFormatter(10),
                        _DateFormatterCustom(),
                      ],
                    ),
                  ),
                ),
                /* Visibility(
                  visible: (args["perm"])[17] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DateTimePicker(
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      type: DateTimePickerType.date,
                      initialValue: (args["perm"])[17] == "N"
                          ? ''
                          : DateTime.now().toString(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'Testing Date'.tr,
                      icon: const Icon(Icons.event),
                      onChanged: (val) {
                        //print(DateTime.parse(val));
                        //print(val);
                        setState(() {
                          date3 = val.substring(0, 10);
                        });
                        //print(date);
                      },
                      validator: (val) {
                        //print(val);
                        return null;
                      },
                      // ignore: avoid_print
                      onSaved: (val) => print(val),
                    ),
                  ),
                ), */
                Visibility(
                  visible: (args["perm"])[18] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (string) {
                        setState(() {});
                      },
                      //focusNode: focusNode,
                      controller: lengthFieldController,
                      decoration: InputDecoration(
                        prefixIconColor: lengthFieldController.text == ""
                            ? Colors.red
                            : null,
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Length".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[19] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (string) {
                        setState(() {});
                      },
                      //focusNode: focusNode,
                      controller: widthFieldController,
                      decoration: InputDecoration(
                        prefixIconColor:
                            widthFieldController.text == "" ? Colors.red : null,
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Width".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[20] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (string) {
                        setState(() {});
                      },
                      //focusNode: focusNode,
                      controller: weightAmtFieldController,
                      decoration: InputDecoration(
                        prefixIconColor: weightAmtFieldController.text == ""
                            ? Colors.red
                            : null,
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Supported Weight".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[21] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (string) {
                        setState(() {});
                      },
                      //focusNode: focusNode,
                      controller: heightFieldController,
                      decoration: InputDecoration(
                        prefixIconColor: heightFieldController.text == ""
                            ? Colors.red
                            : null,
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Height".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[22] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      //focusNode: focusNode,
                      controller: colorFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Color".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[25] == "Y",
                  child: CheckboxListTile(
                    title: Text('Is Property'.tr),
                    value: isPropertyValue,
                    activeColor: kPrimaryColor,
                    onChanged: (bool? value) {
                      setState(() {
                        isPropertyValue = value!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                Visibility(
                  visible: args["propertyMaintain"] ?? false,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: FutureBuilder(
                      future: getPropertyMaintains(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<LSRecords>> snapshot) =>
                          snapshot.hasData
                              ? InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: 'Property Maintain'.tr,
                                    //filled: true,
                                    border: const OutlineInputBorder(
                                        /* borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide.none, */
                                        ),
                                    prefixIcon: const Icon(EvaIcons.list),
                                    //hintText: "search..",
                                    isDense: true,
                                    //fillColor: Theme.of(context).cardColor,
                                  ),
                                  child: DropdownButton(
                                    isDense: true,
                                    underline: const SizedBox(),
                                    hint: Text("Select a Property Maintain".tr),
                                    isExpanded: true,
                                    value: isPropertyMaintainId == "0"
                                        ? null
                                        : isPropertyMaintainId,
                                    elevation: 16,
                                    onChanged: (newValue) {
                                      setState(() {
                                        isPropertyMaintainId =
                                            newValue as String;
                                      });

                                      //print(dropdownValue);
                                    },
                                    items: snapshot.data!.map((list) {
                                      return DropdownMenuItem<String>(
                                        value: list.id.toString(),
                                        child: Text(
                                          list.documentNo.toString(),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    ),
                  ),
                ),
              ],
            );
          },
          tabletBuilder: (context, constraints) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: (args["perm"])[0] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: numberFieldController,
                      onChanged: (value) {
                        if (int.tryParse(numberFieldController.text) != null) {
                          lineFieldController.text =
                              (int.parse(numberFieldController.text) * 10)
                                  .toString();
                        }
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'N°'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[1] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (string) {
                        setState(() {});
                      },
                      controller: lineFieldController,
                      decoration: InputDecoration(
                        prefixIconColor:
                            lineFieldController.text == "" ? Colors.red : null,
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Line N°'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Product".tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllProducts(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<Records>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<Records>(
                                initialValue: const TextEditingValue(text: ''),
                                displayStringForOption: _displayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<Records>.empty();
                                  }
                                  return snapshot.data!.where((Records option) {
                                    return "${option.value}_${option.name}"
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (Records selection) {
                                  setState(() {
                                    productId = _setIdForOption(selection);
                                    productName =
                                        _displayStringForOption(selection);
                                  });

                                  //print(salesrepValue);
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[3] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: noteFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Note'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[4] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: barcodeFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Barcode'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[5] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: sernoFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'SerNo'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[6] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: cartelFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Cartel'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[7] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: productModelFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Product Model'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[8] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DateTimePicker(
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      type: DateTimePickerType.date,
                      initialValue: '',
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'Date Ordered'.tr,
                      icon: const Icon(Icons.event),
                      onChanged: (val) {
                        //print(DateTime.parse(val));
                        //print(val);
                        setState(() {
                          dateOrdered = val.substring(0, 10);
                        });
                        //print(date);
                      },
                      validator: (val) {
                        //print(val);
                        return null;
                      },
                      // ignore: avoid_print
                      onSaved: (val) => print(val),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[9] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DateTimePicker(
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      type: DateTimePickerType.date,
                      initialValue: '',
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'First Use Date'.tr,
                      icon: const Icon(Icons.event),
                      onChanged: (val) {
                        //print(DateTime.parse(val));
                        //print(val);
                        setState(() {
                          firstUseDate = val.substring(0, 10);
                        });
                        //print(date);
                      },
                      validator: (val) {
                        //print(val);
                        return null;
                      },
                      // ignore: avoid_print
                      onSaved: (val) => print(val),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[10] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: userNameFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'User Name'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[11] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (string) {
                        setState(() {});
                      },
                      controller: useLifeYearsFieldController,
                      decoration: InputDecoration(
                        prefixIconColor: useLifeYearsFieldController.text == ""
                            ? Colors.red
                            : null,
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Due Year'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[23] == "Y",
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Resource Group".tr,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[23] == "Y",
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.all(10),
                    child: FutureBuilder(
                      future: getResourceGroup(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<RefRecords>> snapshot) =>
                          snapshot.hasData
                              ? DropdownButton(
                                  hint: Text("Select a Destination".tr),
                                  value: dropdownValue3 == ""
                                      ? null
                                      : dropdownValue3,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue3 = newValue!;
                                    });
                                    //print(dropdownValue);
                                  },
                                  items: snapshot.data!.map((list) {
                                    return DropdownMenuItem<String>(
                                      value: list.id.toString(),
                                      child: Text(
                                        list.name.toString(),
                                      ),
                                    );
                                  }).toList(),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[12] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: locationFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Location'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[26] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: lotFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Lot'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[13] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: manufacturerFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Manufacturer'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[14] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (string) {
                        setState(() {});
                      },
                      controller: manufacturedYearFieldController,
                      decoration: InputDecoration(
                        prefixIconColor:
                            manufacturedYearFieldController.text == ""
                                ? Colors.red
                                : null,
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Manufactured Year'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[15] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      // maxLength: 10,
                      keyboardType: TextInputType.datetime,
                      controller: dateCheckFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(EvaIcons.calendarOutline),
                        border: const OutlineInputBorder(),
                        labelText: 'Check Date'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'DD/MM/YYYY',
                        counterText: '',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                        LengthLimitingTextInputFormatter(10),
                        _DateFormatterCustom(),
                      ],
                    ),
                  ),
                ),
                /* Visibility(
                  visible: (args["perm"])[15] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DateTimePicker(
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      type: DateTimePickerType.date,
                      initialValue: DateTime.now().toString(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'Check Date'.tr,
                      icon: const Icon(Icons.event),
                      onChanged: (val) {
                        //print(DateTime.parse(val));
                        //print(val);
                        setState(() {
                          date1 = val.substring(0, 10);
                        });
                        //print(date);
                      },
                      validator: (val) {
                        //print(val);
                        return null;
                      },
                      // ignore: avoid_print
                      onSaved: (val) => print(val),
                    ),
                  ),
                ), */
                Visibility(
                  visible: (args["perm"])[16] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      // maxLength: 10,
                      keyboardType: TextInputType.datetime,
                      controller: dateRevisionFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(EvaIcons.calendarOutline),
                        border: const OutlineInputBorder(),
                        labelText: 'Revision Date'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'DD/MM/YYYY',
                        counterText: '',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                        LengthLimitingTextInputFormatter(10),
                        _DateFormatterCustom(),
                      ],
                    ),
                  ),
                ),
                /* Visibility(
                  visible: (args["perm"])[16] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DateTimePicker(
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      type: DateTimePickerType.date,
                      initialValue: (args["perm"])[16] == "N"
                          ? ''
                          : DateTime.now().toString(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'Revision Date'.tr,
                      icon: const Icon(Icons.event),
                      onChanged: (val) {
                        //print(DateTime.parse(val));
                        //print(val);
                        setState(() {
                          date2 = val.substring(0, 10);
                        });
                        //print(date);
                      },
                      validator: (val) {
                        //print(val);
                        return null;
                      },
                      // ignore: avoid_print
                      onSaved: (val) => print(val),
                    ),
                  ),
                ), */
                Visibility(
                  visible: (args["perm"])[17] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      // maxLength: 10,
                      keyboardType: TextInputType.datetime,
                      controller: dateTestingFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(EvaIcons.calendarOutline),
                        border: const OutlineInputBorder(),
                        labelText: 'Testing Date'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'DD/MM/YYYY',
                        counterText: '',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                        LengthLimitingTextInputFormatter(10),
                        _DateFormatterCustom(),
                      ],
                    ),
                  ),
                ),
                /* Visibility(
                  visible: (args["perm"])[17] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DateTimePicker(
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      type: DateTimePickerType.date,
                      initialValue: (args["perm"])[17] == "N"
                          ? ''
                          : DateTime.now().toString(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'Testing Date'.tr,
                      icon: const Icon(Icons.event),
                      onChanged: (val) {
                        //print(DateTime.parse(val));
                        //print(val);
                        setState(() {
                          date3 = val.substring(0, 10);
                        });
                        //print(date);
                      },
                      validator: (val) {
                        //print(val);
                        return null;
                      },
                      // ignore: avoid_print
                      onSaved: (val) => print(val),
                    ),
                  ),
                ), */
                Visibility(
                  visible: (args["perm"])[18] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (string) {
                        setState(() {});
                      },
                      //focusNode: focusNode,
                      controller: lengthFieldController,
                      decoration: InputDecoration(
                        prefixIconColor: lengthFieldController.text == ""
                            ? Colors.red
                            : null,
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Length".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[19] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (string) {
                        setState(() {});
                      },
                      //focusNode: focusNode,
                      controller: widthFieldController,
                      decoration: InputDecoration(
                        prefixIconColor:
                            widthFieldController.text == "" ? Colors.red : null,
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Width".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[20] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (string) {
                        setState(() {});
                      },
                      //focusNode: focusNode,
                      controller: weightAmtFieldController,
                      decoration: InputDecoration(
                        prefixIconColor: weightAmtFieldController.text == ""
                            ? Colors.red
                            : null,
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Supported Weight".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[21] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (string) {
                        setState(() {});
                      },
                      //focusNode: focusNode,
                      controller: heightFieldController,
                      decoration: InputDecoration(
                        prefixIconColor: heightFieldController.text == ""
                            ? Colors.red
                            : null,
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Height".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[22] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      //focusNode: focusNode,
                      controller: colorFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Color".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          desktopBuilder: (context, constraints) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: (args["perm"])[0] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: numberFieldController,
                      onChanged: (value) {
                        if (int.tryParse(numberFieldController.text) != null) {
                          lineFieldController.text =
                              (int.parse(numberFieldController.text) * 10)
                                  .toString();
                        }
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'N°'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[1] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (string) {
                        setState(() {});
                      },
                      controller: lineFieldController,
                      decoration: InputDecoration(
                        prefixIconColor:
                            lineFieldController.text == "" ? Colors.red : null,
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Line N°'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Product".tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getAllProducts(),
                    builder: (BuildContext ctx,
                            AsyncSnapshot<List<Records>> snapshot) =>
                        snapshot.hasData
                            ? Autocomplete<Records>(
                                initialValue: const TextEditingValue(text: ''),
                                displayStringForOption: _displayStringForOption,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<Records>.empty();
                                  }
                                  return snapshot.data!.where((Records option) {
                                    return "${option.value}_${option.name}"
                                        .toString()
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase());
                                  });
                                },
                                onSelected: (Records selection) {
                                  setState(() {
                                    productId = _setIdForOption(selection);
                                    productName =
                                        _displayStringForOption(selection);
                                  });

                                  //print(salesrepValue);
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[3] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: noteFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Note'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[4] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: barcodeFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Barcode'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[5] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: sernoFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'SerNo'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[6] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: cartelFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Cartel'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[7] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: productModelFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Product Model'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[8] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DateTimePicker(
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      type: DateTimePickerType.date,
                      initialValue: '',
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'Date Ordered'.tr,
                      icon: const Icon(Icons.event),
                      onChanged: (val) {
                        //print(DateTime.parse(val));
                        //print(val);
                        setState(() {
                          dateOrdered = val.substring(0, 10);
                        });
                        //print(date);
                      },
                      validator: (val) {
                        //print(val);
                        return null;
                      },
                      // ignore: avoid_print
                      onSaved: (val) => print(val),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[9] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DateTimePicker(
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      type: DateTimePickerType.date,
                      initialValue: '',
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'First Use Date'.tr,
                      icon: const Icon(Icons.event),
                      onChanged: (val) {
                        //print(DateTime.parse(val));
                        //print(val);
                        setState(() {
                          firstUseDate = val.substring(0, 10);
                        });
                        //print(date);
                      },
                      validator: (val) {
                        //print(val);
                        return null;
                      },
                      // ignore: avoid_print
                      onSaved: (val) => print(val),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[10] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: userNameFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'User Name'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[11] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (string) {
                        setState(() {});
                      },
                      controller: useLifeYearsFieldController,
                      decoration: InputDecoration(
                        prefixIconColor: useLifeYearsFieldController.text == ""
                            ? Colors.red
                            : null,
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Due Year'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[23] == "Y",
                  child: Container(
                    padding: const EdgeInsets.only(left: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Resource Group".tr,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[23] == "Y",
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.all(10),
                    child: FutureBuilder(
                      future: getResourceGroup(),
                      builder: (BuildContext ctx,
                              AsyncSnapshot<List<RefRecords>> snapshot) =>
                          snapshot.hasData
                              ? DropdownButton(
                                  hint: Text("Select a Destination".tr),
                                  value: dropdownValue3 == ""
                                      ? null
                                      : dropdownValue3,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue3 = newValue!;
                                    });
                                    //print(dropdownValue);
                                  },
                                  items: snapshot.data!.map((list) {
                                    return DropdownMenuItem<String>(
                                      value: list.id.toString(),
                                      child: Text(
                                        list.name.toString(),
                                      ),
                                    );
                                  }).toList(),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[12] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: locationFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Location'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[13] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: manufacturerFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Manufacturer'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[14] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (string) {
                        setState(() {});
                      },
                      controller: manufacturedYearFieldController,
                      decoration: InputDecoration(
                        prefixIconColor:
                            manufacturedYearFieldController.text == ""
                                ? Colors.red
                                : null,
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: const OutlineInputBorder(),
                        labelText: 'Manufactured Year'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[15] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      // maxLength: 10,
                      keyboardType: TextInputType.datetime,
                      controller: dateCheckFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(EvaIcons.calendarOutline),
                        border: const OutlineInputBorder(),
                        labelText: 'Check Date'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'DD/MM/YYYY',
                        counterText: '',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                        LengthLimitingTextInputFormatter(10),
                        _DateFormatterCustom(),
                      ],
                    ),
                  ),
                ),
                /* Visibility(
                  visible: (args["perm"])[15] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DateTimePicker(
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      type: DateTimePickerType.date,
                      initialValue: DateTime.now().toString(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'Check Date'.tr,
                      icon: const Icon(Icons.event),
                      onChanged: (val) {
                        //print(DateTime.parse(val));
                        //print(val);
                        setState(() {
                          date1 = val.substring(0, 10);
                        });
                        //print(date);
                      },
                      validator: (val) {
                        //print(val);
                        return null;
                      },
                      // ignore: avoid_print
                      onSaved: (val) => print(val),
                    ),
                  ),
                ), */
                Visibility(
                  visible: (args["perm"])[16] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      // maxLength: 10,
                      keyboardType: TextInputType.datetime,
                      controller: dateRevisionFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(EvaIcons.calendarOutline),
                        border: const OutlineInputBorder(),
                        labelText: 'Revision Date'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'DD/MM/YYYY',
                        counterText: '',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                        LengthLimitingTextInputFormatter(10),
                        _DateFormatterCustom(),
                      ],
                    ),
                  ),
                ),
                /* Visibility(
                  visible: (args["perm"])[16] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DateTimePicker(
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      type: DateTimePickerType.date,
                      initialValue: (args["perm"])[16] == "N"
                          ? ''
                          : DateTime.now().toString(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'Revision Date'.tr,
                      icon: const Icon(Icons.event),
                      onChanged: (val) {
                        //print(DateTime.parse(val));
                        //print(val);
                        setState(() {
                          date2 = val.substring(0, 10);
                        });
                        //print(date);
                      },
                      validator: (val) {
                        //print(val);
                        return null;
                      },
                      // ignore: avoid_print
                      onSaved: (val) => print(val),
                    ),
                  ),
                ), */
                Visibility(
                  visible: (args["perm"])[17] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      // maxLength: 10,
                      keyboardType: TextInputType.datetime,
                      controller: dateTestingFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(EvaIcons.calendarOutline),
                        border: const OutlineInputBorder(),
                        labelText: 'Testing Date'.tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'DD/MM/YYYY',
                        counterText: '',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                        LengthLimitingTextInputFormatter(10),
                        _DateFormatterCustom(),
                      ],
                    ),
                  ),
                ),
                /* Visibility(
                  visible: (args["perm"])[17] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DateTimePicker(
                      locale: Locale('language'.tr, 'LANGUAGE'.tr),
                      type: DateTimePickerType.date,
                      initialValue: (args["perm"])[17] == "N"
                          ? ''
                          : DateTime.now().toString(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'Testing Date'.tr,
                      icon: const Icon(Icons.event),
                      onChanged: (val) {
                        //print(DateTime.parse(val));
                        //print(val);
                        setState(() {
                          date3 = val.substring(0, 10);
                        });
                        //print(date);
                      },
                      validator: (val) {
                        //print(val);
                        return null;
                      },
                      // ignore: avoid_print
                      onSaved: (val) => print(val),
                    ),
                  ),
                ), */
                Visibility(
                  visible: (args["perm"])[18] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (string) {
                        setState(() {});
                      },
                      //focusNode: focusNode,
                      controller: lengthFieldController,
                      decoration: InputDecoration(
                        prefixIconColor: lengthFieldController.text == ""
                            ? Colors.red
                            : null,
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Length".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[19] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (string) {
                        setState(() {});
                      },
                      //focusNode: focusNode,
                      controller: widthFieldController,
                      decoration: InputDecoration(
                        prefixIconColor:
                            widthFieldController.text == "" ? Colors.red : null,
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Width".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[20] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (string) {
                        setState(() {});
                      },
                      //focusNode: focusNode,
                      controller: weightAmtFieldController,
                      decoration: InputDecoration(
                        prefixIconColor: weightAmtFieldController.text == ""
                            ? Colors.red
                            : null,
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Supported Weight".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[21] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (string) {
                        setState(() {});
                      },
                      //focusNode: focusNode,
                      controller: heightFieldController,
                      decoration: InputDecoration(
                        prefixIconColor: heightFieldController.text == ""
                            ? Colors.red
                            : null,
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Height".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (args["perm"])[22] == "Y",
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      //focusNode: focusNode,
                      controller: colorFieldController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_outlined),
                        border: const OutlineInputBorder(),
                        labelText: "Color".tr,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DateFormatterCustom extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue prevText, TextEditingValue currText) {
    int selectionIndex;

    // Get the previous and current input strings
    String pText = prevText.text;
    String cText = currText.text;
    // Abbreviate lengths
    int cLen = cText.length;
    int pLen = pText.length;

    if (cLen == 1) {
      // Can only be 0, 1, 2 or 3
      if (int.parse(cText) > 3) {
        // Remove char
        cText = '';
      }
    } else if (cLen == 2 && pLen == 1) {
      // Days cannot be greater than 31
      int dd = int.parse(cText.substring(0, 2));
      if (dd == 0 || dd > 31) {
        // Remove char
        cText = cText.substring(0, 1);
      } else {
        // Add a / char
        cText += '/';
      }
    } else if (cLen == 4) {
      // Can only be 0 or 1
      if (int.parse(cText.substring(3, 4)) > 1) {
        // Remove char
        cText = cText.substring(0, 3);
      }
    } else if (cLen == 5 && pLen == 4) {
      // Month cannot be greater than 12
      int mm = int.parse(cText.substring(3, 5));
      if (mm == 0 || mm > 12) {
        // Remove char
        cText = cText.substring(0, 4);
      } else {
        // Add a / char
        cText += '/';
      }
    } else if ((cLen == 3 && pLen == 4) || (cLen == 6 && pLen == 7)) {
      // Remove / char
      cText = cText.substring(0, cText.length - 1);
    } else if (cLen == 3 && pLen == 2) {
      if (int.parse(cText.substring(2, 3)) > 1) {
        // Replace char
        cText = '${cText.substring(0, 2)}/';
      } else {
        // Insert / char
        cText =
            '${cText.substring(0, pLen)}/${cText.substring(pLen, pLen + 1)}';
      }
    } else if (cLen == 6 && pLen == 5) {
      // Can only be 1 or 2 - if so insert a / char
      int y1 = int.parse(cText.substring(5, 6));
      if (y1 < 1 || y1 > 2) {
        // Replace char
        cText = '${cText.substring(0, 5)}/';
      } else {
        // Insert / char
        cText = '${cText.substring(0, 5)}/${cText.substring(5, 6)}';
      }
    } else if (cLen == 7) {
      // Can only be 1 or 2
      int y1 = int.parse(cText.substring(6, 7));
      if (y1 < 1 || y1 > 2) {
        // Remove char
        cText = cText.substring(0, 6);
      }
    } else if (cLen == 8) {
      // Can only be 19 or 20
      int y2 = int.parse(cText.substring(6, 8));
      if (y2 < 19 || y2 > 20) {
        // Remove char
        cText = cText.substring(0, 7);
      }
    }

    selectionIndex = cText.length;
    return TextEditingValue(
      text: cText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
