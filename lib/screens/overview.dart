import 'package:expenses_tracker_tu/widgets/wallets/wallet_displayer.dart';
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
        WalletsDisplayer(),
        Text("Overview Screen"),
      ],
    );
  }
}