import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController? controller;
  final Widget? prefix;
  final String labelText;
  final Widget? suffix;
  final bool isPassword;
  final TextInputType inputType;
  final String? Function(String? value)? validator;
  final VoidCallback? onTap;
  final int? maxLength;

  const InputField({
    Key? key,
    required this.labelText,
    this.controller,
    this.prefix,
    this.maxLength,
    this.suffix,
    this.isPassword = false,
    this.inputType = TextInputType.text,
    this.validator,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: validator,
      onSaved: (newValue) {
        if (controller != null) {
          controller!.text = newValue!;
        }
      },
      builder: (field) {
        if (controller != null) {
          // ignore: invalid_use_of_protected_member
          field.setValue(controller!.text);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: onTap,
              child: Container(
                decoration: onTap != null
                    ? BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black12,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : null,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        enabled: onTap == null,
                        onChanged: (value) {
                          field.didChange(value);
                        },
                        minLines: 1,
                        maxLength: maxLength,
                        maxLines: inputType == TextInputType.multiline ? 5 : 1,
                        controller: controller,
                        keyboardType: inputType,
                        obscureText: isPassword,
                        decoration: InputDecoration(
                          enabled: true,
                          labelText: labelText,
                          border: InputBorder.none,
                          prefix: prefix,
                        ),
                      ),
                    ),
                    if (onTap != null)
                      if (suffix != null) suffix!,
                    if (onTap != null)
                      const SizedBox(
                        width: 4,
                      ),
                  ],
                ),
              ),
            ),
            if (field.hasError) ...[
              const SizedBox(
                height: 2,
              ),
              Text(
                field.errorText!,
                style: TextStyle(
                  color: Theme.of(context).errorColor,
                ),
              ),
            ]
          ],
        );
      },
    );
  }
}
