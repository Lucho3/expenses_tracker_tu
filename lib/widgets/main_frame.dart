import 'package:expenses_tracker_tu/widgets/floating_action_button.dart';
import 'package:expenses_tracker_tu/widgets/main_drawer.dart';
import 'package:flutter/material.dart';


class MainFrame extends StatelessWidget {
  const MainFrame({super.key, required this.content, required this.title});
  
  final String title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
        ),
      ),
      drawer: const MainDrawer(),
      body: content,
      floatingActionButton: const CustomFAB(),
    );
  }
}
