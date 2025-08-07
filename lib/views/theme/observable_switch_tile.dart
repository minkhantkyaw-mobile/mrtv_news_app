import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget ObserableSwitchTile({
  required IconData icon,
  required String title,
  required bool value,
  required Function(bool) onChanged,
}) {
  return Obx(
    () => SwitchListTile(
      secondary: Icon(icon),
      title: Text(title),
      value: value,
      onChanged: onChanged,
    ),
  );
}
