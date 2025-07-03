import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/smart_home_provider.dart';
import '../styles/app_color.dart';
import '../styles/app_typography.dart';
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
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isTablet = screenWidth >= 768;
    final isDesktop = screenWidth >= 1024;

    return Scaffold(
      backgroundColor: AppColors.grayScale10,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 32 : (isTablet ? 24 : 16),
              vertical: isDesktop ? 24 : (isTablet ? 20 : 16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(screenWidth, isTablet, isDesktop),
                SizedBox(height: isDesktop ? 32 : (isTablet ? 24 : 20)),
                _buildDashboard(screenWidth, isTablet, isDesktop),
                SizedBox(height: isDesktop ? 40 : (isTablet ? 32 : 24)),
                _buildRoomsSection(screenWidth, isTablet, isDesktop),
                SizedBox(height: isDesktop ? 32 : (isTablet ? 24 : 20)),
                _buildDevicesSection(screenWidth, isTablet, isDesktop),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth, bool isTablet, bool isDesktop) {
    return Consumer<SmartHomeProvider>(
      builder: (context, provider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.greeting,
                    style: isDesktop
                        ? AppTypography.h2Bold.copyWith(color: AppColors.grayScale100)
                        : (isTablet
                        ? AppTypography.h3Bold.copyWith(color: AppColors.grayScale100)
                        : AppTypography.h4Bold.copyWith(color: AppColors.grayScale100)),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Welcome to your smart home',
                    style: isDesktop
                        ? AppTypography.bodyTextLargeMedium.copyWith(color: AppColors.grayScale70)
                        : (isTablet
                        ? AppTypography.bodyTextMedium.copyWith(color: AppColors.grayScale70)
                        : AppTypography.bodyTextSmallMedium.copyWith(color: AppColors.grayScale70)),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => provider.toggleTemperatureUnit(),
              child: Container(
                width: isDesktop ? 56 : (isTablet ? 48 : 44),
                height: isDesktop ? 56 : (isTablet ? 48 : 44),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(isDesktop ? 16 : (isTablet ? 14 : 12)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grayScale100.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  provider.isCelsius ? Icons.thermostat : Icons.ac_unit,
                  color: AppColors.primary,
                  size: isDesktop ? 28 : (isTablet ? 24 : 20),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDashboard(double screenWidth, bool isTablet, bool isDesktop) {
    return Consumer<SmartHomeProvider>(
      builder: (context, provider, child) {
        if (isDesktop) {
          return Row(
            children: [
              Expanded(
                child: DashboardCard(
                  title: 'Weather',
                  value: provider.weather?.getTemperatureString(provider.isCelsius) ?? '--°C',
                  subtitle: provider.weather?.condition ?? 'Loading...',
                  icon: Icons.wb_sunny,
                  gradient: [AppColors.tertiary80, AppColors.primary],
                  isLoading: provider.isLoadingWeather,
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: DashboardCard(
                  title: 'Energy',
                  value: '${provider.energyUsage.toStringAsFixed(1)} kW',
                  subtitle: 'Current usage',
                  icon: Icons.bolt,
                  gradient: [AppColors.success50, AppColors.success70],
                ),
              ),
            ],
          );
        } else if (isTablet) {
          return Row(
            children: [
              Expanded(
                child: DashboardCard(
                  title: 'Weather',
                  value: provider.weather?.getTemperatureString(provider.isCelsius) ?? '--°C',
                  subtitle: provider.weather?.condition ?? 'Loading...',
                  icon: Icons.wb_sunny,
                  gradient: [AppColors.tertiary80, AppColors.primary],
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
                  gradient: [AppColors.success50, AppColors.success70],
                ),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              DashboardCard(
                title: 'Weather',
                value: provider.weather?.getTemperatureString(provider.isCelsius) ?? '--°C',
                subtitle: provider.weather?.condition ?? 'Loading...',
                icon: Icons.wb_sunny,
                gradient: [AppColors.tertiary80, AppColors.primary],
                isLoading: provider.isLoadingWeather,
              ),
              SizedBox(height: 16),
              DashboardCard(
                title: 'Energy',
                value: '${provider.energyUsage.toStringAsFixed(1)} kW',
                subtitle: 'Current usage',
                icon: Icons.bolt,
                gradient: [AppColors.success50, AppColors.success70],
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildRoomsSection(double screenWidth, bool isTablet, bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rooms',
          style: isDesktop
              ? AppTypography.h3Bold.copyWith(color: AppColors.grayScale100)
              : (isTablet
              ? AppTypography.h4Bold.copyWith(color: AppColors.grayScale100)
              : AppTypography.h5Bold.copyWith(color: AppColors.grayScale100)),
        ),
        SizedBox(height: isDesktop ? 20 : (isTablet ? 16 : 12)),
        Container(
          height: isDesktop ? 140 : (isTablet ? 130 : 120),
          child: Consumer<SmartHomeProvider>(
            builder: (context, provider, child) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: provider.rooms.length,
                itemBuilder: (context, index) {
                  final room = provider.rooms[index];
                  return Padding(
                    padding: EdgeInsets.only(right: isDesktop ? 20 : (isTablet ? 16 : 12)),
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

  Widget _buildDevicesSection(double screenWidth, bool isTablet, bool isDesktop) {
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
                Expanded(
                  child: Text(
                    '${selectedRoom.name} Devices',
                    style: isDesktop
                        ? AppTypography.h3Bold.copyWith(color: AppColors.grayScale100)
                        : (isTablet
                        ? AppTypography.h4Bold.copyWith(color: AppColors.grayScale100)
                        : AppTypography.h5Bold.copyWith(color: AppColors.grayScale100)),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 16 : (isTablet ? 12 : 8),
                    vertical: isDesktop ? 8 : (isTablet ? 6 : 4),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary10,
                    borderRadius: BorderRadius.circular(isDesktop ? 12 : (isTablet ? 10 : 8)),
                  ),
                  child: Text(
                    '${provider.selectedRoomDevices.where((d) => d.isOn).length} active',
                    style: isDesktop
                        ? AppTypography.bodyTextMedium.copyWith(color: AppColors.primary)
                        : (isTablet
                        ? AppTypography.bodyTextSmallMedium.copyWith(color: AppColors.primary)
                        : AppTypography.bodyTextXtraSmallMedium.copyWith(color: AppColors.primary)),
                  ),
                ),
              ],
            ),
            SizedBox(height: isDesktop ? 20 : (isTablet ? 16 : 12)),
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