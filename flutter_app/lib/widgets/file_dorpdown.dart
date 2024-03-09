import 'package:flutter/material.dart';

class FileDropdown extends StatelessWidget {
  final List<String> files;
  final String? selectedFile;
  final ValueChanged<String?> onChanged;

  const FileDropdown({
    Key? key,
    required this.files,
    required this.onChanged,
    this.selectedFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      isExpanded: true,
      hint: Text('Select a CSV file'),
      value: selectedFile,
      onChanged: onChanged,
      items: files.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value.split('/').last),
        );
      }).toList(),
    );
  }
}
