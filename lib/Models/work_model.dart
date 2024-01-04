class ProgramKerja {
  final int id;
  final String judul;
  final String deskripsi;
  final String tujuan;
  final String sasaran;
  final String penyelenggara;
  final String? hambatan; // Bisa null
  final String? evaluasi; // Bisa null
  final int fundsId;
  final String fundsName;
  final String status;
  final int jumlahAnggaran;
  final int jumlahRealisasi;
  final int tahunAnggaran;
  final String tanggal;
  final String? tanggalRealisasi; // Bisa null
  final String? dokumentasi; // Bisa null

  ProgramKerja({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.tujuan,
    required this.sasaran,
    required this.penyelenggara,
    this.hambatan,
    this.evaluasi,
    required this.fundsId,
    required this.fundsName,
    required this.status,
    required this.jumlahAnggaran,
    required this.jumlahRealisasi,
    required this.tahunAnggaran,
    required this.tanggal,
    this.tanggalRealisasi,
    this.dokumentasi,
  });

  factory ProgramKerja.fromJson(Map<String, dynamic> json) {
    return ProgramKerja(
      id: json['id'],
      judul: json['judul'],
      deskripsi: json['deskripsi'],
      tujuan: json['tujuan'],
      sasaran: json['sasaran'],
      penyelenggara: json['penyelenggara'],
      hambatan: json['hambatan'],
      evaluasi: json['evaluasi'],
      fundsId: json['fundsId'],
      fundsName: json['fundsName'],
      status: json['status'],
      jumlahAnggaran: json['jumlahAnggaran'],
      jumlahRealisasi: json['jumlahRealisasi'],
      tahunAnggaran: json['tahunAnggaran'],
      tanggal: json['tanggal'],
      tanggalRealisasi: json['tanggalRealisasi'],
      dokumentasi: json['dokumentasi'],
    );
  }
}
