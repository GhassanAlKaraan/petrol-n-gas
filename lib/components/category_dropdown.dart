import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CategoryDropDown extends StatefulWidget {
  const CategoryDropDown({super.key});


  @override
  State<CategoryDropDown> createState() => _CategoryDropDownState();
}

class _CategoryDropDownState extends State<CategoryDropDown> {
  String? selectedValue = 'petrol';

  @override
  void initState() {
    super.initState();
    SelectedCategoryHolder.selectedValue = selectedValue!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 100,
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
            SelectedCategoryHolder.selectedValue = newValue!;
            // print(SelectedValueHolder.selectedValue);
          });
        },
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        underline: Container(
          height: 2,
          color: Colors.black,
        ),
        items: const [
                DropdownMenuItem(value: 'petrol', child: Text('Petrol')),
                DropdownMenuItem(value: 'gas', child: Text('Gas')),
                DropdownMenuItem(value: 'accessory', child: Text('Accessory')),
              ]
      ),
    );
  }
}

class SelectedCategoryHolder {
  static String selectedValue = 'petrol';
}
