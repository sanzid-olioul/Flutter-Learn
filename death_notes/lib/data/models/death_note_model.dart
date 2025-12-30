class DeathNoteModel {
  final String id;
  final String name;
  final String village;
  final String para;
  final String address;
  final DateTime deathDate;
  final bool buried;

  DeathNoteModel({
    required this.id,
    required this.name,
    required this.village,
    required this.para,
    required this.address,
    required this.deathDate,
    required this.buried,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'village': village,
      'para': para,
      'address': address,
      'deathDate': deathDate.toIso8601String(),
      'buried': buried,
    };
  }

  factory DeathNoteModel.fromMap(String id, Map<String, dynamic> map) {
    return DeathNoteModel(
      id: id,
      name: map['name'] ?? '',
      village: map['village'] ?? '',
      para: map['para'] ?? '',
      address: map['address'] ?? '',
      deathDate: DateTime.parse(map['deathDate']),
      buried: map['buried'] ?? false,
    );
  }
}
