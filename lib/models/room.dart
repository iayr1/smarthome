import 'package:flutter/material.dart';

class Room {
  final int id;
  final String name;
  int activeDevices;
  final IconData iconData;
  final List<Color> gradient;

  Room({
    required this.id,
    required this.name,
    required this.activeDevices,
    required this.iconData,
    required this.gradient,
  });

  Room copyWith({
    int? id,
    String? name,
    int? activeDevices,
    IconData? iconData,
    List<Color>? gradient,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      activeDevices: activeDevices ?? this.activeDevices,
      iconData: iconData ?? this.iconData,
      gradient: gradient ?? this.gradient,
    );
  }
}