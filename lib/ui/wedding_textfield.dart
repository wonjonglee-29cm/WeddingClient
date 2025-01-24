import 'package:flutter/material.dart';

class WeddingTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final String? labelText;
  final int? maxLength;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final InputDecoration? decoration;

  const WeddingTextField({
    super.key,
    this.controller,
    this.hint,
    this.labelText,
    this.maxLength,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.validator,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            TextFormField(
              controller: controller,
              maxLength: maxLength,
              onChanged: onChanged,
              validator: validator,
              obscureText: obscureText,
              keyboardType: keyboardType,
              decoration: (decoration ?? InputDecoration(
                hintText: hint,
                labelText: labelText,
                border: const OutlineInputBorder(),
              )).copyWith(
                counterText: '',
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
            ),
            if (maxLength != null)
              Positioned(
                right: 16,
                bottom: 16,
                child: ValueListenableBuilder(
                  valueListenable: controller!,
                  builder: (context, value, child) => Text(
                    '${value.text.length}/$maxLength',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}