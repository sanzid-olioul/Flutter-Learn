import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/death_note_model.dart';

class DeathNoteRepository {
  final _collection = FirebaseFirestore.instance.collection('death_notes');

  Stream<List<DeathNoteModel>> getNotes() {
    return _collection
        .orderBy('deathDate', descending: true)
        .snapshots(includeMetadataChanges: false)
        .handleError((error) {
          throw Exception(error.toString());
        })
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => DeathNoteModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> addNote(DeathNoteModel model) async {
    await _collection.add(model.toMap());
  }
}
