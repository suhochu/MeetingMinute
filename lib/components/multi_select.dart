import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingminutes52/models/meeting_minute_controller.dart';
import 'package:meetingminutes52/models/models.dart' as model;

class MultiSelectDialogItem {
  const MultiSelectDialogItem(this.value, this.label);

  final int value;
  final String label;
}

class MultiSelectDialog extends StatefulWidget {
  const MultiSelectDialog({
    Key? key,
    this.title,
    this.items,
    this.initialSelectedValues,
  }) : super(key: key);

  final String? title;
  final List<MultiSelectDialogItem>? items;
  final Set<int>? initialSelectedValues;

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  final Set<int> _selectedValue = Set();

  @override
  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValue.addAll(widget.initialSelectedValues!.toSet());
    }
  }

  void _onItemCheckedChange(int itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValue.add(itemValue);
      } else {
        _selectedValue.remove(itemValue);
      }
    });
  }

  void _onCancelTap() {
    Get.back(result: widget.initialSelectedValues);
  }

  void _onSubmitTap() {
    Get.back(result: _selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title!),
      contentPadding: const EdgeInsets.only(top: 12.0),
      content: Container(
        height: 400,
        color: Colors.grey[200],
        child: SingleChildScrollView(
          child: ListTileTheme(
            contentPadding: const EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
            child: ListBody(
              children: widget.items!.map(_buildItem).toList(),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('CANCEL'),
          onPressed: _onCancelTap,
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: _onSubmitTap,
        ),
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem item) {
    final checked = _selectedValue.contains(item.value);
    return CheckboxListTile(
      value: checked,
      title: Text(item.label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked!),
    );
  }
}

Future<Widget?> showMultiSelect(BuildContext ctx, List<String> list) async {
  var controller = Get.put<MeetingMinuteController>(MeetingMinuteController());

  Set<int> dummySelectedValues = <int>{};

  var selectedItem = await showDialog(
    context: ctx,
    builder: (context) {
      return MultiSelectDialog(
        title: 'Select Item(s)',
        items: items(list),
        initialSelectedValues: controller.selectedValues,
      );
    },
  );
  if(selectedItem != null) {
    dummySelectedValues = selectedItem;
  }

  controller.editingSelectedValues(dummySelectedValues);
}

List<MultiSelectDialogItem> items(List<String> list) {

  return List.generate(list.length,
    (index) => MultiSelectDialogItem(index, list[index]));}
