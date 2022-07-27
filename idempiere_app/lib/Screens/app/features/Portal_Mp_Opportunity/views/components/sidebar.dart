part of dashboard;

class _Sidebar extends StatelessWidget {
  _Sidebar({
    required this.data,
    Key? key,
  }) : super(key: key);

  final ProjectCardData data;

  final List<dynamic> list = GetStorage().read('permission');

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(kSpacing),
              child: ProjectCard(
                data: data,
              ),
            ),
            const Divider(thickness: 1),
            SelectionButton(
              initialSelected: 2,
              data: [
                SelectionButtonData(
                  activeIcon: EvaIcons.arrowBack,
                  icon: EvaIcons.arrowBackOutline,
                  label: "Dashboard",
                  visible: int.parse(list[0], radix: 16)
                          .toRadixString(2)
                          .padLeft(8, "0")
                          .toString()[1] ==
                      "1",
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "Ticket".tr,
                ),
                //Richieste di offerta
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "Opportunity".tr,
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "SalesOrder".tr,
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "Training and Course".tr,
                ),
                //Impianto
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "Maintenance".tr,
                ),
                //Impianti dettaglio
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "Anomaly".tr,
                ),
                //Scadenze
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "Invoice".tr,
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "Contract".tr,
                ),
                
              ],
              onSelected: (index, value) {
                //log("index : $index | label : ${value.label}");
                //Get.toNamed('/${value.label}');
                switch (index) {
                  case 0:
                    Get.offNamed('/Dashboard');

                    break;

                  case 1:
                    Get.offNamed('/TicketClientTicket');
                    break;
                  //Richieste di offerta
                  case 2:
                    Get.offNamed('/PortalMpOpportunity');
                    break;
                  
                  case 3:
                    Get.offNamed('/PortalMpSalesOrder');
                    break;
                  
                  case 4:
                    Get.offNamed('/PortalMpTrainingCourse');
                    break;
                  //Impianto
                  case 5:
                    Get.offNamed('/PortalMpMaintenanceMp');
                    break;
                  //Impianti dettaglio
                  case 6:
                    Get.offNamed('/PortalMpAnomaly');
                    break;
                  //Scadenze
                  case 7:
                    Get.offNamed('/PortalMpInvoice');
                    break;

                  case 8:
                    Get.offNamed('/PortalMpContract');
                    break;

                  default:
                }
              },
            ),
            const Divider(thickness: 1),
            const SizedBox(height: kSpacing * 2),
            /* UpgradePremiumCard(
              backgroundColor: Theme.of(context).canvasColor.withOpacity(.4),
              onPressed: () {},
            ), */
            const SizedBox(height: kSpacing),
          ],
        ),
      ),
    );
  }
}
