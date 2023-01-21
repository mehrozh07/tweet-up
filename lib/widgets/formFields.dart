import 'package:flutter/material.dart';

formField(controller, title, context) {
  return Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 8),
    child: TextFormField(
      validator: ((value) => value!.isEmpty ? 'Enter a value' : null),
      controller: controller,
      decoration: InputDecoration(
        hintText: title,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
      ),
    ),
  );
}
