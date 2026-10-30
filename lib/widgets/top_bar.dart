import 'package:flutter/material.dart';
import 'menu_popup.dart';

class TopBar extends StatelessWidget {
  final bool isAdmin;
  const TopBar({super.key, this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade700),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search lace...',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu),
            onSelected: (v) => handleMenu(context, v, isAdmin),
            itemBuilder: (_) => buildMenuItems(isAdmin),
          ),
        ],
      ),
    );
  }
}