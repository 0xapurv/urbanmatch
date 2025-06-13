import 'package:flutter/material.dart';
import 'package:urbanmatch/screen/event_screen.dart';
import 'package:urbanmatch/screen/empty_tab_screen.dart';
import 'package:urbanmatch/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const EventScreen(),
    const EmptyTabScreen(),
    const EmptyTabScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: _pages[_currentIndex],
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  
  const CustomBottomNavBar({
    super.key, 
    required this.currentIndex, 
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              color: AppColors.creme.withOpacity(0.2),
              height: 1,
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NavBarIcon(
                  icon: Icons.search,
                  isActive: currentIndex == 0,
                  onTap: () => onTap(0),
                ),
                _NavBarIcon(
                  icon: Icons.local_fire_department,
                  isActive: currentIndex == 1,
                  onTap: () => onTap(1),
                  isCenter: true,
                ),
                _NavBarIcon(
                  icon: Icons.circle_outlined,
                  isActive: currentIndex == 2,
                  onTap: () => onTap(2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavBarIcon extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final bool isCenter;
  final VoidCallback onTap;
  
  const _NavBarIcon({
    required this.icon,
    required this.isActive,
    required this.onTap,
    this.isCenter = false,
  });

  @override
  Widget build(BuildContext context) {
    final Widget iconWidget = Icon(
      icon,
      color: isActive ? AppColors.creme : AppColors.creme.withOpacity(0.7),
      size: isCenter ? 32 : 28,
    );
    final double width = isActive ? (isCenter ? 54 : 44) : 40;
    
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: 40,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            width: width,
            height: 40,
            decoration: isActive
                ? BoxDecoration(
                    color: AppColors.markerOrange,
                    borderRadius: BorderRadius.circular(24),
                  )
                : null,
            child: iconWidget,
          ),
        ),
      ),
    );
  }
} 