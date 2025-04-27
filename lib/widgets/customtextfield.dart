import 'package:challengr/font.dart';
import 'package:challengr/theme.dart';
import 'package:flutter/material.dart';

class TextFieldFormWidget extends StatefulWidget {
  final TextInputType? textInputType;
  final bool? hiddenText;
  final TextEditingController controller;
  final Text label;
  final String hintText;

  const TextFieldFormWidget({
    super.key,
    this.textInputType,
    required this.hiddenText,
    required this.controller,
    required this.label,
    required this.hintText,
  });

  @override
  State<TextFieldFormWidget> createState() => _TextFieldFormWidgetState();
}

class _TextFieldFormWidgetState extends State<TextFieldFormWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.label,
        const SizedBox(height: 8),
        SizedBox(
          height: 50,
          child: TextFormField(
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(color: AppColors.mainBlack),

              //Default border
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.mainBlack),
              ),

              //Border color when the field is enabled
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.mainBlack),
              ),

              //Border color when the field is focused
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.mainBlack),
              ),
              
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10, 
                horizontal: 12,
              ),
            ),

            style: AppFonts.textFieldProperties,
            obscureText: widget.hiddenText ?? false,
            keyboardType: widget.textInputType,
            controller: widget.controller,
          ),
        ),
      ],
    );
  }
}
