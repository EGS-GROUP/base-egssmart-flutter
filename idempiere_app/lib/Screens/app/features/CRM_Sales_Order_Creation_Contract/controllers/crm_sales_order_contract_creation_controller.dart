part of dashboard;

class CRMSalesOrderContractCreationController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  //late MPMaintainContractJSON _trx;
  //var _hasMailSupport = false;
  // ignore: unused_field
  late ProductJson _trx;
  late PaymentTermsJson pTerms;
  late PaymentRuleJson pRules;

  var bpLocationId = "0".obs;
  var paymentTermId = "0".obs;
  var paymentRuleId = "K".obs;

  List<ProductCheckout> productList = [];
  late SalesOrderDefaultsJson defValues;

  // ignore: prefer_typing_uninitialized_variables
  var adUserId;

  var value = "Tutti".obs;

  var filterCount = 0.obs;
  var counter = 0.obs;
  var total = 0.0.obs;
  int businessPartnerId = 0;
  int technicianId = 0;
  String date = DateTime.now().toString().substring(0, 10);
  var businessPartnerName = "".obs;
  // ignore: prefer_final_fields
  var _dataAvailable = false.obs;

  var searchFieldController = TextEditingController();
  var searchFilterValue = "".obs;

  late List<Types> dropDownList;
  var dropdownValue = "1".obs;

  var nameFieldController = TextEditingController();
  var ivaFieldController = TextEditingController();
  var addressFieldController = TextEditingController();
  var technicianFieldController =
      TextEditingController(text: GetStorage().read('user'));
  var orgFieldController =
      TextEditingController(text: GetStorage().read('organizationname'));
  int orgId = int.parse(GetStorage().read('organizationid'));
  var docFieldController = TextEditingController(text: "");
  var docId = 0;
  var prodFieldController = TextEditingController(text: "");
  //var docId = 0;

  var descriptionFieldController = TextEditingController();
  var productNameFieldController = TextEditingController();
  var productDescriptionFieldController = TextEditingController();
  var productQtyFieldController = TextEditingController(text: "1.0");
  var productPriceFieldController = TextEditingController(text: "");

  var pTermAvailable = false.obs;

  var pRuleAvailable = false.obs;

  var filters = [
    "1. Business Partner",
    "2. Date and Technician",
    "3. Checkout",
    "4. Payment",
    "5. idk"
  ];

  final json = {
    "types": [
      {"id": "1", "name": "Business Partner"},
      {"id": "2", "name": "N° Doc"},
      {"id": "3", "name": "Phone N°"},
    ]
  };

  updateCounter() {
    counter.value = productList.length;
  }

  updateTotal() {
    num tot = 0;
    if (productList.isNotEmpty) {
      for (var i = 0; i < productList.length; i++) {
        tot = tot + (productList[i].cost * productList[i].qty);
      }
    }

    total.value = double.parse(tot.toString());
  }

  List<Types>? getTypes() {
    var dJson = TypeJson.fromJson(json);

    return dJson.types;
  }

  Future<List<PRecords>> getAllProducts() async {
    //print(response.body);
    const filename = "products";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');

    var jsondecoded = jsonDecode(await file.readAsString());
    var jsonResources = ProductJson.fromJson(jsondecoded);
    //print(jsonResources.rowcount);
    return jsonResources.records!;

    //print(list[0].eMail);

    //print(json.);
  }

  Future<void> getSalesOrderDefaultValues() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mobile_order_defaults_v?\$filter= C_BPartner_ID eq $businessPartnerId and AD_Client_ID eq ${GetStorage().read("clientid")}');
    if (businessPartnerId != 0) {
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authorization,
        },
      );
      if (response.statusCode == 200) {
        //print(response.body);
        defValues = SalesOrderDefaultsJson.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)));
        //getPriceListVersionID();
      } else {
        if (kDebugMode) {
          print(response.body);
        }
      }
    }
  }

  Future<void> createMaintainContract() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    // ignore: unused_local_variable
    var msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "C_BPartner_ID": {"id": businessPartnerId},
      "DateNextRun": {"id": date},
      "AD_User_ID": {"id": technicianId},
    });

    var url =
        Uri.parse('$protocol://$ip/api/v1/windows/preventive-maintenance/');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 201) {
      //print(response.body);
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  @override
  void onInit() {
    dropDownList = getTypes()!;
    super.onInit();
    getPaymentRules();
    getPaymentTerms();
    //getProductLists();
    getSalesOrderDocTypes();
    //getContracts();
    //getADUserID();
    //adUserId = GetStorage().read('userId');
  }

  changeFilterPlus() {
    if (filterCount.value < 3) {
      switch (filterCount.value) {
        case 0:
          filterCount.value++;
          value.value = filters[filterCount.value];

          break;
        case 2:
          filterCount.value++;
          value.value = filters[filterCount.value];

          break;
        default:
          filterCount.value++;
          value.value = filters[filterCount.value];
          break;
      }

      /* filterCount.value++;
      value.value = filters[filterCount.value]; */
    }
    //print(object);

    //value.value = filters[filterCount];
  }

  changeFilterMinus() {
    if (filterCount.value > 0) {
      filterCount.value--;
      value.value = filters[filterCount.value];
    }

    //value.value = filters[filterCount];
  }

  get displayStringForOption => _displayStringForOption;
  get displayProdStringForOption => _displayProdStringForOption;
  get displayTechStringForOption => _displayTechStringForOption;
  get displayOrgStringForOption => _displayOrgStringForOption;
  get displayDocStringForOption => _displayDocStringForOption;

  static String _displayStringForOption(BPRecords option) => option.name!;
  static String _displayProdStringForOption(PRecords option) => option.name!;
  static String _displayTechStringForOption(CRecords option) => option.name!;
  static String _displayOrgStringForOption(ORecords option) => option.name!;
  static String _displayDocStringForOption(DTRecords option) => option.name!;

  TextEditingController countryCodeFieldController = TextEditingController();
  TextEditingController vatCodeFieldController = TextEditingController();

  createBusinessPartner() async {
    Get.defaultDialog(
      title: 'Create Business Partner'.tr,
      content: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: TextField(
              //maxLines: 5,
              readOnly: true,
              controller: countryCodeFieldController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.badge),
                border: const OutlineInputBorder(),
                labelText: 'Country Code'.tr,
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            child: TextField(
              //maxLines: 5,
              readOnly: true,
              controller: vatCodeFieldController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.badge),
                border: const OutlineInputBorder(),
                labelText: 'VAT Code'.tr,
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
          ),
        ],
      ),
      onCancel: () {},
      onConfirm: () async {
        final ip = GetStorage().read('ip');
        String authorization = 'Bearer ${GetStorage().read('token')}';
        final protocol = GetStorage().read('protocol');
        var url =
            Uri.parse('$protocol://$ip/api/v1/processes/createbpbyvatapirest');
        var msg = jsonEncode({
          "CountryCode": countryCodeFieldController.text,
          "VATNumber": vatCodeFieldController.text
        });
        //print(msg);
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
          var json = jsonDecode(response.body);
          Get.back();
          //print(response.body);
          if (json["IsError"] == false) {
            getBusinessPartner(vatCodeFieldController.text);
            Get.snackbar(
              "Done!".tr,
              "Business Partner has been created".tr,
              icon: const Icon(
                Icons.done,
                color: Colors.green,
              ),
            );
          } else {
            Get.snackbar(
              "Error!".tr,
              "Business Partner not created".tr,
              icon: const Icon(
                Icons.error,
                color: Colors.red,
              ),
            );
          }
        } else {
          if (kDebugMode) {
            print(response.body);
          }
          Get.snackbar(
            "Error!".tr,
            "Business Partner not created".tr,
            icon: const Icon(
              Icons.error,
              color: Colors.red,
            ),
          );
        }
      },
    );
  }

  Future<List<BPRecords>> getAllBPs() async {
    //await getBusinessPartner();
    //print(response.body);
    const filename = "businesspartner";
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$filename.json');
    var jsondecoded = jsonDecode(file.readAsStringSync());

    var jsonbps = BusinessPartnerJson.fromJson(jsondecoded);

    return jsonbps.records!;

    //print(list[0].eMail);

    //print(json.);
  }

  getBusinessPartner(String vat) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_bpartner?\$filter= C_BPartner_ID eq $businessPartnerId and AD_Client_ID eq ${GetStorage().read('clientid')}');

    if (vat != "0") {
      url = Uri.parse(
          '$protocol://$ip/api/v1/models/c_bpartner?\$filter= LIT_TaxID eq \'$vat\' and AD_Client_ID eq ${GetStorage().read('clientid')}');
    }
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      var json = BusinessPartnerJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      nameFieldController.text = json.records![0].name!;
      ivaFieldController.text = (json.records![0].litTaxID) ?? "";
      getBusinessPartnerLocation();
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  getBusinessPartnerLocation() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/c_bpartner_location?\$filter= C_BPartner_ID eq $businessPartnerId and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      var json = BusinessPartnerLocationJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      addressFieldController.text =
          json.records![0].cLocationID?.identifier ?? "";
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<List<CRecords>> getAllSalesReps() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/ad_user');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var jsondecoded = jsonDecode(response.body);

      var jsonContacts = ContactsJson.fromJson(jsondecoded);

      return jsonContacts.records!;
    } else {
      throw Exception("Failed to load sales reps");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  Future<List<ORecords>> getAllOrgs() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/ad_org?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var jsondecoded = jsonDecode(response.body);

      var jsonOrgs = ContractOrganizationJSON.fromJson(jsondecoded);

      return jsonOrgs.records!;
    } else {
      throw Exception("Failed to load sales reps");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  Future<List<DTRecords>> getSalesOrderDocTypes() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_DocType?\$filter= DocBaseType eq \'SOO\' and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(utf8.decode(response.bodyBytes));
      //var jsondecoded = jsonDecode(response.body);

      var jsonDocs = DocumentTypeJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      jsonDocs.records!.retainWhere((element) =>
          element.aDOrgID?.identifier == '*' || element.aDOrgID?.id == orgId);

      return jsonDocs.records!;
    } else {
      throw Exception("Failed to load sales reps");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  Future<void> getPaymentRules() async {
    pRuleAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/AD_Ref_List?\$filter= AD_Reference_ID eq 195');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      //_trx = ProductListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      pRules =
          PaymentRuleJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      pRuleAvailable.value = true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getPaymentTerms() async {
    pTermAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_PaymentTerm?\$filter= AD_Client_ID eq ${GetStorage().read("clientid")}');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      /* if (kDebugMode) {
        print(response.body);
      } */
      //_trx = ProductListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      pTerms = PaymentTermsJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      for (var element in pTerms.records!) {
        if (element.isDefault == true) {
          paymentTermId.value = element.id!.toString();
        }
      }
      pTermAvailable.value = true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getDefaultPaymentTermsFromBP() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_BPartner?\$filter= C_BPartner_ID eq $businessPartnerId and AD_Client_ID eq ${GetStorage().read("clientid")}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(utf8.decode(response.bodyBytes));
      //_trx = ProductListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      var json = BusinessPartnerJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      if (json.rowcount! > 0) {
        if (json.records![0].cPaymentTermID != null) {
          paymentTermId.value = json.records![0].cPaymentTermID!.id!.toString();
        }
      }
      //print(trx.rowcount);
      //print(response.body);
      //print(paymentTermId);
      pTermAvailable.value = true;
      // ignore: unnecessary_null_comparison
      //pTermAvailable.value = pTerm != null;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getLocationFromBP() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_BPartner_Location?\$filter= C_BPartner_ID eq $businessPartnerId and AD_Client_ID eq ${GetStorage().read("clientid")}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(utf8.decode(response.bodyBytes));
      //_trx = ProductListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      var bpLocation = BusinessPartnerLocationJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      if (bpLocation.rowcount! > 0) {
        if (bpLocation.records![0].id != null) {
          bpLocationId.value = bpLocation.records![0].id.toString();
        }
      }
      //print(trx.rowcount);
      //print(response.body);
      //print(paymentTermId);
      //bpLocationAvailable.value = true;
      // ignore: unnecessary_null_comparison
      //pTermAvailable.value = pTerm != null;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> createSalesOrder() async {
    Get.back();
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/windows/sales-order');

    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    //print(formattedDate);
    List<Map<String, Object>> list = [];

    for (var element in productList) {
      list.add({
        "M_Product_ID": {"id": element.id},
        "qtyEntered": element.qty
      });
    }

    var msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "M_Warehouse_ID": {"id": GetStorage().read("warehouseid")},
      "C_BPartner_ID": {"id": businessPartnerId},
      "C_BPartner_Location_ID": {"id": bpLocationId.value},
      "Bill_BPartner_ID": {"id": businessPartnerId},
      "Bill_Location_ID": {"id": defValues.records![0].cBPartnerLocationID!.id},
      "Revision": defValues.records![0].revision,
      "AD_User_ID": defValues.records![0].aDUserID!.id,
      "Bill_User_ID": defValues.records![0].billUserID!.id,
      "C_DocTypeTarget_ID": {"id": int.parse(dropdownValue.value)},
      "DateOrdered": "${formattedDate}T00:00:00Z",
      "DatePromised": "${formattedDate}T00:00:00Z",
      "LIT_Revision_Date": "${formattedDate}T00:00:00Z",
      "DeliveryRule": defValues.records![0].deliveryRule!.id,
      "DeliveryViaRule": defValues.records![0].deliveryViaRule!.id,
      "FreightCostRule": defValues.records![0].freightCostRule!.id,
      "PriorityRule": defValues.records![0].priorityRule!.id,
      "InvoiceRule": defValues.records![0].invoiceRule!.id,
      "M_PriceList_ID": defValues.records![0].mPriceListID!.id,
      "SalesRep_ID": defValues.records![0].salesRepID!.id,
      "C_Currency_ID": defValues.records![0].cCurrencyID!.id,
      "C_PaymentTerm_ID": {"id": int.parse(paymentTermId.value)},
      "PaymentRule": {"id": paymentRuleId.value},
      "order-line".tr: list,
    });

    var response = await http.post(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 201) {
      //print(response.body);

      var json = jsonDecode(utf8.decode(response.bodyBytes));

      Get.find<CRMSalesOrderController>().getSalesOrders();
      Get.back();
      //print("done!");
      Get.snackbar(
        "${json["DocumentNo"]}",
        "The record has been created".tr,
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );

      /* cOrderId = json["id"];
      if (cOrderId != 0) {
        createSalesOrderLine();
      } */
    } else {
      if (kDebugMode) {
        print(response.body);
        Get.snackbar(
          "Error!".tr,
          "Record not updated".tr,
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ),
        );
      }
    }
  }

  /* Future<void> getProductLists() async {
    _dataAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/lit_product_list_v?\$filter= PriceStd neq null and IsSelfService eq Y and AD_Client_ID eq ${GetStorage().read("clientid")}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      /* if (kDebugMode) {
        print(response.body);
      } */
      _trx =
          ProductListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
      _dataAvailable.value = _trx != null;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  } */

  bool get dataAvailable => _dataAvailable.value;
  //String get value => _value.toString();

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
      projectName: "iDempiere APP",
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
