enum TipePertanyaan {
  pertanyaanKlasik,
  pertanyaanKartu,
  pertanyaanKlasikCabang,
  pertanyaanKartuCabang,
  pembatasPertanyaan,
}

enum Tipesoal {
  pilihanGanda,
  kotakCentang,
  sliderAngka,
  gambarGanda,
  carousel,
  urutanPilihan,
  teks,
  paragraf,
  imagePicker,
  angka,
  tabel,
  waktu,
  tanggal,
}

extension TipeSoalString on Tipesoal {
  String get value {
    switch (this) {
      case Tipesoal.angka:
        return "Angka";
      case Tipesoal.carousel:
        return "Carousel";
      case Tipesoal.gambarGanda:
        return "Gambar Ganda";
      case Tipesoal.imagePicker:
        return "Image Picker";
      case Tipesoal.kotakCentang:
        return "Kotak Centang";
      case Tipesoal.paragraf:
        return "Teks Paragraf";
      case Tipesoal.pilihanGanda:
        return "Pilihan Ganda";
      case Tipesoal.sliderAngka:
        return "Slider Angka";
      case Tipesoal.tabel:
        return "Tabel";
      case Tipesoal.tanggal:
        return "Tanggal";
      case Tipesoal.teks:
        return "Teks";
      case Tipesoal.urutanPilihan:
        return "Urutan Pilihan";
      case Tipesoal.waktu:
        return "Waktu";
    }
  }
}
