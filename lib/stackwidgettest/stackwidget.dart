import 'package:flutter/material.dart';

class Stackwidget extends StatelessWidget {
  const Stackwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stack GridView")),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 6, // You can set this to any number
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two items per row
          crossAxisSpacing: 16,
          mainAxisSpacing: 40, // more space for overlapping avatar
          childAspectRatio: 0.9,
        ),
        itemBuilder: (context, index) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Background Container
              Positioned(
                top: 40,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Center(
                      child: Text(
                        "This is the first test.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              // Avatar on top
              const Positioned(
                top: 0,
                left:
                    40, // adjust to center on container width (Grid items are narrower)
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    "https://images.rawpixel.com/image_png_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIzLTAxL3JtNjA5LXNvbGlkaWNvbi13LTAwMi1wLnBuZw.png",
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
