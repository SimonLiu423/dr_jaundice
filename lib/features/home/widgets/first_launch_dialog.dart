import 'package:dr_jaundice/core/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dr_jaundice/core/profile_bloc/profile_bloc.dart';

class FirstLaunchDialog extends StatefulWidget {
  const FirstLaunchDialog({super.key});

  @override
  State<FirstLaunchDialog> createState() => _FirstLaunchDialogState();
}

class _FirstLaunchDialogState extends State<FirstLaunchDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _gestationalWeekController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isMale = true; // Add gender state

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Column(
        children: [
          Text('歡迎使用本軟體', style: TextStyle(fontSize: 26)),
          Text('請輸入小朋友的個人資料', style: TextStyle(fontSize: 20)),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '姓名',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '請輸入小朋友的姓名';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _gestationalWeekController,
                decoration: const InputDecoration(
                  labelText: '懷孕週數',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '請輸入懷孕週數';
                  }
                  if (int.tryParse(value) == null) {
                    return '請輸入正確的懷孕週數';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: '體重(kg)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '請輸入體重';
                  }
                  if (double.tryParse(value) == null) {
                    return '請輸入正確的體重';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '性別',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Switch(
                    value: _isMale,
                    onChanged: (value) {
                      setState(() {
                        _isMale = value;
                      });
                    },
                    activeTrackColor: Colors.blue.shade200,
                    activeColor: Colors.blue,
                    inactiveTrackColor: Colors.red.shade200,
                    inactiveThumbColor: Colors.red,
                    thumbIcon: WidgetStateProperty.resolveWith((states) {
                      return Icon(_isMale ? Icons.male : Icons.female);
                    }),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '生日',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(_selectedDate == null
                      ? '尚未設定'
                      : '${_selectedDate!.year}/${_selectedDate!.month}/${_selectedDate!.day}'),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.orangeAccent.shade200,
                      foregroundColor: Colors.blueGrey,
                    ),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          _selectedDate = date;
                        });
                      }
                    },
                    child: const Text('選擇'),
                    // child: const Icon(Icons.calendar_today),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '生時',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(_selectedTime == null
                      ? '尚未設定'
                      : _selectedTime!.format(context)),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.orangeAccent.shade200,
                      foregroundColor: Colors.blueGrey,
                    ),
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() {
                          _selectedTime = time;
                        });
                      }
                    },
                    child: const Text('選擇'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate() &&
                _selectedDate != null &&
                _selectedTime != null) {
              context.read<ProfileBloc>().add(
                    SaveProfile(
                      Profile(
                        name: _nameController.text,
                        birthDate: _selectedDate!,
                        birthTime: _selectedTime!,
                        weight: double.parse(_weightController.text),
                        gender: _isMale ? 'male' : 'female',
                        gestationalWeek:
                            int.parse(_gestationalWeekController.text),
                      ),
                    ),
                  );
              Navigator.pop(context);
            }
          },
          child: const Text('保存'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _gestationalWeekController.dispose();
    super.dispose();
  }
}
