import 'package:flutter/material.dart';

class OverviewScreen extends StatefulWidget{
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() {
    return _OverviewScreenState();
  }

}

class _OverviewScreenState extends State<OverviewScreen>{
  @override
  Widget build(BuildContext context) {
    return Column( 
      children: [
        Text("Overview Screen"),
        Text("Overview Screen"),
      ],
    );
  }
}