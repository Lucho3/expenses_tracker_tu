import 'package:expenses_tracker_tu/widgets/charts/chart_container.dart';
import 'package:expenses_tracker_tu/widgets/charts/monthly_chart.dart';
import 'package:expenses_tracker_tu/widgets/charts/weekly_chart.dart';
import 'package:expenses_tracker_tu/widgets/wallets/wallet_displayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() {
    return _OverviewScreenState();
  }
}

class _OverviewScreenState extends State<OverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //TODO: Those are unconstraint vertical should be fixed
        WalletsDisplayer(),
        ChartMainContainer(
          title: AppLocalizations.of(context)!.monthlySummary,
          content: MonthlyChart(),
        ),
        ChartMainContainer(
          title: AppLocalizations.of(context)!.weeklySummary,
          content: WeeklyChart(),
        ),
      ],
    );
  }
}
