import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CommonTextField extends StatefulWidget {
  CommonTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.icon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.draggable = false,
    this.minLength = 0,
    this.iconButton,
    this.isAbsecure = false,
  }) : super(key: key);

  final String hintText;
  final IconData? icon;
  final IconData? suffixIcon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool draggable;
  final int minLength;
  final Widget? iconButton;
  bool isAbsecure;
  // int enablestate;

  @override
  _CommonTextFieldState createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Material(
        elevation: 10,
        shadowColor: Colors.grey,
        child: TextFormField(
          obscureText: widget.isAbsecure,

          // enabled: widget.enablestate == 0 ? true : false,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(widget.icon),
            suffixIcon: widget.iconButton != null ? widget.iconButton! : null,
            hintText: widget.hintText,
            contentPadding: const EdgeInsets.fromLTRB(35, 16, 20, 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2),
              borderSide: const BorderSide(color: Colors.blue, width: 1.5),
            ),
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          minLines: widget.minLength,
          maxLines: widget.draggable ? null : 1,
        ),
      ),
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        widget.controller.text = _selectedDate.toString().split(' ')[0];
      });
    }
  }
}
