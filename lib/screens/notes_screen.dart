
import 'package:flutter/material.dart';
import '../database.dart';
import '../models.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late List<Note> _notes;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    _notes = await _dbHelper.getNotes();
    setState(() {});
  }

  void _addNote() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => NoteForm(
      onSubmit: (newNote) async {
        await _dbHelper.insertNote(newNote);
        _loadNotes();
      },
    )));
  }

  void _editNote(Note note) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => NoteForm(
      note: note,
      onSubmit: (updatedNote) async {
        await _dbHelper.updateNote(updatedNote);
        _loadNotes();
      },
    )));
  }

  void _deleteNote(int id) async {
    await _dbHelper.deleteNote(id);
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNote,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return ListTile(
            title: Text(note.title),
            subtitle: Text(note.content),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteNote(note.id),
            ),
            onTap: () => _editNote(note),
          );
        },
      ),
    );
  }
}

class NoteForm extends StatefulWidget {
  final Note? note;
  final Function(Note) onSubmit;

  const NoteForm({super.key, this.note, required this.onSubmit});

  @override
  _NoteFormState createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  void _submit() {
    if (_titleController.text.isNotEmpty && _contentController.text.isNotEmpty) {
      final newNote = Note(
        id: widget.note?.id ?? 0,
        title: _titleController.text,
        content: _contentController.text,
        date: DateTime.now(),
      );
      widget.onSubmit(newNote);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
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
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content'),
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
