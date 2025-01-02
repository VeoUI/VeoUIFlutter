import 'package:flutter/material.dart';
import '../../../veoui.dart';

class VeoTabItem {
  final String id;
  final IconData icon;
  final String title;

  VeoTabItem({
    required this.icon,
    required this.title,
  }) : id = UniqueKey().toString();
}

class VeoBottomTabBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelectedIndexChanged;
  final List<VeoTabItem> items;

  const VeoBottomTabBar({
    Key? key,
    required this.selectedIndex,
    required this.onSelectedIndexChanged,
    required this.items,
  }) : super(key: key);

  @override
  State<VeoBottomTabBar> createState() => _VeoBottomTabBarState();
}

class _VeoBottomTabBarState extends State<VeoBottomTabBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            textDirection: VeoUI.isRTL ? TextDirection.rtl : TextDirection.ltr,
            children: List.generate(
              widget.items.length,
                  (index) => Expanded(
                child: _buildTabItem(
                  item: widget.items[index],
                  index: index,
                  isSelected: widget.selectedIndex == index,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required VeoTabItem item,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        widget.onSelectedIndexChanged(index);
        _controller.reset();
        _controller.forward();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.icon,
            size: 24,
            color: isSelected ? VeoUI.primaryColor : Colors.grey,
          ),
          const SizedBox(height: 4),
          VeoText(
            item.title,
            style: isSelected ? VeoTextStyle.subtitle : VeoTextStyle.caption,
            color: isSelected ? VeoUI.primaryColor : Colors.black,
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: VeoUI.primaryColor,
            ),
            transform: Matrix4.diagonal3Values(
              isSelected ? 1 : 0,
              isSelected ? 1 : 0,
              1,
            ),
          ),
        ],
      ),
    );
  }
}