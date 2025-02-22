import 'package:dr_jaundice/core/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dr_jaundice/core/profile_bloc/profile_bloc.dart';

class ProfileEditDialog extends StatefulWidget {
  const ProfileEditDialog({super.key, this.isFirstLaunch = false});

  final bool isFirstLaunch;

  @override
  State<ProfileEditDialog> createState() => _ProfileEditDialogState();
}

class _ProfileEditDialogState extends State<ProfileEditDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _gestationalWeekController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isMale = true; // Add gender state


  void _fillValues() {
    if (!mounted) return;
    final profile = context.read<ProfileBloc>().profile;
    if (profile == null) return;
    
    _nameController.text = profile.name;
    _weightController.text = profile.weight.toString();
    _gestationalWeekController.text = profile.gestationalWeek.toString();
    _selectedDate = profile.birthDate;
    _selectedTime = profile.birthTime;
    _isMale = profile.gender == 'male';
  }


  @override
  void initState() {
    super.initState();
    if (!widget.isFirstLaunch) {
      _fillValues();
    }
  }

  void _saveProfile() {
    if (!mounted) return;

    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedTime != null) {
      final bloc = context.read<ProfileBloc>();
      // Check if the bloc is still active
      if (bloc.isClosed) {
        Navigator.pop(context);
        return;
      }
      
      bloc.add(
        SaveProfile(
          Profile(
            name: _nameController.text,
            birthDate: _selectedDate!,
            birthTime: _selectedTime!,
            weight: double.parse(_weightController.text),
            gender: _isMale ? 'male' : 'female',
            gestationalWeek: int.parse(_gestationalWeekController.text),
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return AlertDialog(
          title: Column(
            children: [
              if (widget.isFirstLaunch)
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 365)),
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
              onPressed: _saveProfile,
              child: const Text('保存'),
            ),
          ],
        );
      },
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
