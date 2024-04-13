import 'package:expenses_tracker_tu/providers/expenses_provider.dart';
import 'package:expenses_tracker_tu/providers/incomes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class MonthlyChart extends ConsumerStatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  MonthlyChart({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MonthlyChart> {
  late List<_ChartData> data;

  List<Widget> getChartData(List<_ChartData> data) {
    String formattedDate = DateFormat('MMMM yyyy').format(DateTime.now());
    final double allIncome = data.where((d) => d.x == "Income").first.y;
    final double allExpense = data.where((d) => d.x == "Expense").first.y;
    final double total = allIncome - allExpense;
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(formattedDate,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
          )
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.25,
            width: MediaQuery.of(context).size.width * 0.25,
            child: SfCircularChart(series: <CircularSeries<_ChartData, String>>[
              DoughnutSeries<_ChartData, String>(
                dataSource: data,
                xValueMapper: (_ChartData data, _) => data.x,
                yValueMapper: (_ChartData data, _) => data.y,
                name: 'IncomesChart',
                pointColorMapper: (_ChartData data, _) => data.x == 'Income'
                    ? Theme.of(context).colorScheme.onSecondaryContainer
                    : Theme.of(context).colorScheme.error,
              ),
            ]),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.income + ":",
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                Text(AppLocalizations.of(context)!.expense + ":",
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                Text(AppLocalizations.of(context)!.total + ":",
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16))
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(allIncome.toString() + '\$',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                Text(allExpense.toString() + '\$',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                Text(total.toString() + '\$',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: total > 0
                            ? Theme.of(context).colorScheme.onSecondaryContainer
                            : Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.bold,
                        fontSize: 16))
              ],
            ),
          ),
        ],
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final expenses = ref.watch(expensesProvider);
    final incomes = ref.watch(incomesProvider);
    double sumIncomes = incomes
        .where((w) => w.date.month == DateTime.now().month)
        .fold(0, (previousValue, item) => previousValue + item.amount);
    double sumExpenses = expenses
        .where((w) => w.date.month == DateTime.now().month)
        .fold(0, (previousValue, item) => previousValue + item.amount);
    data = [
      _ChartData(
        'Income',
        sumIncomes,
      ),
      _ChartData('Expense', sumExpenses),
    ];
    return (sumExpenses == 0 && sumIncomes == 0)
        ? Text(AppLocalizations.of(context)!.noRecordsMonth,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 16))
        : Wrap(
            children: [...getChartData(data)],
          );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
