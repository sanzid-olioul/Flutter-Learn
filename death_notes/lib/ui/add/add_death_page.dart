import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/death_note_provider.dart';
import '../../data/models/death_note_model.dart';

class AddDeathPage extends StatefulWidget {
  @override
  State<AddDeathPage> createState() => _AddDeathPageState();
}

class _AddDeathPageState extends State<AddDeathPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _village = TextEditingController();
  final _para = TextEditingController();
  final _address = TextEditingController();
  DateTime _date = DateTime.now();
  bool _buried = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _name.dispose();
    _village.dispose();
    _para.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final model = DeathNoteModel(
        id: '',
        name: _name.text.trim(),
        village: _village.text.trim(),
        para: _para.text.trim(),
        address: _address.text.trim(),
        deathDate: _date,
        buried: _buried,
      );
      
      await context.read<DeathNoteProvider>().addNote(model);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Death record added successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Death Info')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _name,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Name is required';
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _village,
                decoration: InputDecoration(
                  labelText: 'Village',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Village is required';
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _para,
                decoration: InputDecoration(
                  labelText: 'Para',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Para is required';
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _address,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Address is required';
                  return null;
                },
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text('Date of Death'),
                subtitle: Text(_date.toLocal().toString().split(' ')[0]),
                onTap: _selectDate,
                trailing: Icon(Icons.calendar_today),
              ),
              SizedBox(height: 16),
              SwitchListTile(
                title: Text('Buried'),
                value: _buried,
                onChanged: (v) => setState(() => _buried = v),
              ),
              SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSave,
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text('Save Record'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
