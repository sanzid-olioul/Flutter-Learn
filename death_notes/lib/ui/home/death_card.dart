import 'package:flutter/material.dart';
import '../../data/models/death_note_model.dart';

class DeathCard extends StatelessWidget {
  final DeathNoteModel model;

  const DeathCard({required this.model});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Text(model.name),
        subtitle: Text(
          '${model.village}, ${model.para}\n${model.address}\n${model.deathDate.toLocal().toString().split(' ')[0]}',
        ),
        trailing: Icon(
          model.buried ? Icons.check_circle : Icons.cancel,
          color: model.buried ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
