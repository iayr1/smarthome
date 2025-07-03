// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/smart_home_provider.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/room_card.dart';
import '../widgets/device_grid.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SmartHomeProvider>().fetchWeather();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 24),
                _buildDashboard(),
                SizedBox(height: 32),
                _buildRoomsSection(),
                SizedBox(height: 24),
                _buildDevicesSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<SmartHomeProvider>(
      builder: (context, provider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.greeting,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  'Welcome to your smart home',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => provider.toggleTemperatureUnit(),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  provider.isCelsius ? Icons.thermostat : Icons.ac_unit,
                  color: Color(0xFF3B82F6),
                  size: 24,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDashboard() {
    return Consumer<SmartHomeProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            Expanded(
              child: DashboardCard(
                title: 'Weather',
                value: provider.weather?.getTemperatureString(provider.isCelsius) ?? '--°C',
                subtitle: provider.weather?.condition ?? 'Loading...',
                icon: Icons.wb_sunny,
                gradient: [Color(0xFFFFEB3B), Color(0xFFFF9800)],
                isLoading: provider.isLoadingWeather,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: DashboardCard(
                title: 'Energy',
                value: '${provider.energyUsage.toStringAsFixed(1)} kW',
                subtitle: 'Current usage',
                icon: Icons.bolt,
                gradient: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRoomsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rooms',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        SizedBox(height: 16),
        Container(
          height: 120,
          child: Consumer<SmartHomeProvider>(
            builder: (context, provider, child) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: provider.rooms.length,
                itemBuilder: (context, index) {
                  final room = provider.rooms[index];
                  return Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: RoomCard(
                      room: room,
                      isSelected: room.id == provider.selectedRoomId,
                      onTap: () => provider.selectRoom(room.id),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDevicesSection() {
    return Consumer<SmartHomeProvider>(
      builder: (context, provider, child) {
        final selectedRoom = provider.rooms.firstWhere(
          (room) => room.id == provider.selectedRoomId,
        );
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${selectedRoom.name} Devices',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  '${provider.selectedRoomDevices.where((d) => d.isOn).length} active',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            DeviceGrid(
              devices: provider.selectedRoomDevices,
              onDeviceToggle: provider.toggleDevice,
            ),
          ],
        );
      },
    );
  }
}