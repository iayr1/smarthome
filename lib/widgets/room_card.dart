import 'package:flutter/material.dart';
import '../models/room.dart';
import '../styles/app_color.dart';
import '../styles/app_typography.dart';

class RoomCard extends StatefulWidget {
  final Room room;
  final bool isSelected;
  final VoidCallback onTap;

  const RoomCard({
    Key? key,
    required this.room,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  _RoomCardState createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isTablet = screenWidth >= 768;
    final isDesktop = screenWidth >= 1024;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: isDesktop ? 160 : (isTablet ? 150 : 140),
          padding: EdgeInsets.all(isDesktop ? 20 : (isTablet ? 18 : 16)),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.room.gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(isDesktop ? 20 : (isTablet ? 18 : 16)),
            border: widget.isSelected
                ? Border.all(color: AppColors.white, width: isDesktop ? 3 : (isTablet ? 2.5 : 2))
                : null,
            boxShadow: [
              BoxShadow(
                color: widget.room.gradient[0].withOpacity(0.3),
                blurRadius: widget.isSelected
                    ? (isDesktop ? 20 : (isTablet ? 18 : 16))
                    : (isDesktop ? 12 : (isTablet ? 10 : 8)),
                offset: Offset(0, widget.isSelected
                    ? (isDesktop ? 10 : (isTablet ? 8 : 6))
                    : (isDesktop ? 6 : (isTablet ? 5 : 4))),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                widget.room.iconData,
                color: AppColors.white,
                size: isDesktop ? 32 : (isTablet ? 30 : 28),
              ),
              SizedBox(height: isDesktop ? 16 : (isTablet ? 14 : 12)),
              Text(
                widget.room.name,
                style: isDesktop
                    ? AppTypography.bodyTextLargeBold.copyWith(color: AppColors.white)
                    : (isTablet
                    ? AppTypography.bodyTextMedium.copyWith(color: AppColors.white)
                    : AppTypography.bodyTextSmallSemiBold.copyWith(color: AppColors.white)),
              ),
              SizedBox(height: isDesktop ? 8 : (isTablet ? 6 : 4)),
              Text(
                '${widget.room.activeDevices} active',
                style: isDesktop
                    ? AppTypography.bodyTextSmallMedium.copyWith(color: AppColors.white.withOpacity(0.8))
                    : (isTablet
                    ? AppTypography.bodyTextXtraSmallMedium.copyWith(color: AppColors.white.withOpacity(0.8))
                    : AppTypography.bodyTextXtraSmallMedium.copyWith(color: AppColors.white.withOpacity(0.8))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
