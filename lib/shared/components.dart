import 'package:flutter/material.dart';

Widget textFormField({
  required TextEditingController textEditingController,
  required TextInputType? type,
   ValueChanged<String>? submit,
  required FormFieldValidator<String>? validator,
  required String label,
  required String hintText,
  required IconData prefixIcon,
  GestureTapCallback? onTap,
  int? lines,

})=> TextFormField(
  enableSuggestions: true,
  maxLines: lines,
  onTap: onTap,
  controller: textEditingController,
  keyboardType: type,
  onFieldSubmitted: submit,
  validator: validator,
  decoration: InputDecoration(
    labelText: label,
    hintText: hintText,
    prefixIcon: Icon(prefixIcon),
    isDense: true,
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5),),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5),),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5),),
    disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5),),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5),),
    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5),),

  ),
);