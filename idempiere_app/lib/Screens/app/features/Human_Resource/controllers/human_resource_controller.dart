part of dashboard;

class HumanResourceController extends GetxController {
  var employeePresenceAvailable = false.obs;

  EmployeePresenceJSON employeePresence = EmployeePresenceJSON(records: []);

  int employeeLatenesses = 0;

  int employeeNonAttendances = 0;

  @override
  void onInit() {
    super.onInit();
    getEmployeesPresence();
  }

  Future<void> getEmployeesPresence() async {
    employeePresenceAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/lit_empl_presence_v');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      employeePresence = EmployeePresenceJSON.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      for (var element in employeePresence.records!) {
        if (element.presente == 'ASSENTE') {
          employeeNonAttendances++;
        }
        if (element.presente == 'PRESENTE' && (element.qty ?? 0) < 8) {
          employeeLatenesses++;
        }
      }
      employeePresenceAvailable.value = true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  // Data
  // ignore: library_private_types_in_public_api
  _Profile getProfil() {
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
          Get.toNamed('/Lead');
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
        seeAllFunction: () {
          Get.toNamed('/Opportunity');
        },
        addFunction: () {
          //Get.toNamed('/createLead');
          log('hallooooo');
        },
        title: "Opportunità",
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
        seeAllFunction: () {
          Get.toNamed('/Contatti');
        },
        addFunction: () {},
        title: "Contatti Business Partner",
        dueDay: 1,
        totalComments: 50,
        totalContributors: 34,
        type: TaskType.inProgress,
        profilContributors: [
          const AssetImage(ImageRasterPath.avatar5),
          const AssetImage(ImageRasterPath.avatar3),
          const AssetImage(ImageRasterPath.avatar4),
          const AssetImage(ImageRasterPath.avatar2),
        ],
      ),
      TaskCardData(
        seeAllFunction: () {
          Get.toNamed('/Clienti');
        },
        addFunction: () {
          //Get.toNamed('/createLead');
          log('hallooooo');
        },
        title: "Clienti BP",
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
        seeAllFunction: () {
          Get.toNamed('/Task&Appuntamenti');
        },
        addFunction: () {
          //Get.toNamed('/createLead');
          log('hallooooo');
        },
        title: "Task e Appuntamenti",
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
        seeAllFunction: () {
          Get.toNamed('/Offerte');
        },
        addFunction: () {
          //Get.toNamed('/createLead');
          log('hallooooo');
        },
        title: "Offerte",
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
        seeAllFunction: () {
          Get.toNamed('/Fattura');
        },
        addFunction: () {
          //Get.toNamed('/createLead');
          log('hallooooo');
        },
        title: "Fatture di Vendita",
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
        seeAllFunction: () {
          Get.toNamed('/Incassi');
        },
        addFunction: () {
          //Get.toNamed('/createLead');
          log('hallooooo');
        },
        title: "Incassi",
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
        seeAllFunction: () {
          Get.toNamed('/Provvigioni');
        },
        addFunction: () {
          //Get.toNamed('/createLead');
          log('hallooooo');
        },
        title: "Provvigioni",
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
