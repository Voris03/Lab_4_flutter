
import 'package:flutter/material.dart';
import '../database.dart';
import '../models.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  late List<Appointment> _appointments;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    _appointments = await _dbHelper.getAppointments();
    setState(() {});
  }

  void _addAppointment() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => AppointmentForm(
      onSubmit: (newAppointment) async {
        await _dbHelper.insertAppointment(newAppointment);
        _loadAppointments();
      },
    )));
  }

  void _editAppointment(Appointment appointment) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => AppointmentForm(
      appointment: appointment,
      onSubmit: (updatedAppointment) async {
        await _dbHelper.updateAppointment(updatedAppointment);
        _loadAppointments();
      },
    )));
  }

  void _deleteAppointment(int id) async {
    await _dbHelper.deleteAppointment(id);
    _loadAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addAppointment,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _appointments.length,
        itemBuilder: (context, index) {
          final appointment = _appointments[index];
          return ListTile(
            title: Text(appointment.title),
            subtitle: Text(appointment.description),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteAppointment(appointment.id),
            ),
            onTap: () => _editAppointment(appointment),
          );
        },
      ),
    );
  }
}

// Форма для добавления/редактирования встреч
class AppointmentForm extends StatefulWidget {
  final Appointment? appointment;
  final Function(Appointment) onSubmit;

  const AppointmentForm({super.key, this.appointment, required this.onSubmit});

  @override
  _AppointmentFormState createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.appointment != null) {
      _titleController.text = widget.appointment!.title;
      _descriptionController.text = widget.appointment!.description;
      _selectedDate = widget.appointment!.date;
    }
  }

  void _submit() {
    if (_titleController.text.isNotEmpty && _selectedDate != null) {
      final newAppointment = Appointment(
        id: widget.appointment?.id ?? 0,
        title: _titleController.text,
        description: _descriptionController.text,
        date: _selectedDate!,
      );
      widget.onSubmit(newAppointment);
      Navigator.of(context).pop();
    }
  }

  void _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appointment == null ? 'New Appointment' : 'Edit Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            Row(
              children: [
                Text(_selectedDate != null
                    ? 'Date: ${_selectedDate!.toLocal()}'.split(' ')[0]
                    : 'No Date Chosen'),
                TextButton(
                  onPressed: _pickDate,
                  child: const Text('Choose Date'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
