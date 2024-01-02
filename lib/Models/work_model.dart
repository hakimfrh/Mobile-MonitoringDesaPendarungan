class ProgramKerja {
  final int id;
  final String judul;
  final String tanggal;
  final String fundsName;
  final int jumlahAnggaran;
  final int jumlahRealisasi;
  final int sisaDana;
  final String status;
  final String deskripsi;
  final String hambatan;
  final String evaluasi;

  ProgramKerja({
    required this.id,
    required this.judul,
    required this.tanggal,
    required this.fundsName,
    required this.jumlahAnggaran,
    required this.jumlahRealisasi,
    required this.sisaDana,
    required this.status,
    required this.deskripsi,
    required this.hambatan,
    required this.evaluasi,
  });

  factory ProgramKerja.fromJson(Map<String, dynamic> json) {
    return ProgramKerja(
      id: json['id'],
      judul: json['judul'],
      tanggal: json['tanggal'],
      fundsName: json['fundsName'],
      jumlahAnggaran: int.parse(json['jumlahAnggaran'].toString()),
      jumlahRealisasi: int.parse(json['jumlahRealisasi'].toString()),
      sisaDana: int.parse(json['jumlahAnggaran'].toString()) -
          int.parse(json['jumlahRealisasi'].toString()),
      status: json['status'],
      deskripsi: json['deskripsi'] ?? '',
      hambatan: json['hambatan'] ?? '',
      evaluasi: json['evaluasi'] ?? '',
    );
  }
}
