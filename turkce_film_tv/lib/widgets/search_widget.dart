// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class SearchVisibilityWidget extends StatefulWidget {
  final bool isVisible;
  final ValueChanged<String> onChanged;

  const SearchVisibilityWidget({
    Key? key,
    required this.isVisible,
    required this.onChanged,
  }) : super(key: key);

  @override
  _SearchVisibilityWidgetState createState() => _SearchVisibilityWidgetState();
}

class _SearchVisibilityWidgetState extends State<SearchVisibilityWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.5, 0),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SearchVisibilityWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Visibility(
        visible: widget.isVisible,
        child: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.050,
          ),
          child: SizedBox(
            width: 400,
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Film ara...',
                hintStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              onChanged: widget.onChanged,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
