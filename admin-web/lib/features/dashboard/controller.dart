import 'dart:convert';

import 'package:aplikasi_admin/features/master_survei/survei.dart';
import 'package:aplikasi_admin/utils/backend.dart';

class DashboardController {
  Future<int> getJumlahSurveiAktif() async {
    try {
      String request = """
query GetJumlahSurveiAktif {
  getJumlahSurveiAktif {
    code,data,status
  }
}
      """;
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: request, mapVariable: {});
      // print(data);
      if (data!['getJumlahSurveiAktif']['code'] == 200) {
        return data['getJumlahSurveiAktif']['data'] as int;
      } else {
        return -1;
      }
    } catch (e) {
      print(e);
      return -1;
    }
  }

  Future<int> getJumlahUserAktif() async {
    try {
      String request = """
query GetUserAktif {
  getUserAktif {
    code,data,status
  }
}
      """;
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: request, mapVariable: {});
      // print(data);
      if (data!['getUserAktif']['code'] == 200) {
        return data['getUserAktif']['data'] as int;
      } else {
        return -1;
      }
    } catch (e) {
      print(e);
      return -1;
    }
  }

  Future<int> getJumlahSurveiTerbeli() async {
    try {
      String request = """
query GetJumlahSurveiTerbeli {
  getJumlahSurveiTerbeli {
    code,data,status
  }
}
      """;
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: request, mapVariable: {});
      // print(data);
      if (data!['getJumlahSurveiTerbeli']['code'] == 200) {
        return data['getJumlahSurveiTerbeli']['data'] as int;
      } else {
        return -1;
      }
    } catch (e) {
      print(e);
      return -1;
    }
  }

  Future<int> getJumlahSurveiTerjawab() async {
    try {
      String request = """
query GetJumlahTerjawab {
  getJumlahTerjawab {
    code,status,data
  }
}
      """;
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: request, mapVariable: {});
      // print(data);
      if (data!['getJumlahTerjawab']['code'] == 200) {
        return data['getJumlahTerjawab']['data'] as int;
      } else {
        return -1;
      }
    } catch (e) {
      print(e);
      return -1;
    }
  }

  Future<int> getKeuntunganTotal() async {
    try {
      String request = """
query GetKeuntunganHSurvei {
getKeuntunganHSurvei {
  code,data,status
}
}
    """;
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: request, mapVariable: {});
      // print(data);
      if (data!['getKeuntunganHSurvei']['code'] == 200) {
        return data['getKeuntunganHSurvei']['data'] as int;
      } else {
        return -1;
      }
    } catch (e) {
      print(e);
      return -1;
    }
  }

  Future<int> getKeuntunganOrder() async {
    try {
      String request = """
query GetBerdasarkanBulan {
  getKeuntunganOrder {
    code,data,status
  }
}
    """;
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: request, mapVariable: {});
      // print(data);
      if (data!['getKeuntunganOrder']['code'] == 200) {
        return data['getKeuntunganOrder']['data'] as int;
      } else {
        return -1;
      }
    } catch (e) {
      print(e);
      return -1;
    }
  }

  Future<int> getPublishedBulan(int bulan) async {
    //bulan dalam angka 1 - 12
    try {
      String request = """
query GetBerdasarkanBulan(\$bulan: Int!) {
  getBerdasarkanBulan(bulan: \$bulan) {
    code,data,status
  }
}
      """;
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: request, mapVariable: {
        'bulan': bulan,
      });
      // print(data);
      if (data!['getBerdasarkanBulan']['code'] == 200) {
        return data['getBerdasarkanBulan']['data'] as int;
      } else {
        return -1;
      }
    } catch (e) {
      print(e);
      return -1;
    }
  }

  Future<int> getJumlahSurveiBanned() async {
    //bulan dalam angka 1 - 12
    try {
      String request = """
query GetSurveiBanned {
  getSurveiBanned {
    code,data,status
  }
}
      """;
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: request, mapVariable: {});
      // print(data);
      if (data!['getSurveiBanned']['code'] == 200) {
        return data['getSurveiBanned']['data'] as int;
      } else {
        return -1;
      }
    } catch (e) {
      print(e);
      return -1;
    }
  }

  Future<List<SurveiData>> getSurveiTerbaru() async {
    try {
      List<SurveiData> hasil = [];
      String request = """
query GetSurveiBanned {
getHSurveiTerbaru {
  code,status,data {
    batasPartisipan,deskripsi,durasi,harga,id_survei,isKlasik,judul,jumlahPartisipan,kategori,status,tanggal_penerbitan,emailUser,hargaJual
  }
}
}

    """;

      Map<String, dynamic>? data =
          await Backend().serverConnection(query: request, mapVariable: {});
      if (data!['getHSurveiTerbaru']['code'] == 200) {
        List<Object?> dataHSurvei = data['getHSurveiTerbaru']['data'];
        hasil = List.generate(dataHSurvei.length,
            (index) => SurveiData.fromJson(json.encode(dataHSurvei[index])));
      }
      return hasil;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
