class Penumpang {
  int? id;
  int idTravel;
  String kodeBooking;
  String nama;
  String jenisKelamin;
  String kota;
  int usia;
  int tahunLahir;
  String createdAt;

  Penumpang({
    this.id,
    required this.idTravel,
    required this.kodeBooking,
    required this.nama,
    required this.jenisKelamin,
    required this.kota,
    required this.usia,
    required this.tahunLahir,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_travel': idTravel,
      'kode_booking': kodeBooking,
      'nama': nama,
      'jenis_kelamin': jenisKelamin,
      'kota': kota,
      'usia': usia,
      'tahun_lahir': tahunLahir,
      'created_at': createdAt,
    };
  }

  factory Penumpang.fromMap(Map<String, dynamic> map) {
    return Penumpang(
      id: map['id'],
      idTravel: map['id_travel'],
      kodeBooking: map['kode_booking'],
      nama: map['nama'],
      jenisKelamin: map['jenis_kelamin'],
      kota: map['kota'],
      usia: map['usia'],
      tahunLahir: map['tahun_lahir'],
      createdAt: map['created_at'],
    );
  }
}
