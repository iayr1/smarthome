import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/device.dart';
import '../styles/app_color.dart';
import '../styles/app_typography.dart';


class DeviceCard extends StatefulWidget {
  final Device device;
  final VoidCallback onToggle;

  const DeviceCard({
    Key? key,
    required this.device,
    required this.onToggle,
  }) : super(key: key);

  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _iconRotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _iconRotationAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );

    _iconRotationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _iconRotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _iconRotationController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _iconRotationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    _scaleController.forward().then((_) => _scaleController.reverse());
    _iconRotationController.forward().then((_) => _iconRotationController.reverse());
    widget.onToggle();
  }

  Color get _primaryColor {
    if (!widget.device.isOn) return AppColors.grayScale70;
    final iconData = widget.device.iconData;
    if (iconData == Icons.lightbulb || iconData == Icons.lightbulb_outline) {
      return AppColors.warning;
    } else if (iconData == Icons.ac_unit) {
      return AppColors.secondary100;
    } else if (iconData == Icons.mode_fan_off || iconData == Icons.air) {
      return AppColors.tertiary100;
    } else if (iconData == Icons.speaker) {
      return AppColors.error;
    } else if (iconData == Icons.tv) {
      return AppColors.success;
    } else if (iconData == Icons.kitchen || iconData == Icons.coffee) {
      return AppColors.primary;
    } else if (iconData == Icons.hot_tub) {
      return AppColors.primary80;
    } else {
      return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isTablet = screenWidth >= 768;
    final isDesktop = screenWidth >= 1024;

    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) => _scaleController.reverse(),
      onTapCancel: () => _scaleController.reverse(),
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.all(isDesktop ? 20 : (isTablet ? 18 : 16)),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(isDesktop ? 20 : (isTablet ? 18 : 16)),
            border: widget.device.isOn
                ? Border.all(color: _primaryColor.withOpacity(0.3), width: 1.5)
                : Border.all(color: AppColors.line, width: 1),
            boxShadow: [
              BoxShadow(
                color: widget.device.isOn
                    ? _primaryColor.withOpacity(0.15)
                    : AppColors.grayScale100.withOpacity(0.05),
                blurRadius: widget.device.isOn ? (isDesktop ? 16 : 12) : (isDesktop ? 12 : 8),
                offset: Offset(0, widget.device.isOn ? (isDesktop ? 8 : 6) : (isDesktop ? 4 : 3)),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RotationTransition(
                    turns: _iconRotationAnimation,
                    child: Container(
                      padding: EdgeInsets.all(isDesktop ? 12 : (isTablet ? 10 : 8)),
                      decoration: BoxDecoration(
                        color: _primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(isDesktop ? 12 : (isTablet ? 10 : 8)),
                      ),
                      child: Icon(
                        widget.device.iconData,
                        color: _primaryColor,
                        size: isDesktop ? 28 : (isTablet ? 26 : 24),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: isDesktop ? 52 : (isTablet ? 48 : 44),
                    height: isDesktop ? 28 : (isTablet ? 26 : 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(isDesktop ? 16 : (isTablet ? 14 : 12)),
                      color: widget.device.isOn ? _primaryColor : AppColors.grayScale30,
                    ),
                    child: AnimatedAlign(
                      duration: Duration(milliseconds: 300),
                      alignment: widget.device.isOn
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: isDesktop ? 24 : (isTablet ? 22 : 20),
                        height: isDesktop ? 24 : (isTablet ? 22 : 20),
                        margin: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(isDesktop ? 12 : (isTablet ? 11 : 10)),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.grayScale100.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: isDesktop ? 20 : (isTablet ? 18 : 16)),

              Text(
                widget.device.name,
                style: isDesktop
                    ? AppTypography.bodyTextLargeSemiBold.copyWith(color: AppColors.grayScale100)
                    : (isTablet
                    ? AppTypography.bodyTextMedium.copyWith(color: AppColors.grayScale100)
                    : AppTypography.bodyTextSmallSemiBold.copyWith(color: AppColors.grayScale100)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: isDesktop ? 8 : (isTablet ? 6 : 4)),
              Text(
                widget.device.isOn ? widget.device.reading : 'Off',
                style: isDesktop
                    ? AppTypography.bodyTextMedium.copyWith(
                  color: widget.device.isOn ? _primaryColor : AppColors.grayScale70,
                )
                    : (isTablet
                    ? AppTypography.bodyTextSmallMedium.copyWith(
                  color: widget.device.isOn ? _primaryColor : AppColors.grayScale70,
                )
                    : AppTypography.bodyTextXtraSmallMedium.copyWith(
                  color: widget.device.isOn ? _primaryColor : AppColors.grayScale70,
                )),
              ),

              SizedBox(height: isDesktop ? 12 : (isTablet ? 10 : 8)),
              Row(
                children: [
                  Container(
                    width: isDesktop ? 10 : (isTablet ? 9 : 8),
                    height: isDesktop ? 10 : (isTablet ? 9 : 8),
                    decoration: BoxDecoration(
                      color: widget.device.isOn ? _primaryColor : AppColors.grayScale60,
                      borderRadius: BorderRadius.circular(isDesktop ? 5 : (isTablet ? 4.5 : 4)),
                    ),
                  ),
                  SizedBox(width: isDesktop ? 8 : (isTablet ? 7 : 6)),
                  Text(
                    widget.device.isOn ? 'Active' : 'Inactive',
                    style: isDesktop
                        ? AppTypography.bodyTextSmallMedium.copyWith(color: AppColors.grayScale60)
                        : (isTablet
                        ? AppTypography.bodyTextXtraSmallMedium.copyWith(color: AppColors.grayScale60)
                        : AppTypography.bodyTextXtraSmallMedium.copyWith(color: AppColors.grayScale60)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
