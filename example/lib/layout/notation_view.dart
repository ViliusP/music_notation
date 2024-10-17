import 'package:example/layout/search_drawer.dart';
import 'package:flutter/material.dart';

class NotationViewLayout extends StatelessWidget {
  final Widget body;

  const NotationViewLayout({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Row(
            children: [
              Material(
                color: Theme.of(context).drawerTheme.surfaceTintColor,
                elevation: 6,
                child: SizedBox(
                  width: 300,
                  child: SearchDrawer(),
                ),
              ),
              Expanded(child: body),
            ],
          ),
        ],
      ),
    );
  }
}
