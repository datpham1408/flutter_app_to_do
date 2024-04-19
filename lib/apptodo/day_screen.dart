import 'package:app_to_do/model/day_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayWidget extends StatefulWidget {
  final DayModel dayModel;
  final VoidCallback callback;

  const DayWidget({super.key, required this.dayModel, required this.callback});

  @override
  State<DayWidget> createState() => _DayWidgetState();
}

class _DayWidgetState extends State<DayWidget> {
  @override
  Widget build(BuildContext context) {
    return itemDetailListDay(widget.dayModel);
  }

  Widget itemDetailListDay(DayModel dayModel) {
    int? day;
    int? month;
    int? year;

    if (dayModel.day.isNotEmpty) {
      DateTime dateTime = DateFormat('dd/MM/yyyy').parse(dayModel.day);
      day = dateTime.day;
      month = dateTime.month;
      year = dateTime.year;
    }

    final Color colorDecoration =
        dayModel.selected != true ? Colors.white : Colors.deepPurpleAccent;
    final Color colorTextStyle =
        dayModel.selected != true ? Colors.grey : Colors.white;
    return GestureDetector(
      onTap: () {
        widget.callback.call();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: colorDecoration,
        ),
        child: Column(
          children: [
            Text(
              '$year',
              style: TextStyle(
                  color: colorTextStyle,
                  fontWeight: FontWeight.w500,
                  fontSize: 22),
            ),
            Text('$day',
                style: TextStyle(
                    color: colorTextStyle,
                    fontWeight: FontWeight.w500,
                    fontSize: 22)),
            Text(
              '$month',
              style: TextStyle(
                color: colorTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
