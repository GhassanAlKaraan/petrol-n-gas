// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ImageFlagDropDown extends StatefulWidget {
  ImageFlagDropDown({super.key, required this.category, this.selectedVal});

  final String category;
  String? selectedVal;

  @override
  State<ImageFlagDropDown> createState() => _ImageFlagDropDownState();
}

class _ImageFlagDropDownState extends State<ImageFlagDropDown> {
  String? selectedValue = 'p1';

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectedVal;
    SelectedValueHolder.selectedValue = selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(255, 223, 244, 255),
      ),
      child: DropdownButton(
        icon: const Icon(
          Icons.menu,
          color: Colors.black,
        ),
        value: selectedValue,
        onChanged: (String? newValue) {
          setState(() {
            selectedValue = newValue;
            SelectedValueHolder.selectedValue = newValue;
            print(SelectedValueHolder.selectedValue);
          });
        },
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        underline: Container(
          height: 2,
          color: Colors.black,
        ),
        items: widget.category == 'petrol'
            ? const [
                DropdownMenuItem(value: 'p1', child: Text('p1')),
                DropdownMenuItem(value: 'p2', child: Text('p2')),
                DropdownMenuItem(value: 'p3', child: Text('p3')),
              ]
            : widget.category == 'gas'
                ? const [
                    DropdownMenuItem(value: 'g1', child: Text('g1')),
                  ]
                : const [
                    DropdownMenuItem(value: 'a1', child: Text('a1')),
                  ],
      ),
    );
  }
}

class SelectedValueHolder {
  static String? selectedValue;
}
