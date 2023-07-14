// ignore_for_file: library_private_types_in_public_api

part of dashboard;

class MaintenanceMptaskController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  var args = Get.arguments;
  late WorkOrderLocalJson _trx;
  late WorkOrderLocalJson _trx2;
  var _hasCallSupport = false;
  //var _hasMailSupport = false;

  // ignore: prefer_typing_uninitialized_variables
  var adUserId;

  var value = (("Today").tr).obs;

  var filters = [
    "Today".tr,
    "> ${"Today".tr}",
    "< ${"Today".tr}",
    "All".tr /* , "Team" */
  ];
  var filterCount = 0;
  // ignore: prefer_final_fields
  var _dataAvailable = false.obs;

  @override
  void onInit() {
    super.onInit();
    canLaunchUrl(Uri.parse('tel:123')).then((bool result) {
      _hasCallSupport = result;
    });

    getWorkOrders();
  }

  bool get dataAvailable => _dataAvailable.value;
  WorkOrderLocalJson get trx => _trx;
  //String get value => _value.toString();

  changeFilter() {
    filterCount++;
    if (filterCount == 4) {
      filterCount = 0;
    }

    value.value = filters[filterCount];
    getWorkOrders();
  }

  completeToDo(int index) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/JP_ToDo/${_trx.records![index].jPToDoID?.id}');

    var msg = jsonEncode({
      'JP_ToDo_Status': {"id": "CO"}
    });
    var response = await http.put(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //syncWorkOrder();
      completeWorkOrder(index);

      /* Get.snackbar(
        "Done!".tr,
        "The Record has been Completed".tr,
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      ); */
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  completeWorkOrder(int index) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/mp_ot/${_trx.records![index].id}');

    var msg = jsonEncode({
      'DocStatus': {"id": "CO"}
    });
    var response = await http.put(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //syncWorkOrder();

      const filename = "workorder";
      final file = File(
          '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

      var json =
          WorkOrderLocalJson.fromJson(jsonDecode(file.readAsStringSync()));

      for (var element in json.records!) {
        if (element.id == _trx.records![index].id) {
          element.docStatus?.id = "CO";
          element.jpToDoStatus?.id = "CO";
        }
      }

      file.writeAsStringSync(jsonEncode(json.toJson()));

      getWorkOrders();

      Get.snackbar(
        "Done!".tr,
        "The Record has been Completed".tr,
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  reOpenToDo(int index) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/JP_ToDo/${_trx.records![index].jPToDoID?.id}');

    var msg = jsonEncode({
      'JP_ToDo_Status': {"id": "NY"}
    });
    var response = await http.put(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //syncWorkOrder();
      reOpenWorkOrder(index);

      /* Get.snackbar(
        "Done!".tr,
        "The Record has been Completed".tr,
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      ); */
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  reOpenWorkOrder(int index) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/mp_ot/${_trx.records![index].id}');

    var msg = jsonEncode({
      'DocStatus': {"id": "DR"}
    });
    var response = await http.put(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //syncWorkOrder();

      const filename = "workorder";
      final file = File(
          '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

      var json =
          WorkOrderLocalJson.fromJson(jsonDecode(file.readAsStringSync()));

      for (var element in json.records!) {
        if (element.id == _trx.records![index].id) {
          element.docStatus?.id = "DR";
          element.jpToDoStatus?.id = "NY";
        }
      }

      file.writeAsStringSync(jsonEncode(json.toJson()));

      getWorkOrders();

      Get.snackbar(
        "Done!".tr,
        "The Record has been Reopened".tr,
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getDocument(int index) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/windows/work-order-extinguisher/${_trx.records![index].id}/print');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(utf8.decode(response.bodyBytes));
      var json = jsonDecode(utf8.decode(response.bodyBytes));

      String pdfString = json["exportFile"];
      //print(pdfString);

      List<int> list = base64.decode(pdfString);
      Uint8List bytes = Uint8List.fromList(list);
      //print(bytes);

      //final pdf = await rootBundle.load('document.pdf');
      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => bytes);

      //return json.records!;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception("Failed to load PDF");
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    if (_hasCallSupport) {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      await launchUrl(launchUri);
    }
  }

  Future<void> writeMailTo(String receiver) async {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: receiver,
    );
    await launchUrl(launchUri);
  }

  Future<void> getWorkOrders() async {
    _dataAvailable.value = false;
    //print(GetStorage().read('workOrderSync'));
    //print(GetStorage().read('userId'));
    var notificationFilter = 0;
    if (args != null) {
      if (args['notificationId'] != null && args['notificationId'] != 0) {
        notificationFilter = args['notificationId'];
        args['notificationId'] = 0;
      }
    }

    const filename = "workorder";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

    var jsondecoded = jsonDecode(file.readAsStringSync());
    _trx = WorkOrderLocalJson.fromJson(jsondecoded);
    _trx2 = WorkOrderLocalJson.fromJson(jsondecoded);

    //print(_trx.records!.length);

    //print(value.value);
    if (notificationFilter == 0) {
      if (value.value == "Today".tr) {
        _trx.records!.retainWhere((element) =>
            DateTime.now().toString().substring(0, 10) ==
            element.jpToDoStartDate);
      }
      if (value.value == "> ${"Today".tr}") {
        _trx.records!.retainWhere((element) =>
            DateTime.now().isBefore(DateTime.parse(element.jpToDoStartDate!)));
      }
      if (value.value == "< ${"Today".tr}") {
        _trx.records!.retainWhere((element) =>
            DateTime.now().isAfter(DateTime.parse(element.jpToDoStartDate!)));
      }
    } else {
      _trx.records!.retainWhere((element) => element.id == notificationFilter);
      notificationFilter = 0;
    }

    // ignore: unnecessary_null_comparison
    _dataAvailable.value = _trx != null;
  }

  Future<void> syncWorkOrder() async {
    _dataAvailable.value = false;
    var isConnected = await checkConnection();

    //print(isConnected);

    if (isConnected) {
      emptyAPICallStak();
      _dataAvailable.value = false;
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
        //print(response.body);
        const filename = "workorder";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsStringSync(utf8.decode(response.bodyBytes));
        //GetStorage().write('workOrderSync', utf8.decode(response.bodyBytes));
        //isWorkOrderSyncing.value = false;
        //getWorkOrders();
        syncWorkOrderResource();
      } else {
        if (kDebugMode) {
          print(response.body);
        }
      }
    } else {
      Get.snackbar(
        "Connessione Internet assente!",
        "Impossibile aggiornare i record.",
        icon: const Icon(
          Icons.signal_wifi_connected_no_internet_4,
          color: Colors.red,
        ),
      );
    }
  }

  Future<void> syncWorkOrderResource() async {
    String ip = GetStorage().read('ip');
    //var userId = GetStorage().read('userId');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mp_maintain_resource_v?\$filter= AD_User_ID eq ${GetStorage().read('userId')} or AD_User_ID eq null and AD_Client_ID eq ${GetStorage().read('clientid')}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        //print(response.body);
      }
      var json = WorkOrderResourceLocalJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      if (json.pagecount! > 1) {
        int index = 1;
        syncWorkOrderResourcePages(json, index);
      } else {
        const filename = "workorderresource";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsStringSync(utf8.decode(response.bodyBytes));
        //productSync = false;
        getWorkOrders();
        if (kDebugMode) {
          print('WorkOrderResource Checked');
        }
        //checkSyncData();
      }
      //syncWorkOrderResourceSurveyLines();
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  syncWorkOrderResourcePages(WorkOrderResourceLocalJson json, int index) async {
    String ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mp_maintain_resource_v?\$filter= AD_User_ID eq ${GetStorage().read('userId')} or AD_User_ID eq null and AD_Client_ID eq ${GetStorage().read('clientid')}&\$skip=${(index * 100)}');

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
        if (kDebugMode) {
          print(json.records!.length);
        }
        const filename = "workorderresource";
        final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
        file.writeAsStringSync(jsonEncode(json.toJson()));
        //workOrderSync = false;
        getWorkOrders();
        if (kDebugMode) {
          print('WorkOrderResource Checked');
        }
        //checkSyncData();
        //syncWorkOrderResourceSurveyLines();
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> createSalesOrderFromWorkOrder(int index) async {
    Get.defaultDialog(
      title: 'Create Sales Order'.tr,
      content: Text("Are you sure you want to create a Sales Order?".tr),
      onCancel: () {},
      onConfirm: () async {
        final ip = GetStorage().read('ip');
        String authorization = 'Bearer ${GetStorage().read('token')}';
        var msg = jsonEncode({
          "record-id": _trx.records![index].id,
          "C_DocType_ID": _trx.records![index].litcDocTypeODVID?.id ?? 1000033,
        });

        if (_trx.records![index].cOrderID != null) {
          msg = jsonEncode({
            "record-id": _trx.records![index].id,
            "C_DocType_ID":
                _trx.records![index].litcDocTypeODVID?.id ?? 1000033,
            "C_Order_ID": _trx.records![index].cOrderID?.id,
            "IsExistingOrder": true,
          });
        }
        //print(msg);
        final protocol = GetStorage().read('protocol');
        var url =
            Uri.parse('$protocol://$ip/api/v1/processes/createorderfromwo');

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

  /* void openDrawer() {
    if (scaffoldKey.currentState != null) {
      scaffoldKey.currentState!.openDrawer();
    }
  } */

  // Data
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

class Provider extends GetConnect {
  Future<void> getLeads() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    //print(authorization);
    //String clientid = GetStorage().read('clientid');
    /* final response = await get(
      'http://' + ip + '/api/v1/windows/lead',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.status.hasError) {
      return Future.error(response.statusText!);
    } else {
      return response.body;
    } */

    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/windows/lead');
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
      //print(json['window-records'][0]);
      return json;
    } else {
      return Future.error(response.body);
    }
  }
}
