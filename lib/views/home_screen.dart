import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrtv_new_app_sl/viewModels/bottom_nav_controller.dart';
import 'package:mrtv_new_app_sl/viewModels/language/language_controller/language_controller.dart';
import 'package:mrtv_new_app_sl/views/audio/audio_view/audio_new_screen.dart';
import 'package:mrtv_new_app_sl/views/local/local_view/local_view_screen.dart';
import 'package:mrtv_new_app_sl/views/setting/app_setting_screen.dart';
import 'package:mrtv_new_app_sl/views/video/video_view/video_new_screen.dart';
import 'package:mrtv_new_app_sl/views/world/world_view/world_new_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LanguageController languageController = Get.put((LanguageController()));
  @override
  Widget build(BuildContext context) {
    final bottomNavController = Get.put(BottomNavController());
    final List<Widget> pages = [
      VideoNewScreen(),
      AudtioNewScreen(),
      WorldNewScreen(),
      LocalViewScreen(),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Image(
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width / 4,
          image: NetworkImage(
            "https://upload.wikimedia.org/wikipedia/commons/b/bb/Mrtvchannellogo.png",
          ),
        ),
        // title: Text("MRTV"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.of(context).push(
        //         MaterialPageRoute(builder: (context) => AppSettingScreen()),
        //       );
        //     },
        //     icon: Icon(Icons.settings),
        //   ),
        // ],
      ),
      bottomNavigationBar: Obx(() {
        int selected = bottomNavController.selectedIndex.value;
        return BottomNavigationBar(
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          currentIndex: selected,
          onTap: (index) {
            if (index == 4) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AppSettingScreen()),
              );
            } else {
              bottomNavController.changeTab(index);
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Container(
                width: MediaQuery.of(context).size.width / 5,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color:
                          selected == 0
                              ? Colors.blueAccent
                              : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
                padding: EdgeInsets.only(top: 6),
                child: Icon(Icons.video_collection),
              ),
              label: 'video_news'.tr,
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: MediaQuery.of(context).size.width / 5,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color:
                          selected == 1
                              ? Colors.blueAccent
                              : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
                padding: EdgeInsets.only(top: 6),
                child: Icon(Icons.radio),
              ),
              label: "radio_news".tr,
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: MediaQuery.of(context).size.width / 5,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color:
                          selected == 2
                              ? Colors.blueAccent
                              : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
                padding: EdgeInsets.only(top: 6),
                child: Icon(Icons.travel_explore),
              ),
              label: "world_news".tr,
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: MediaQuery.of(context).size.width / 5,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color:
                          selected == 3
                              ? Colors.blueAccent
                              : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
                padding: EdgeInsets.only(top: 6),
                child: Icon(Icons.location_city),
              ),
              label: "local_news".tr,
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: MediaQuery.of(context).size.width / 5, // divide by 5 now
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color:
                          selected == 4
                              ? Colors.blueAccent
                              : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
                padding: EdgeInsets.only(top: 6),
                child: Icon(Icons.settings),
              ),
              label: "setting".tr, // or just 'Settings'
            ),
          ],
        );
      }),

      body: Obx(() {
        return pages[bottomNavController.selectedIndex.value];
      }),
    );
  }
}
