import 'package:flutter/material.dart';
import 'package:reservation/feature/profile_page/model/table_model.dart';

class TableItemCard extends StatefulWidget {
  const TableItemCard(
      {super.key, required this.model, this.updateFunction, allowEditing})
      : allowEditing = allowEditing ?? true;

  final TableModel model;
  final void Function(TableModel model)? updateFunction;
  final bool allowEditing;

  @override
  State<TableItemCard> createState() => _TableItemCardState();
}

class _TableItemCardState extends State<TableItemCard> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    var tableModel = widget.model;
    return SizedBox(
      child: GestureDetector(
        onTap: () {
          if (widget.allowEditing) {
            setState(() {
              _isEditing = true;
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.allowEditing)
                    _isEditing
                        ? SizedBox(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      setState(() {
                                        _isEditing = false;
                                      });
                                    }
                                  },
                                  child: const Icon(Icons.save),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _formKey.currentState?.reset();
                                    setState(() {
                                      _isEditing = false;
                                    });
                                  },
                                  child: const Icon(Icons.undo),
                                ),
                              ],
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                _isEditing = true;
                              });
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.edit),
                              ],
                            ),
                          ),
                  TextFormField(
                    initialValue: tableModel.ref,
                    decoration: const InputDecoration(labelText: 'Reference'),
                    readOnly: !_isEditing,
                    onSaved: (value) => tableModel.ref = value,
                  ),
                  if (widget.allowEditing) ...[
                    SwitchListTile(
                      title: const Text('Allow Manual Size'),
                      value: tableModel.allowManualSize ?? false,
                      onChanged: _isEditing
                          ? (bool value) {
                              setState(() {
                                tableModel.allowManualSize = value;
                              });
                            }
                          : null,
                    ),
                    SwitchListTile(
                      title: const Text('Can Extend'),
                      value: tableModel.canExtend ?? false,
                      onChanged: _isEditing
                          ? (bool value) {
                              setState(() {
                                tableModel.canExtend = value;
                              });
                            }
                          : null,
                    ),
                    TextFormField(
                      initialValue: tableModel.occupancy?.toString(),
                      decoration: const InputDecoration(labelText: 'Occupancy'),
                      readOnly: !_isEditing,
                      keyboardType: TextInputType.number,
                      onSaved: (value) =>
                          tableModel.occupancy = int.tryParse(value!),
                    )
                  ],
                  TextFormField(
                    initialValue: tableModel.description,
                    decoration: const InputDecoration(labelText: 'Description'),
                    readOnly: !_isEditing,
                    onSaved: (value) => tableModel.description = value,
                  ),
                  if (!widget.allowEditing) ...[
                    (tableModel.allowManualSize ?? false)
                        ? const Text("Allowed to change the table size")
                        : Container(),
                    (tableModel.canExtend ?? false)
                        ? const Text("Can extend the table occupancy")
                        : Container(),
                    Text(
                        "Maximum occupancy is ${tableModel.occupancy?.toString()}"),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
