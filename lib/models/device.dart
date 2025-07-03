import 'package:flutter/material.dart';

class Device {
  final int id;
  final String name;
  final IconData iconData;
  bool isOn;
  final String reading;

  Device({
    required this.id,
    required this.name,
    required this.iconData,
    required this.isOn,
    required this.reading,
  });

  Device copyWith({
    int? id,
    String? name,
    IconData? iconData,
    bool? isOn,
    String? reading,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      iconData: iconData ?? this.iconData,
      isOn: isOn ?? this.isOn,
      reading: reading ?? this.reading,
    );
  }
}