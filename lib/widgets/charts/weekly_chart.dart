import 'package:expenses_tracker_tu/models/expense.dart';
import 'package:expenses_tracker_tu/models/income.dart';
import 'package:expenses_tracker_tu/providers/expenses_provider.dart';
import 'package:expenses_tracker_tu/providers/incomes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class WeeklyChart extends ConsumerStatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  WeeklyChart({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<WeeklyChart> {
// Function to get the last 7 days
  List<DateTime> getLast7Days() {
    List<DateTime> last7Days = [];
    DateTime today = DateTime.now();
    for (int i = 0; i < 7; i++) {
      last7Days.add(today.subtract(Duration(days: i)));
    }
    return last7Days;
  }

  bool datesAreEqual(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Map<DateTime, Map<String, double>> getIncomesExpensesMap(
      List<Expense> expenses, List<Income> incomes) {
    Map<DateTime, Map<String, double>> expensesPerDay = {};
    List<DateTime> last7Days = getLast7Days();
    for (var day in last7Days) {
      expensesPerDay[day] = {
        "Expenses": expenses
            .where((expense) => datesAreEqual(expense.date, day))
            .fold(0.0, (sum, expense) => sum + expense.amount),
        "Incomes": incomes
            .where((expense) => datesAreEqual(expense.date, day))
            .fold(0.0, (sum, income) => sum + income.amount)
      };
    }
    return expensesPerDay;
  }

  Widget generateMainContent(Map<DateTime, Map<String, double>> dateContainer) {
    final List<ChartData> chartData = dateContainer.entries
        .map((entry) {
          String formattedDate = DateFormat('MM/dd').format(entry.key);
          return ChartData(
            formattedDate,
            entry.value['Incomes'],
            entry.value['Expenses'],
          );
        })
        .toList()
        .reversed
        .toList();

    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.20,
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(
            majorGridLines: MajorGridLines(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                width: 1),
          ),
          series: <CartesianSeries>[
            ColumnSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.date,
              yValueMapper: (ChartData data, _) => data.income,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
            ColumnSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.date,
              yValueMapper: (ChartData data, _) => data.expense,
              color: Theme.of(context).colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final expenses = ref.watch(expensesProvider);
    final incomes = ref.watch(incomesProvider);

    // Handling asynchronous data for both expenses and incomes
    return expenses.when(
      data: (expensesData) => incomes.when(
        data: (incomesData) {
          // Both expensesData and incomesData are now available and can be used
          final last7DaysMap = getIncomesExpensesMap(expensesData, incomesData);
          double fullSum = last7DaysMap.values.fold(0.0,
              (sum, values) => sum + values["Incomes"]! + values["Expenses"]!);

          if (fullSum > 0) {
            return generateMainContent(last7DaysMap);
          } else {
            return Text(AppLocalizations.of(context)!.noRecordsWeek,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16));
          }
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Text('Error loading incomes: $error'),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Text('Error loading expenses: $error'),
    );
  }
}

class ChartData {
  ChartData(
    this.date,
    this.income,
    this.expense,
  );
  final String date;
  final double? income;
  final double? expense;
}
