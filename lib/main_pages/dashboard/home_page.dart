import 'package:asset_management_local/provider/main_providers/asset_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../helpers/global_helper.dart';
import '../../models/dashboard_model/count_details.dart';
import '../../models/dashboard_model/notification_details.dart';
import 'package:asset_management_local/provider/other_providers/bool_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    BoolProvider boolProvider = Provider.of<BoolProvider>(context);
    AssetProvider countProvider =
        Provider.of<AssetProvider>(context, listen: false);

    return Center(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: boolProvider.isDarkTheme
                    ? const Color.fromRGBO(16, 18, 33, 1)
                    : const Color(0xfff3f1ef),
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.772,
                  height: MediaQuery.of(context).size.height * 0.26,
                  child: Card(
                    margin: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    color: const Color(0xffd4c1ab),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: FutureBuilder<List<CountDetails>>(
                          future: countProvider.fetchCountDetails(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text(
                                'Unable to Fetch the Data',
                                style: GoogleFonts.ubuntu(
                                    textStyle: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                )),
                              ));
                            } else {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  countProvider.countDetailsList.isNotEmpty
                                      ? getAssetOverallDetailsUI(
                                          MediaQuery.of(context).size,
                                          "Total Assets",
                                          Icons.widgets_rounded,
                                          countProvider
                                              .countDetailsList[0].assetCounts
                                              .toString())
                                      : getAssetOverallDetailsUI(
                                          MediaQuery.of(context).size,
                                          "Total Assets",
                                          Icons.widgets_rounded,
                                          "0"),
                                  countProvider.countDetailsList.isNotEmpty
                                      ? getAssetOverallDetailsUI(
                                          MediaQuery.of(context).size,
                                          "Total Users",
                                          Icons.person_3_rounded,
                                          countProvider
                                              .countDetailsList[0].userCounts
                                              .toString())
                                      : getAssetOverallDetailsUI(
                                          MediaQuery.of(context).size,
                                          "Total Users",
                                          Icons.person_3_rounded,
                                          "0"),
                                  countProvider.countDetailsList.isNotEmpty
                                      ? getAssetOverallDetailsUI(
                                          MediaQuery.of(context).size,
                                          "Procurement Requests",
                                          Icons.open_with_rounded,
                                          countProvider.countDetailsList[0]
                                              .procurementCounts
                                              .toString())
                                      : getAssetOverallDetailsUI(
                                          MediaQuery.of(context).size,
                                          "Procurement Requests",
                                          Icons.open_with_rounded,
                                          countProvider.countDetailsList[0]
                                              .procurementCounts
                                              .toString()),
                                  countProvider.countDetailsList.isNotEmpty
                                      ? getAssetOverallDetailsUI(
                                          MediaQuery.of(context).size,
                                          "Service Requests",
                                          Icons.miscellaneous_services_rounded,
                                          countProvider
                                              .countDetailsList[0].serviceCounts
                                              .toString())
                                      : getAssetOverallDetailsUI(
                                          MediaQuery.of(context).size,
                                          "Service Requests",
                                          Icons.miscellaneous_services_rounded,
                                          "0"),
                                ],
                              );
                            }
                          }),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [getHistoryUI(), getNotificationUI()],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getAssetOverallDetailsUI(
      size, String title, IconData iconData, String count) {
    double titleTextSizeMultiplier = 0.07;
    if (title.length > 13) {
      titleTextSizeMultiplier = 0.1;
    }
    return SizedBox(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(8.0, size.height * 0.038, 8, 8),
            child: Container(
                width: size.width * 0.12,
                decoration: BoxDecoration(
                    color: const Color(0xfff8f4f0),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 8),
                      width: size.width * titleTextSizeMultiplier,
                      child: Text(
                        title,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ubuntu(
                            textStyle: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )),
                      ),
                    ),
                    Text(
                      count,
                      style: GoogleFonts.ubuntu(
                          textStyle: const TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      )),
                    )
                  ],
                )),
          ),
          Positioned(
            top: 5,
            left: 20,
            child: Container(
              height: size.height * 0.05,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(25),
                  color: const Color(0XFFE7693B)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
                child: Icon(iconData),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getNotificationUI() {
    AssetProvider notificationProvider =
        Provider.of<AssetProvider>(context, listen: false);

    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.55,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xff757575),
        borderRadius: BorderRadius.circular(15),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 15, 8, 8),
              child: Text(
                "Notifications",
                style: GlobalHelper.textStyle(
                  const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            FutureBuilder<List<NotificationDetails>>(
              future: notificationProvider.fetchNotificationDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        8,
                        MediaQuery.of(context).size.height * 0.15,
                        8,
                        8,
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off_rounded,
                            color: Colors.white,
                          ),
                          Text(
                            'No new notifications',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return buildNotificationContentUI(
                          Icons.info_rounded,
                          snapshot.data!.reversed
                              .toList()[index]
                              .message
                              .toString(),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          8,
                          MediaQuery.of(context).size.height * 0.15,
                          8,
                          8,
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_off_rounded,
                              color: Colors.white,
                            ),
                            Text(
                              'No new notifications',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget buildNotificationContentUI(IconData icon, String notificationTitle) {
    double notificationWidth = 0.188;
    double notificationFontSize = 14;
    double betweenSpace = 0.006;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.all(10),
        color: const Color(0xff686868),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 1, 8, 1),
                  child: Icon(
                    icon,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * betweenSpace,
                ),
                const Padding(
                  padding: EdgeInsets.all(0.0),
                  child: VerticalDivider(
                    thickness: 1,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width *
                      (betweenSpace + 0.002),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * notificationWidth,
                  child: Text(
                    notificationTitle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                    style: GlobalHelper.textStyle(TextStyle(
                        fontSize: notificationFontSize,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getHistoryUI() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.43,
      height: MediaQuery.of(context).size.height * 0.55,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: const Color(0xffb4d4db),
          borderRadius: BorderRadius.circular(15)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 15, 8, 8),
              child: Text(
                "History",
                style: GlobalHelper.textStyle(const TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w700)),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  8,
                  MediaQuery.of(context).size.height * 0.15,
                  8,
                  8,
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history_rounded,
                      color: Colors.black,
                    ),
                    Text(
                      'History not found',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildHistoryUI(
      IconData icon, String content, String date, String time) {
    double historyWidth = 0.23;
    double historyFontSize = 14;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.all(10),
        color: const Color(0xffa4cbd7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.black,
                ),
                const Padding(
                  padding: EdgeInsets.all(0.0),
                  child: VerticalDivider(
                    thickness: 1,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * historyWidth,
                  child: Text(
                    content,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: GlobalHelper.textStyle(TextStyle(
                        color: Colors.black,
                        fontSize: historyFontSize,
                        fontWeight: FontWeight.w500)),
                  ),
                ),
                Text(
                  date,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: GlobalHelper.textStyle(TextStyle(
                      fontSize: historyFontSize + 1,
                      color: Colors.black,
                      fontWeight: FontWeight.w400)),
                ),
                Text(
                  time,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: GlobalHelper.textStyle(TextStyle(
                      fontSize: historyFontSize + 1,
                      color: Colors.black,
                      fontWeight: FontWeight.w400)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
