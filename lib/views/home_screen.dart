import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrtv_new_app_sl/viewModels/bottom_nav_controller.dart';
import 'package:mrtv_new_app_sl/views/audio_new_screen.dart';
import 'package:mrtv_new_app_sl/views/video_new_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final bottomNavController = Get.put(BottomNavController());
    final List<Widget> pages = [VideoNewScreen(), AudtioNewScreen()];
    return Obx(() {
      return Scaffold(
        backgroundColor: const Color.fromARGB(235, 252, 249, 234),
        appBar: AppBar(
          title: Image(
            height: MediaQuery.of(context).size.height / 4,
            width: MediaQuery.of(context).size.width / 4,
            image: NetworkImage(
              "https://upload.wikimedia.org/wikipedia/commons/b/bb/Mrtvchannellogo.png",
            ),
          ),
          // title: Text("MRTV"),
          backgroundColor: const Color.fromARGB(235, 252, 249, 234),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: bottomNavController.selectedIndex.value,
          onTap: bottomNavController.changeTab,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.video_collection),
              label: "Video News",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.radio),
              label: "Radio News",
            ),
          ],
        ),
        body: pages[bottomNavController.selectedIndex.value],
      );
    });
  }
}
