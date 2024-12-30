import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VeoTextField extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final IconData icon;
  final String placeholder;
  final bool isSecure;
  final TextInputType keyboardType;
  final bool Function(String)? validation;
  final Function(bool)? onEditingChanged;
  final VoidCallback? onSubmitted;

  const VeoTextField({
    Key? key,
    required this.text,
    required this.onChanged,
    required this.icon,
    required this.placeholder,
    this.isSecure = false,
    this.keyboardType = TextInputType.text,
    this.validation,
    this.onEditingChanged,
    this.onSubmitted,
  }) : super(key: key);

  @override
  State<VeoTextField> createState() => _VeoTextFieldState();
}

class _VeoTextFieldState extends State<VeoTextField> {
  bool _isEditing = false;
  bool _isValid = true;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(VeoTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != _controller.text) {
      _controller.text = widget.text;
    }
  }

  void _validateInput(String value) {
    if (widget.validation != null) {
      setState(() {
        _isValid = widget.validation!(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: SizedBox(
                  width: 20,
                  child: Icon(
                    widget.icon,
                    color: _isEditing
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  obscureText: widget.isSecure,
                  keyboardType: widget.keyboardType,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14, // Equivalent to caption1
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.placeholder,
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 10,
                    ),
                  ),
                  onChanged: (value) {
                    widget.onChanged(value);
                    _validateInput(value);
                  },
                  onSubmitted: (value) {
                    widget.onSubmitted?.call();
                  },
                  onTap: () {
                    setState(() => _isEditing = true);
                    widget.onEditingChanged?.call(true);
                  },
                  onEditingComplete: () {
                    setState(() => _isEditing = false);
                    widget.onEditingChanged?.call(false);
                  },
                ),
              ),
            ],
          ),
        ),
        if (!_isValid)
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 4),
            child: Text(
              'Invalid input',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }
}