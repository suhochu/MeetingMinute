import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingminutes52/models/meeting_resource_controller.dart';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;
  final bool isEdit;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    required this.onClicked,
    required this.isEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(children: [
        buildImage(),
        Positioned(
          bottom: 0,
          right: 4,
          child: buildEditIcon(const Color(0xffFF5722)),
        ),
      ]),
    );
  }

  Widget buildImage() {
    ImageProvider image;
    if (imagePath == 'assets/images/princessjju.png') {
      image = const AssetImage('assets/images/princessjju.png');
    } else {
      image = FileImage(File(imagePath));
    }

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          width: 180,
          height: 180,
          child: InkWell(
            onTap: onClicked,
          ),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) =>
      buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            isEdit ? Icons.camera : Icons.edit,
            color: Colors.white,
            size: 25,
          ),
        ),
      );

  buildCircle({
    required Color color,
    required double all,
    required Widget child,
  }) =>
      ClipOval(
        child: Container(
          color: color,
          child: child,
          padding: EdgeInsets.all(all),
        ),
      );
}

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);
  final String text;
  final VoidCallback onClicked;

  @override
  Widget build(BuildContext context) =>
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          onPrimary: Colors.white,
          primary: const Color(0xffFF5722),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
        child: Text(text),
        onPressed: onClicked,
      );
}

class NumbersWidget extends StatelessWidget {
  NumbersWidget({Key? key}) : super(key: key);
  final controller = Get.put(MeetingSourceController());

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildButton(context, controller.projects.length.toString(), 'Projects'),
        buildDivider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: buildButton(context, '35', 'Meeting Minutes'),
        ),
        buildDivider(),
        buildButton(context, '50', 'Todos'),
      ],);
  }

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
          padding: const EdgeInsets.symmetric(vertical: 4),
          onPressed: null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                value,
                style:
                const TextStyle(fontWeight: FontWeight.bold,
                    color: Colors.black54,
                    fontSize: 24),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                text,
                style:
                const TextStyle(fontWeight: FontWeight.bold,
                    color: Colors.black54,
                    fontSize: 14),
              )
            ],
          ));

  Widget buildDivider() =>
      const SizedBox(
        height: 24,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: VerticalDivider(),
        ),
      );
}
