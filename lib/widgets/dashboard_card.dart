import 'package:flutter/material.dart';
import '../styles/app_color.dart';
import '../styles/app_typography.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final bool isLoading;

  const DashboardCard({
    Key? key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isTablet = screenWidth >= 768;
    final isDesktop = screenWidth >= 1024;

    return Container(
      decoration: BoxDecoration(
        // Subtle outer border with gradient colors
        gradient: LinearGradient(
          colors: [
            gradient[0].withOpacity(0.1),
            gradient[1].withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isDesktop ? 24 : (isTablet ? 20 : 18)),
      ),
      padding: const EdgeInsets.all(2), // Space for the outer border effect
      child: Container(
        padding: EdgeInsets.all(isDesktop ? 24 : (isTablet ? 20 : 16)),
        decoration: BoxDecoration(
          // Main gradient background
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(isDesktop ? 22 : (isTablet ? 18 : 16)),
          // Subtle inner border for depth
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            // Background decorative elements
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: -30,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.03),
                ),
              ),
            ),
            // Main content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: isDesktop
                            ? AppTypography.bodyTextLargeMedium.copyWith(
                          color: AppColors.white.withOpacity(0.9),
                        )
                            : (isTablet
                            ? AppTypography.bodyTextMedium.copyWith(
                          color: AppColors.white.withOpacity(0.9),
                        )
                            : AppTypography.bodyTextSmallMedium.copyWith(
                          color: AppColors.white.withOpacity(0.9),
                        )),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(isDesktop ? 12 : (isTablet ? 10 : 8)),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(isDesktop ? 16 : (isTablet ? 14 : 12)),
                        // Subtle inner glow effect
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: AppColors.white.withOpacity(0.95),
                        size: isDesktop ? 24 : (isTablet ? 22 : 20),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isDesktop ? 20 : (isTablet ? 16 : 14)),
                if (isLoading)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: isDesktop ? 8 : 6),
                    child: SizedBox(
                      height: isDesktop ? 24 : (isTablet ? 22 : 20),
                      width: isDesktop ? 24 : (isTablet ? 22 : 20),
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.white.withOpacity(0.9),
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      value,
                      style: isDesktop
                          ? AppTypography.h4Bold.copyWith(
                        color: AppColors.white,
                        letterSpacing: -0.5,
                      )
                          : (isTablet
                          ? AppTypography.h5Bold.copyWith(
                        color: AppColors.white,
                        letterSpacing: -0.3,
                      )
                          : AppTypography.h6Bold.copyWith(
                        color: AppColors.white,
                        letterSpacing: -0.2,
                      )),
                    ),
                  ),
                SizedBox(height: isDesktop ? 12 : (isTablet ? 10 : 8)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 12 : (isTablet ? 10 : 8),
                    vertical: isDesktop ? 6 : (isTablet ? 5 : 4),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(isDesktop ? 12 : (isTablet ? 10 : 8)),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.05),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    subtitle,
                    style: isDesktop
                        ? AppTypography.bodyTextSmallMedium.copyWith(
                      color: AppColors.white.withOpacity(0.85),
                    )
                        : (isTablet
                        ? AppTypography.bodyTextXtraSmallMedium.copyWith(
                      color: AppColors.white.withOpacity(0.85),
                    )
                        : AppTypography.bodyTextXtraSmallMedium.copyWith(
                      color: AppColors.white.withOpacity(0.85),
                    )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}