import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;

class DownloadController extends GetxController {
  var downloading = false.obs;
  var progress = 0.0.obs;

  Future<String> getDownloadPath(String fileName) async {
    if (Platform.isAndroid) {
      // This gives you /storage/emulated/0/Download (public)
      final directory = Directory('/storage/emulated/0/Download');
      if (await directory.exists()) {
        return p.join(directory.path, fileName);
      } else {
        throw Exception("Download directory doesn't exist");
      }
    } else {
      final dir = await getApplicationDocumentsDirectory();
      return p.join(dir.path, fileName);
    }
  }

  Future<void> downloadFile(String url, String fileName) async {
    try {
      downloading.value = true;
      print(Platform.isAndroid);

      // Request permission on Android
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final sdkInt = androidInfo.version.sdkInt;

        late PermissionStatus status;

        if (sdkInt >= 33) {
          // Android 13+
          status = await Permission.videos.request();
        } else if (sdkInt >= 30) {
          // Android 11-12
          status = await Permission.manageExternalStorage.request();
        } else {
          // Android 10 or lower
          status = await Permission.storage.request();
        }

        if (!status.isGranted) {
          Get.snackbar("Permission", "Storage permission is required");
          print("Permission status: ${status.toString()}");

          return;
        }
      }

      final savePath = await getDownloadPath(fileName);
      Get.dialog(_DownloadProgressDialog());

      await Dio().download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            progress.value = received / total;
          }
        },
      );
      // print(savePath);
      Get.snackbar("Download Complete", "Saved to $savePath");
    } catch (e) {
      Get.snackbar("Download Failed", e.toString());
    } finally {
      downloading.value = false;
    }
  }
}

class _DownloadProgressDialog extends StatelessWidget {
  final DownloadController c = Get.find();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final percent = (c.progress.value * 100).toStringAsFixed(0);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Downloading...", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              LinearProgressIndicator(value: c.progress.value),
              const SizedBox(height: 10),
              Text("$percent%"),
            ],
          );
        }),
      ),
    );
  }
}
