import 'package:flutter/material.dart';
import '../data/models/death_note_model.dart';
import '../data/repositories/death_note_repository.dart';

class DeathNoteProvider extends ChangeNotifier {
  final DeathNoteRepository _repo;
  Stream<List<DeathNoteModel>>? _cachedStream;

  int? year;
  int? month;

  DeathNoteProvider(this._repo);

  Stream<List<DeathNoteModel>> get notesStream {
    _cachedStream ??= _repo.getNotes().map((notes) {
      return notes.where((note) {
        final matchYear = year == null || note.deathDate.year == year;
        final matchMonth = month == null || note.deathDate.month == month;
        return matchYear && matchMonth;
      }).toList();
    });
    return _cachedStream!;
  }

  void setFilter(int? y, int? m) {
    year = y;
    month = m;
    notifyListeners();
  }

  Future<void> addNote(DeathNoteModel model) async {
    await _repo.addNote(model);
  }
}
