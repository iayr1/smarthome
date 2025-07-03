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
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
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