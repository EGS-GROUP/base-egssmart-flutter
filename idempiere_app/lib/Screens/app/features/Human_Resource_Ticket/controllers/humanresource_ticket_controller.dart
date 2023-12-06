part of dashboard;

class HumanResourceTicketController extends GetxController {
  late TicketsJson _trx;
  late TicketTypeJson _tt;
  var _hasCallSupport = false;

  int genericTicketId = 0;

  String dropdownValue = "";

  var pagesCount = 1.obs;
  var pagesTot = 1.obs;

  var userFilter = GetStorage().read('TicketHR_userFilter') ?? "";
  var dateStartFilter = GetStorage().read('TicketHR_dateStartFilter') ?? "";
  var dateEndFilter = GetStorage().read('TicketHR_dateEndFilter') ?? "";

  var userId = 0.obs;
  String userName = "";
  var dateStartValue = "".obs;
  var dateEndValue = "".obs;
  //var _hasMailSupport = false;

  // ignore: prefer_typing_uninitialized_variables
  var adUserId;
  // ignore: prefer_typing_uninitialized_variables
  var businessPartnerId;
  // ignore: prefer_typing_uninitialized_variables
  var closedTicketId;

  String ticketFilter = "";

  var value = "Tutti".obs;

  var filters = ["Tutti", "Miei" /* , "Team" */];
  var filterCount = 0;
  // ignore: prefer_final_fields
  var _dataAvailable = false.obs;

  @override
  void onInit() {
    super.onInit();
    canLaunchUrl(Uri.parse('tel:123')).then((bool result) {
      _hasCallSupport = result;
    });
    userName = GetStorage().read('TicketHR_userName') ?? "";
    userId.value = GetStorage().read('TicketHR_userId') ?? 0;
    dateStartValue.value = GetStorage().read('TicketHR_dateStart') ?? "";
    dateEndValue.value = GetStorage().read('TicketHR_dateEnd') ?? "";
    getTicketTypes();
    getClosedTicketsID();
    //getBusinessPartner();
    //getTickets();
    //getADUserID();
    adUserId = GetStorage().read('userId');
  }

  bool get dataAvailable => _dataAvailable.value;
  TicketsJson get trx => _trx;
  TicketTypeJson get tt => _tt;
  //String get value => _value.toString();

  openTicketType() {
    Get.defaultDialog(
      title: "Ticket Type",
      //middleText: "Choose the type of Ticket you want to create",
      //contentPadding: const EdgeInsets.all(2.0),
      content: DropdownButton(
        value: dropdownValue,
        style: const TextStyle(fontSize: 12.0),
        elevation: 16,
        onChanged: (String? newValue) {
          dropdownValue = newValue!;
          Get.back();
          Get.to(const CreateHumanResourceTicket(),
              arguments: {"id": dropdownValue});
        },
        items: _tt.records!.map((list) {
          return DropdownMenuItem<String>(
            value: list.id.toString(),
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
          Get.to(const CreateHumanResourceTicket(),
              arguments: {"id": dropdownValue});
        } */
    );
  }

  getAllticketTypeID() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';

    final protocol = GetStorage().read('protocol');

    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/R_RequestType?\$filter= Description eq \'HR\'');

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
          TicketTypeJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      for (var i = 0; i < json.rowcount!; i++) {
        ticketFilter =
            "${ticketFilter}R_RequestType_ID eq ${json.records![i].id}";

        if (i != json.rowcount! - 1) {
          ticketFilter = "$ticketFilter OR ";
        }
      }
      //print(ticketFilter);
      getTickets();
    }
  }

  getTicketAttachment(int index) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';

    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/r_request/${trx.records![index].id}/attachments/ticketimage.jpg');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var image64 = base64.encode(response.bodyBytes);
      Get.to(const TicketInternalImage(), arguments: {"base64": image64});
    }
  }

  checkcloseTicket(int index) {
    Get.defaultDialog(
        title: "Close Ticket",
        middleText: "Are you sure you want to close the Ticket?",
        //contentPadding: const EdgeInsets.all(2.0),
        barrierDismissible: true,
        textCancel: "Cancel",
        textConfirm: "Confirm",
        onConfirm: () {
          Get.back();
          closeTicket(index);
        });
  }

  changeFilter() {
    filterCount++;
    if (filterCount == 2) {
      filterCount = 0;
    }

    value.value = filters[filterCount];
    getTickets();
  }

  Future<void> getBusinessPartner() async {
    var name = GetStorage().read("user");
    final ip = GetStorage().read('ip');
    final protocol = GetStorage().read('protocol');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/ad_user?\$filter= Name eq \'$name\' and AD_Client_ID eq ${GetStorage().read('clientid')}');
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

      businessPartnerId = json["records"][0]["C_BPartner_ID"]["id"];
      //getTickets();
      getAllticketTypeID();
      //print(businessPartnerId);
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getClosedTicketsID() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/R_Status?\$filter= Value eq \'CLOSE99\' and AD_Client_ID eq ${GetStorage().read('clientid')}');
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

      closedTicketId = json["records"][0]["id"];
      getBusinessPartner();
      //print(businessPartnerId);
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
    } else {
      //print(response.body);
    }
  }

  Future<void> getTicketTypes() async {
    //var name = GetStorage().read("user");
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/R_RequestType?\$filter=startswith(LIT_RequestSubType,\'HR\') and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      //var json = jsonDecode(response.body);
      _tt =
          TicketTypeJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      dropdownValue = _tt.records![0].id.toString();

      for (var element in _tt.records!) {
        if (element.lITRequestSubType?.id == 'HRG') {
          genericTicketId = element.id ?? 0;
        }
      }

      //businessPartnerId = json["records"][0]["C_BPartner_ID"]["id"];
      //getTickets();
      //print(businessPartnerId);
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
    } else {
      //print(response.body);
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

  Future<void> getTickets() async {
    var apiUrlFilter = ["", " and SalesRep_ID eq $adUserId"];
    var notificationFilter = "";
    if (Get.arguments != null) {
      if (Get.arguments['notificationId'] != null) {
        notificationFilter =
            " and AD_User_ID eq ${Get.arguments['notificationId']}";
        Get.arguments['notificationId'] = null;
      }
    }
    _dataAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/r_request?\$filter= R_Status_ID neq $closedTicketId and AD_Client_ID eq ${GetStorage().read('clientid')}${apiUrlFilter[filterCount]}$notificationFilter  and ($ticketFilter)$userFilter$dateStartFilter$dateEndFilter&\$skip=${(pagesCount.value - 1) * 100}&\$orderby= StartDate');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      _trx = TicketsJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      pagesTot.value = _trx.pagecount!;
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
      _dataAvailable.value = _trx != null;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> closeTicket(int index) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = jsonEncode({
      "TaskStatus": "X",
    });
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/r_request/${trx.records![index].id}');

    var response = await http.put(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      getTickets();
      //print("done!");
      //completeOrder(index);
    } else {
      //print(response.body);
      Get.snackbar(
        "Errore!",
        "Il Ticket non è stato chiuso",
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  Future<void> confirmTicket(int index) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = jsonEncode({
      "TaskStatus": "9",
    });
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/r_request/${trx.records![index].id}');

    var response = await http.put(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      getTickets();
      //print("done!");
      //completeOrder(index);
    } else {
      //print(response.body);
      Get.snackbar(
        "Error!".tr,
        "Ticket not confirmed".tr,
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
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
      projectName: "Risorse Umane",
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
