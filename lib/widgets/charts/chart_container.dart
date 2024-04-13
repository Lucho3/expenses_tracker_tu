import 'package:flutter/material.dart';

class ChartMainContainer extends StatelessWidget {
  ChartMainContainer({Key? key, required this.content, required this.title}) : super(key: key);

  final Widget content;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          width: 2.0,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20))
              ],
            ),
            Divider(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              indent: MediaQuery.of(context).size.width * 0.05,
              endIndent: MediaQuery.of(context).size.width * 0.05,
              thickness: 2,
            ),
            content,
          ],
        ),
      ),
    );
  }
}
