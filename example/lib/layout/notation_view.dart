import 'package:example/layout/search_drawer.dart';
import 'package:flutter/material.dart';

class NotationViewLayout extends StatelessWidget {
  final Widget body;

  const NotationViewLayout({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Library music_notation example"),
      ),
      body: Row(
        children: [
          Drawer(child: SearchDrawer()),
          Expanded(child: body),
        ],
      ),
    );
  }
}
