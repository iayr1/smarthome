import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/device.dart';

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
    if (!widget.device.isOn) return Color(0xFF64748B);
    final iconData = widget.device.iconData;
    if (iconData == Icons.lightbulb || iconData == Icons.lightbulb_outline) {
      return Color(0xFFFFC107);
    } else if (iconData == Icons.ac_unit) {
      return Color(0xFF2196F3);
    } else if (iconData == Icons.mode_fan_off || iconData == Icons.air) {
      return Color(0xFF00BCD4);
    } else if (iconData == Icons.speaker) {
      return Color(0xFF9C27B0);
    } else if (iconData == Icons.tv) {
      return Color(0xFF4CAF50);
    } else if (iconData == Icons.kitchen || iconData == Icons.coffee) {
      return Color(0xFFFF9800);
    } else if (iconData == Icons.hot_tub) {
      return Color(0xFFFF5722);
    } else {
      return Color(0xFF3B82F6);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: widget.device.isOn
                ? Border.all(color: _primaryColor.withOpacity(0.3), width: 1.5)
                : Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
            boxShadow: [
              BoxShadow(
                color: widget.device.isOn
                    ? _primaryColor.withOpacity(0.15)
                    : Colors.black.withOpacity(0.05),
                blurRadius: widget.device.isOn ? 12 : 8,
                offset: Offset(0, widget.device.isOn ? 6 : 3),
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
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        widget.device.iconData,
                        color: _primaryColor,
                        size: 24,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: 44,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: widget.device.isOn ? _primaryColor : Color(0xFFE2E8F0),
                    ),
                    child: AnimatedAlign(
                      duration: Duration(milliseconds: 300),
                      alignment: widget.device.isOn
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: 20,
                        height: 20,
                        margin: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
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
              
              SizedBox(height: 16),
              
              // Device name
              Text(
                widget.device.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              SizedBox(height: 4),
              Text(
                widget.device.isOn ? widget.device.reading : 'Off',
                style: TextStyle(
                  fontSize: 14,
                  color: widget.device.isOn ? _primaryColor : Color(0xFF64748B),
                  fontWeight: widget.device.isOn ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
              
              SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: widget.device.isOn ? _primaryColor : Color(0xFF94A3B8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    widget.device.isOn ? 'Active' : 'Inactive',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w400,
                    ),
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