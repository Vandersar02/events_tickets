import 'package:flutter/material.dart';

class SideMenu extends StatefulWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const SideMenu({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.isSelected) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(SideMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovering = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovering = false;
        });
      },
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(8),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? Colors.white.withOpacity(0.15) // Background for selected item
                : _isHovering
                    ? Colors.white.withOpacity(0.08) // Hover background
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: Icon(
                  Icons.circle,
                  color: widget.isSelected ? Colors.white : Colors.white70,
                  size: 8,
                ),
              ),
              const SizedBox(width: 10),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: widget.isSelected
                      ? Colors.white
                      : _isHovering
                          ? Colors.white.withOpacity(0.9)
                          : Colors.white70,
                  fontWeight:
                      widget.isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                child: Text(widget.title),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
