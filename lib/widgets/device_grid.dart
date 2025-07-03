import 'package:flutter/material.dart';
import '../models/device.dart';
import 'device_card.dart';

class DeviceGrid extends StatelessWidget {
  final List<Device> devices;
  final Function(int) onDeviceToggle;

  const DeviceGrid({
    Key? key,
    required this.devices,
    required this.onDeviceToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isTablet = screenWidth >= 768;
    final isDesktop = screenWidth >= 1024;

    int crossAxisCount;
    double spacing;
    double childAspectRatio;

    if (isDesktop) {
      crossAxisCount = 4;
      spacing = 20;
      childAspectRatio = 1.0;
    } else if (isTablet) {
      crossAxisCount = 3;
      spacing = 18;
      childAspectRatio = 1.05;
    } else {
      crossAxisCount = 2;
      spacing = 16;
      childAspectRatio = 1.1;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: devices.length,
      itemBuilder: (context, index) {
        return DeviceCard(
          device: devices[index],
          onToggle: () => onDeviceToggle(devices[index].id),
        );
      },
    );
  }
}