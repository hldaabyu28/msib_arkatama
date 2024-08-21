class Travel {
  int? id;
  String tanggalKeberangkatan;
  int kuota;

  Travel({
    this.id,
    required this.tanggalKeberangkatan,
    required this.kuota,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tanggal_keberangkatan': tanggalKeberangkatan,
      'kuota': kuota,
    };
  }

  factory Travel.fromMap(Map<String, dynamic> map) {
    return Travel(
      id: map['id'],
      tanggalKeberangkatan: map['tanggal_keberangkatan'],
      kuota: map['kuota'],
    );
  }
}
