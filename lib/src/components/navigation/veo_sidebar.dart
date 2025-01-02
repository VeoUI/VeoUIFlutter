import 'package:flutter/material.dart';
import '../../../veoui.dart';

class VeoSidebarItem {
  final int id;
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const VeoSidebarItem({
    required this.id,
    required this.icon,
    required this.title,
    this.onTap,
  });
}

class VeoSidebarConfig {
  final String topLogo;
  final String headerText;
  final String? bottomLogo;
  final double width;
  final Color backgroundColor;
  final Color selectedColor;
  final Color textColor;

  const VeoSidebarConfig({
    required this.topLogo,
    required this.headerText,
    this.bottomLogo,
    this.width = 280,
    required this.backgroundColor,
    required this.selectedColor,
    required this.textColor,
  });
}

class VeoSidebar extends StatefulWidget {
  final VeoSidebarConfig config;
  final List<VeoSidebarItem> menuItems;
  final VeoSidebarItem? selectedItem;
  final ValueChanged<VeoSidebarItem?> onSelectedItemChanged;
  final bool isShowing;
  final ValueChanged<bool> onShowingChanged;

  const VeoSidebar({
    Key? key,
    required this.config,
    required this.menuItems,
    required this.selectedItem,
    required this.onSelectedItemChanged,
    required this.isShowing,
    required this.onShowingChanged,
  }) : super(key: key);

  @override
  State<VeoSidebar> createState() => _VeoSidebarState();
}

class _VeoSidebarState extends State<VeoSidebar> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  double _dragOffset = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: VeoUI.isRTL ? const Offset(-1, 0) : const Offset(1, 0),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    ));

    if (widget.isShowing) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(VeoSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isShowing != oldWidget.isShowing) {
      if (widget.isShowing) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final delta = VeoUI.isRTL ? -details.delta.dx : details.delta.dx;
    if (widget.isShowing) {
      setState(() {
        _dragOffset = (_dragOffset + delta).clamp(-widget.config.width, 0);
      });
    } else {
      setState(() {
        _dragOffset = (_dragOffset + delta).clamp(0, widget.config.width);
      });
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    final velocity = VeoUI.isRTL ? -details.velocity.pixelsPerSecond.dx
        : details.velocity.pixelsPerSecond.dx;

    if (widget.isShowing && (_dragOffset < -50 || velocity < -500)) {
      widget.onShowingChanged(false);
    } else if (!widget.isShowing && (_dragOffset > 50 || velocity > 500)) {
      widget.onShowingChanged(true);
    }

    setState(() {
      _dragOffset = 0;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.isShowing)
          GestureDetector(
            onTap: () => widget.onShowingChanged(false),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
        SlideTransition(
          position: _slideAnimation,
          child: GestureDetector(
            onHorizontalDragUpdate: _handleDragUpdate,
            onHorizontalDragEnd: _handleDragEnd,
            child: Container(
              width: widget.config.width,
              color: widget.config.backgroundColor,
              child: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Image.asset(
                      widget.config.topLogo,
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),
                    VeoText(
                      widget.config.headerText,
                      style: VeoTextStyle.title,
                      color: widget.config.textColor,
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: widget.menuItems.map((item) => _buildMenuItem(item)).toList(),
                        ),
                      ),
                    ),
                    if (widget.config.bottomLogo != null) ...[
                      const SizedBox(height: 20),
                      Image.asset(
                        widget.config.bottomLogo!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(VeoSidebarItem item) {
    final isSelected = widget.selectedItem?.id == item.id;

    return GestureDetector(
      onTap: () {
        widget.onSelectedItemChanged(item);
        item.onTap?.call();
        widget.onShowingChanged(false);
      },
      child: Container(
        height: 44,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 7.5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              if (isSelected) ...[
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.config.selectedColor,
                  ),
                ),
                const SizedBox(width: 15),
              ],
              Icon(
                item.icon,
                color: widget.config.textColor,
                size: 24,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: VeoText(
                  item.title,
                  style: VeoTextStyle.subtitle,
                  color: widget.config.textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
