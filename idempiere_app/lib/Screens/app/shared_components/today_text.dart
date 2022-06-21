import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class TodayText extends StatefulWidget {
  const TodayText({Key? key}) : super(key: key);

  @override
  State<TodayText> createState() => _TodayTextState();
}

class _TodayTextState extends State<TodayText> {
  @override
  void initState() {
    super.initState();

    initializeDateFormatting().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    //String locale = Localizations.localeOf(context).languageCode;
    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today",
            style: Theme.of(context).textTheme.caption,
          ),
          Text(
            DateFormat.yMMMEd('it').format(DateTime.now()),
          )
        ],
      ),
    );
  }
}
