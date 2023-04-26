part of dashboard;

class AnomalyListController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  late AnomalyJson _trx;
  AttachmentListJson att = AttachmentListJson(attachments: []);
  //var _hasMailSupport = false;
  dynamic args = Get.arguments;
  int docId = 0;
  // ignore: prefer_typing_uninitialized_variables
  var adUserId;

  var value = ("Replacements Only".tr).obs;

  var filters = ["Replacements Only", "All" /* , "Team" */];
  var filterCount = 0;
  // ignore: prefer_final_fields
  var _dataAvailable = false.obs;
  // ignore: prefer_final_fields
  var _attachmentsAvailable = false.obs;

  var searchFieldController = TextEditingController();
  var searchFilterValue = "".obs;

  late List<Types> dropDownList;
  var dropdownValue = "1".obs;

  Future<void> getWarehouseDocType() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');

    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_DocType?\$filter= Name eq \'Warehouse Order\' and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      var json = jsonDecode(utf8.decode(response.bodyBytes));

      if (json["row-count"] > 0) {
        docId = json["records"][0]["id"];
      }

      //_trx = AnomalyJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
      //_dataAvailable.value = _trx != null;
    }
  }

  Future<void> createSalesOrderFromAnomaly() async {
    Get.defaultDialog(
      title: 'Create Sales Order'.tr,
      content: Text("Are you sure you want to create a Sales Order?".tr),
      onCancel: () {},
      onConfirm: () async {
        final ip = GetStorage().read('ip');
        String authorization = 'Bearer ${GetStorage().read('token')}';
        final msg = jsonEncode({
          "record-id": args["record-id"],
          "model-name": args["model-name"],
          "C_DocType_ID": docId,
        });
        //print(msg);
        final protocol = GetStorage().read('protocol');
        var url = Uri.parse(
            '$protocol://$ip/api/v1/processes/createsalesorderfromanomaly');

        var response = await http.post(
          url,
          body: msg,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': authorization,
          },
        );
        if (response.statusCode == 200) {
          //print("done!");
          Get.back();
          //print(response.body);
          Get.snackbar(
            "Done!".tr,
            "Sales Order has been created".tr,
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
            "Sales Order not created".tr,
            icon: const Icon(
              Icons.error,
              color: Colors.red,
            ),
          );
        }
      },
    );
  }

  Future<void> syncAnomalies() async {
    _dataAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/LIT_NC?\$filter= IsClosed eq N and AD_Client_ID eq ${GetStorage().read('clientid')}'); //

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var json =
          AnomalyJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      if (json.pagecount! > 1) {
        int index = 1;
        syncAnomaliesPages(json, index);
      } else {
        const filename = "anomalies";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsStringSync(utf8.decode(response.bodyBytes));
        getAnomalies();
        //productSync = false;
        //syncAnomalyTypes();
        if (kDebugMode) {
          print('Anomalies Checked');
        }
        //checkSyncData();
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      //productSync = false;
      //checkSyncData();
    }
  }

  syncAnomaliesPages(AnomalyJson json, int index) async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/LIT_NC?\$filter= IsClosed eq N and AD_Client_ID eq ${GetStorage().read('clientid')}&\$skip=${(index * 100)}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      index += 1;
      var pageJson =
          AnomalyJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      for (var element in pageJson.records!) {
        json.records!.add(element);
      }

      if (json.pagecount! > index) {
        syncAnomaliesPages(json, index);
      } else {
        if (kDebugMode) {
          print(json.records!.length);
        }
        const filename = "anomalies";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsStringSync(jsonEncode(json.toJson()));
        getAnomalies();
        //productSync = false;
        //syncAnomalyTypes();
        if (kDebugMode) {
          print('Anomalies Checked');
        }
        //checkSyncData();
      }
    }
  }

  /* final json = {
    "types": [
      {"id": "1", "name": "Name"},
      {"id": "2", "name": "Mail"},
      {"id": "3", "name": "Phone N°"},
    ]
  }; */

  /* List<Types>? getTypes() {
    var dJson = TypeJson.fromJson(json);

    return dJson.types;
  } */

  @override
  void onInit() {
    //dropDownList = getTypes()!;
    super.onInit();
    getWarehouseDocType();
    getAnomalies();
    //getADUserID();
    adUserId = GetStorage().read('userId');
  }

  bool get dataAvailable => _dataAvailable.value;
  AnomalyJson get trx => _trx;
  //String get value => _value.toString();

  changeFilter() {
    filterCount++;
    if (filterCount == 2) {
      filterCount = 0;
    }

    value.value = filters[filterCount];
    getAnomalies();
  }

  Future<void> getAnomalies() async {
    _dataAvailable.value = false;
    //var apiUrlFilter = ["", " and LIT_IsReplaced eq Y"];

    const filename = "anomalies";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

    var json = AnomalyJson.fromJson(jsonDecode(file.readAsStringSync()));

    //print(json.records!.length);

    json.records!.retainWhere((element) =>
        element.mPMaintainResourceID?.id == args["id"] &&
        element.isClosed == false);

    if (json.records!.isNotEmpty && await checkConnection()) {
      for (var element in json.records!) {
        await getRecordAttachments(element.id!);
      }
    }

    /* for (var element in json.records!) {
      print(element.isClosed);
    } */

    _trx = json;
    // ignore: unnecessary_null_comparison
    _dataAvailable.value = _trx != null;
    _attachmentsAvailable.value = true;
    //}
  }

  getAttachmentData(int id, String name) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';

    final protocol = GetStorage().read('protocol');
    var url =
        Uri.parse('$protocol://$ip/api/v1/models/lit_nc/$id/attachments/$name');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var image64 = base64.encode(response.bodyBytes);
      Get.to(const AnomalyImage(), arguments: {"base64": image64});
      //print(response.body);
    }
  }

  deleteAttachment(int index, int id, String name) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';

    final protocol = GetStorage().read('protocol');
    var url =
        Uri.parse('$protocol://$ip/api/v1/models/lit_nc/$id/attachments/$name');

    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      _attachmentsAvailable.value = false;
      att.attachments!.removeAt(index);
      _attachmentsAvailable.value = true;
    }
  }

  getRecordAttachments(int id) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';

    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/lit_nc/$id/attachments');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var json = AttachmentListJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      if (json.attachments != null) {
        for (var element in json.attachments!) {
          att.attachments!.add(Attachment(id: id, name: element.name));
        }
      }
    }
  }

  /* void openDrawer() {
    if (scaffoldKey.currentState != null) {
      scaffoldKey.currentState!.openDrawer();
    }
  } */

  // Data
  // ignore: library_private_types_in_public_api
  _Profile getProfil() {
    //"userName": "Flavia Lonardi", "password": "Fl@via2021"
    String userName = GetStorage().read('user') as String;
    String roleName = GetStorage().read('rolename') as String;
    return _Profile(
      photo: const AssetImage(ImageRasterPath.avatar1),
      name: userName,
      email: roleName,
    );
  }

  List<TaskCardData> getAllTask() {
    //List<TaskCardData> list;

    return [
      TaskCardData(
        seeAllFunction: () {
          Get.toNamed('/leads');
        },
        addFunction: () {
          //Get.toNamed('/createLead');
          log('hallooooo');
        },
        title: "Lead",
        dueDay: 2,
        totalComments: 50,
        type: TaskType.inProgress,
        totalContributors: 30,
        profilContributors: [
          const AssetImage(ImageRasterPath.avatar1),
          const AssetImage(ImageRasterPath.avatar2),
          const AssetImage(ImageRasterPath.avatar3),
          const AssetImage(ImageRasterPath.avatar4),
        ],
      ),
      TaskCardData(
        seeAllFunction: () {},
        addFunction: () {},
        title: "Landing page UI Design",
        dueDay: -1,
        totalComments: 50,
        totalContributors: 34,
        type: TaskType.inProgress,
        profilContributors: [
          const AssetImage(ImageRasterPath.avatar5),
          const AssetImage(ImageRasterPath.avatar6),
          const AssetImage(ImageRasterPath.avatar7),
          const AssetImage(ImageRasterPath.avatar8),
        ],
      ),
      TaskCardData(
        seeAllFunction: () {},
        addFunction: () {},
        title: "Landing page UI Design",
        dueDay: 1,
        totalComments: 50,
        totalContributors: 34,
        type: TaskType.done,
        profilContributors: [
          const AssetImage(ImageRasterPath.avatar5),
          const AssetImage(ImageRasterPath.avatar3),
          const AssetImage(ImageRasterPath.avatar4),
          const AssetImage(ImageRasterPath.avatar2),
        ],
      ),
    ];
  }

  ProjectCardData getSelectedProject() {
    return ProjectCardData(
      percent: .3,
      projectImage: const AssetImage(ImageRasterPath.logo1),
      projectName: "Intervento",
      releaseTime: DateTime.now(),
    );
  }

  List<ProjectCardData> getActiveProject() {
    return [
      ProjectCardData(
        percent: .3,
        projectImage: const AssetImage(ImageRasterPath.logo2),
        projectName: "Taxi Online",
        releaseTime: DateTime.now().add(const Duration(days: 130)),
      ),
      ProjectCardData(
        percent: .5,
        projectImage: const AssetImage(ImageRasterPath.logo3),
        projectName: "E-Movies Mobile",
        releaseTime: DateTime.now().add(const Duration(days: 140)),
      ),
      ProjectCardData(
        percent: .8,
        projectImage: const AssetImage(ImageRasterPath.logo4),
        projectName: "Video Converter App",
        releaseTime: DateTime.now().add(const Duration(days: 100)),
      ),
    ];
  }

  List<ImageProvider> getMember() {
    return const [
      AssetImage(ImageRasterPath.avatar1),
      AssetImage(ImageRasterPath.avatar2),
      AssetImage(ImageRasterPath.avatar3),
      AssetImage(ImageRasterPath.avatar4),
      AssetImage(ImageRasterPath.avatar5),
      AssetImage(ImageRasterPath.avatar6),
    ];
  }

  List<ChattingCardData> getChatting() {
    return const [
      ChattingCardData(
        image: AssetImage(ImageRasterPath.avatar6),
        isOnline: true,
        name: "Samantha",
        lastMessage: "i added my new tasks",
        isRead: false,
        totalUnread: 100,
      ),
      ChattingCardData(
        image: AssetImage(ImageRasterPath.avatar3),
        isOnline: false,
        name: "John",
        lastMessage: "well done john",
        isRead: true,
        totalUnread: 0,
      ),
      ChattingCardData(
        image: AssetImage(ImageRasterPath.avatar4),
        isOnline: true,
        name: "Alexander Purwoto",
        lastMessage: "we'll have a meeting at 9AM",
        isRead: false,
        totalUnread: 1,
      ),
    ];
  }
}
