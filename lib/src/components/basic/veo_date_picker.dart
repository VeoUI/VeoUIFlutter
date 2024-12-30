import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum VeoDatePickerMode {
  date,
  time,
  dateTime,
}

class VeoDatePickerStyle {
  final Color backgroundColor;
  final Color primaryColor;
  final Color textColor;
  final Color selectedTextColor;
  final TextStyle headerStyle;
  final TextStyle labelStyle;
  final TextStyle valueStyle;
  final double cornerRadius;
  final EdgeInsets contentPadding;

  const VeoDatePickerStyle({
    this.backgroundColor = Colors.white,
    this.primaryColor = const Color(0xFFe74c3c),
    this.textColor = Colors.black87,
    this.selectedTextColor = Colors.white,
    this.headerStyle = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    this.labelStyle = const TextStyle(
      fontSize: 16,
      color: Colors.black87,
    ),
    this.valueStyle = const TextStyle(
      fontSize: 16,
      color: Colors.black87,
    ),
    this.cornerRadius = 12,
    this.contentPadding = const EdgeInsets.all(16),
  });
}

class VeoDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime> onDateSelected;
  final VeoDatePickerMode mode;
  final VeoDatePickerStyle style;
  final String? label;
  final bool showLabel;
  final IconData icon;

  const VeoDatePicker({
    Key? key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    required this.onDateSelected,
    this.mode = VeoDatePickerMode.date,
    this.style = const VeoDatePickerStyle(),
    this.label,
    this.showLabel = true,
    this.icon = Icons.calendar_today,
  }) : super(key: key);

  @override
  State<VeoDatePicker> createState() => _VeoDatePickerState();
}

class _VeoDatePickerState extends State<VeoDatePicker> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _selectedTime = TimeOfDay.fromDateTime(_selectedDate);
  }

  Future<void> _showDatePicker() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: widget.style.primaryColor,
              onPrimary: widget.style.selectedTextColor,
              surface: widget.style.backgroundColor,
              onSurface: widget.style.textColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: widget.style.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        _selectedDate = DateTime(
          date.year,
          date.month,
          date.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );
      });
      widget.onDateSelected(_selectedDate);
    }
  }

  Future<void> _showTimePicker() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: widget.style.primaryColor,
              onPrimary: widget.style.selectedTextColor,
              surface: widget.style.backgroundColor,
              onSurface: widget.style.textColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: widget.style.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        _selectedTime = time;
        _selectedDate = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          time.hour,
          time.minute,
        );
      });
      widget.onDateSelected(_selectedDate);
    }
  }

  String get _formattedValue {
    switch (widget.mode) {
      case VeoDatePickerMode.date:
        return DateFormat('MMM dd, yyyy').format(_selectedDate);
      case VeoDatePickerMode.time:
        return _selectedTime.format(context);
      case VeoDatePickerMode.dateTime:
        return '${DateFormat('MMM dd, yyyy').format(_selectedDate)} ${_selectedTime.format(context)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel && widget.label != null) ...[
          Text(
            widget.label!,
            style: widget.style.labelStyle,
          ),
          const SizedBox(height: 8),
        ],
        Material(
          color: widget.style.backgroundColor,
          borderRadius: BorderRadius.circular(widget.style.cornerRadius),
          child: InkWell(
            onTap: () async {
              if (widget.mode == VeoDatePickerMode.time) {
                await _showTimePicker();
              } else {
                await _showDatePicker();
                if (widget.mode == VeoDatePickerMode.dateTime) {
                  await _showTimePicker();
                }
              }
            },
            borderRadius: BorderRadius.circular(widget.style.cornerRadius),
            child: Container(
              padding: widget.style.contentPadding,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(widget.style.cornerRadius),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.icon,
                    color: widget.style.primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _formattedValue,
                      style: widget.style.valueStyle,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: widget.style.textColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}