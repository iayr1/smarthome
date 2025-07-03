import 'package:flutter/material.dart';
import '../models/room.dart';
import '../models/device.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

class SmartHomeProvider extends ChangeNotifier {
  int _selectedRoomId = 1;
  bool _isCelsius = true;
  Weather? _weather;
  bool _isLoadingWeather = false;
  final WeatherService _weatherService = WeatherService();

  final List<Room> _rooms = [
    Room(
      id: 1,
      name: 'Living Room',
      activeDevices: 3,
      iconData: Icons.living,
      gradient: [Color(0xFF4FC3F7), Color(0xFF29B6F6)],
    ),
    Room(
      id: 2,
      name: 'Bedroom',
      activeDevices: 2,
      iconData: Icons.bed,
      gradient: [Color(0xFFBA68C8), Color(0xFF9C27B0)],
    ),
    Room(
      id: 3,
      name: 'Kitchen',
      activeDevices: 1,
      iconData: Icons.kitchen,
      gradient: [Color(0xFFFFB74D), Color(0xFFFF9800)],
    ),
    Room(
      id: 4,
      name: 'Bathroom',
      activeDevices: 1,
      iconData: Icons.bathroom,
      gradient: [Color(0xFF4DB6AC), Color(0xFF26A69A)],
    ),
  ];

  final Map<int, List<Device>> _devices = {
    1: [
      Device(id: 1, name: 'Smart Light', iconData: Icons.lightbulb, isOn: true, reading: '75%'),
      Device(id: 2, name: 'Air Conditioner', iconData: Icons.ac_unit, isOn: false, reading: '22°C'),
      Device(id: 3, name: 'Smart TV', iconData: Icons.tv, isOn: true, reading: 'Channel 5'),
      Device(id: 4, name: 'Ceiling Fan', iconData: Icons.mode_fan_off, isOn: false, reading: 'Speed 0'),
    ],
    2: [
      Device(id: 5, name: 'Bedside Lamp', iconData: Icons.lightbulb_outline, isOn: true, reading: '50%'),
      Device(id: 6, name: 'AC', iconData: Icons.ac_unit, isOn: false, reading: '24°C'),
      Device(id: 7, name: 'Smart Speaker', iconData: Icons.speaker, isOn: true, reading: 'Playing'),
    ],
    3: [
      Device(id: 8, name: 'Smart Fridge', iconData: Icons.kitchen, isOn: true, reading: '4°C'),
      Device(id: 9, name: 'Coffee Maker', iconData: Icons.coffee, isOn: false, reading: 'Ready'),
      Device(id: 10, name: 'Dishwasher', iconData: Icons.local_laundry_service, isOn: false, reading: 'Clean'),
    ],
    4: [
      Device(id: 11, name: 'Smart Mirror', iconData: Icons.four_g_plus_mobiledata_sharp, isOn: false, reading: 'Standby'),
      Device(id: 12, name: 'Water Heater', iconData: Icons.hot_tub, isOn: true, reading: '45°C'),
      Device(id: 13, name: 'Exhaust Fan', iconData: Icons.air, isOn: false, reading: 'Off'),
    ],
  };

  int get selectedRoomId => _selectedRoomId;
  bool get isCelsius => _isCelsius;
  Weather? get weather => _weather;
  bool get isLoadingWeather => _isLoadingWeather;
  List<Room> get rooms => _rooms;
  List<Device> get selectedRoomDevices => _devices[_selectedRoomId] ?? [];

  double get energyUsage {
    int totalActiveDevices = 0;
    _devices.values.forEach((devices) {
      totalActiveDevices += devices.where((device) => device.isOn).length;
    });
    return totalActiveDevices * 2.5;
  }

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  void selectRoom(int roomId) {
    _selectedRoomId = roomId;
    notifyListeners();
  }

  void toggleDevice(int deviceId) {
    for (var devices in _devices.values) {
      final deviceIndex = devices.indexWhere((device) => device.id == deviceId);
      if (deviceIndex != -1) {
        devices[deviceIndex].isOn = !devices[deviceIndex].isOn;

        final roomIndex = _rooms.indexWhere((room) => room.id == _selectedRoomId);
        if (roomIndex != -1) {
          _rooms[roomIndex].activeDevices = devices.where((device) => device.isOn).length;
        }

        notifyListeners();
        break;
      }
    }
  }

  void toggleTemperatureUnit() {
    _isCelsius = !_isCelsius;
    notifyListeners();
  }

  Future<void> fetchWeather() async {
    _isLoadingWeather = true;
    notifyListeners();

    try {
      _weather = await _weatherService.getCurrentWeather();
    } catch (e) {
      _weather = Weather(
        temperature: 25.0,
        condition: 'Sunny',
        iconCode: '01d',
        humidity: 60,
        windSpeed: 5.2,
      );
    }

    _isLoadingWeather = false;
    notifyListeners();
  }
}