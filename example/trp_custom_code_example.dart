import 'package:flutter/material.dart';
import 'package:trp_custom_code/src/form_field_controller.dart';
import 'package:trp_custom_code/trp_custom_code.dart';


void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('Pinput Example'),
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color.fromRGBO(30, 60, 87, 1),
          ),
        ),
        body: Center(
          child: CustomDropDown(
            width: 100,
            height: 40,
            elevation: 1.0,
            borderWidth: 0.0,
            borderRadius: 0.0,
            options: ["Option 1", "Option 2", "Option 3"],
            hintText: "Select an option",
            searchHintText: "Search for an option",
            onChanged: (value) {
              print(value);
            },
            isSearchable: true,
            hidesUnderline: true,
            isOverButton: true,
            isMultiSelect: false,
            searchCursorColor: Colors.black,
            cont: FormFieldController<String?>(null),
          ),
        ),
      ),
    ),
  );
}
