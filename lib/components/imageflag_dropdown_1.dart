// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ImageFlagDropDown1 extends StatefulWidget {
  const ImageFlagDropDown1({super.key, required this.category});

  final String category;

  @override
  State<ImageFlagDropDown1> createState() => _ImageFlagDropDown1State();
}

class _ImageFlagDropDown1State extends State<ImageFlagDropDown1> {
  String? selectedValue = 'p1';

  String getFirstFlag() {
    if (widget.category == 'petrol') {
      return 'p1';
    } else if (widget.category == 'gas') {
      return 'g1';
    } else if (widget.category == 'accessory') {
      return 'a1';
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    selectedValue = getFirstFlag();
    SelectedValueHolder1.selectedValue = selectedValue;
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
            SelectedValueHolder1.selectedValue = newValue;
            print(SelectedValueHolder1.selectedValue);
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
                    DropdownMenuItem(value: 'a2', child: Text('a2')),
                    DropdownMenuItem(value: 'a3', child: Text('a3')),
                  ],
      ),
    );
  }
}

class SelectedValueHolder1 {
  static String? selectedValue;
}
