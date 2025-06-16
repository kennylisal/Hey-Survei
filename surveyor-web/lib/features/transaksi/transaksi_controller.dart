import 'dart:convert';

import 'package:hei_survei/features/transaksi/model/sejarah_order.dart';
import 'package:hei_survei/utils/backend.dart';
import 'package:hei_survei/constants.dart';
import 'package:hei_survei/features/transaksi/model/oder_data.dart';
import 'package:hei_survei/features/katalog/model/survei_data.dart';
import 'package:hei_survei/features/transaksi/model/order_survei.dart';
import 'package:hei_survei/features/transaksi/model/transaksi.dart';

import 'package:shared_preferences/shared_preferences.dart';

class TransaksiController {
  Future<Order?> getOrderPilihan(String idOrder) async {
    //order cuman selalu satu
    try {
      String query = """
query Query(\$idOrder: String!) {
  getOrderPilihan(idOrder: \$idOrder) {
    code,status,data {
    idOrder,hargaTotal,idUser,listCarts,tanggal,listSurvei {
      batasPartisipan,deskripsi,harga,id_survei,judul,jumlahPartisipan,kategori,status,tanggal_penerbitan,
      isKlasik,idUser,durasi,hargaJual
    }
  }
  }
}
  """;
      final data = await Backend().serverConnection(query: query, mapVariable: {
        "idOrder": idOrder,
      });
      if (data!['getOrderPilihan']['code'] == 200) {
        Map<String, dynamic> dataOrder = data['getOrderPilihan']['data'];
        print(dataOrder);
        Order hasil = Order.fromJson(json.encode(dataOrder));
        return hasil;
      } else if (data['getOrderPilihan']['code'] == 400) {
        return null;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString() + "poejdhui");
      return null;
    }
  }

  Future<bool> hapusCart(String idCart) async {
    try {
      String request = """ 
mutation Mutation(\$idCart: String!) {
  hapusCart(idCart: \$idCart) {
    code,data,status
  }
}
    """;
      final data =
          await Backend().serverConnection(query: request, mapVariable: {
        "idCart": idCart,
      });
      if (data!['hapusCart']['code'] == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<List<Transaksi>> getSejarahTransUser() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? idUser = prefs.getString(prefUserId);
      String query = """
query GetSejarahUser(\$idUser: String!) {
  getSejarahUser(idUser: \$idUser) {
    code,code,data {
      idTrans,invoice,tanggalTransaksi,totalHarga,detail {
        caraPembayaran,listSurvei {
          deskripsi,harga,id_survei,judulSurvei,isKlasik
        }
      }
    }
  }
}
    """;
      // String temp = 'xxxx';
      final data = await Backend().serverConnection(query: query, mapVariable: {
        // "idUser": (isModeTesting) ? "70fc9a56" : idUser,
        "idUser": idUser,
      });
      if (data!['getSejarahUser']['code'] == 200) {
        List<Object?> temp = data["getSejarahUser"]["data"];
        List<Transaksi> hasil = List.generate(temp.length,
            (index) => Transaksi.fromJson(json.encode(temp[index])));
        return hasil;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<OrderHeader>> getSejarahOrder() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? idUser = prefs.getString(prefUserId);
      String query = """
query Query(\$idUser: String!) {
  getSejarahOrder(idUser: \$idUser) {
    code,status,data {
      hargaTotal,idOrder,idUser,listCarts,listDetailSurvei,tanggal,invoice
    }
  }
}
    """;
      final data = await Backend().serverConnection(query: query, mapVariable: {
        "idUser": idUser,
      });
      // print("ini sejarah order $data");
      if (data!['getSejarahOrder']['code'] == 200) {
        List<Object?> temp = data["getSejarahOrder"]["data"];
        List<OrderHeader> hasil = List.generate(temp.length,
            (index) => OrderHeader.fromJson(json.encode(temp[index])));
        return hasil;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<Order?> getUserOrder() async {
    //order cuman selalu satu
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? idUser = prefs.getString(prefUserId);
      String query = """
query Query(\$idUser: String!) {
getOrderUser(idUser: \$idUser) {
  code,status,data {
    idOrder,hargaTotal,idUser,listCarts,tanggal,listSurvei {
      batasPartisipan,deskripsi,harga,id_survei,judul,jumlahPartisipan,kategori,status,tanggal_penerbitan,
      isKlasik,idUser,durasi,hargaJual
    }
  }
}
}
  """;
      final data = await Backend().serverConnection(query: query, mapVariable: {
        "idUser": idUser,
      });
      if (data!['getOrderUser']['code'] == 200) {
        Map<String, dynamic> dataOrder = data['getOrderUser']['data'];
        print(dataOrder);
        Order hasil = Order.fromJson(json.encode(dataOrder));
        return hasil;
      } else if (data['getOrderUser']['code'] == 400) {
        return null;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString() + "oyoyoy");
      return null;
    }
  }

  Future<int> getJumlahKeranjang() async {
    //order cuman selalu satu
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? idUser = prefs.getString(prefUserId);
      String query = """
query Query(\$idUser: String!) {
  getJumlahKeranjang(idUser: \$idUser) {
    code
    data
    status
  }
}
  """;
      final data = await Backend().serverConnection(query: query, mapVariable: {
        "idUser": idUser,
      });
      if (data!['getJumlahKeranjang']['code'] == 200) {
        int hasil = data['getJumlahKeranjang']['data'] as int;
        return hasil;
      } else {
        return -1;
      }
    } catch (e) {
      print(e.toString() + "oyoyoy");
      return -1;
    }
  }

  Future<bool> getStatusOrder() async {
    //order cuman selalu satu
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? idUser = prefs.getString(prefUserId);
      String query = """
query Query(\$idUser: String!) {
  getJumlahOrder(idUser: \$idUser) {
    code
    data
    status
  }
}
  """;
      final data = await Backend().serverConnection(query: query, mapVariable: {
        "idUser": idUser,
      });
      if (data!['getJumlahOrder']['code'] == 200) {
        int hasil = data['getJumlahOrder']['data'] as int;
        return (hasil > 0);
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString() + "oyoyoy");
      return false;
    }
  }

  Future<DataCart> getUserCart() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? idUser = prefs.getString(prefUserId);
      String query = """
query Query(\$idUser: String!) {
  getCartKu(idUser: \$idUser) {
    code,status,listCart,data {
      batasPartisipan,deskripsi,harga,id_survei,judul,jumlahPartisipan,kategori,status,tanggal_penerbitan,
      isKlasik,idUser,durasi,hargaJual,gambarSurvei
    }
  }
}
    """;
      final data = await Backend().serverConnection(query: query, mapVariable: {
        "idUser": idUser,
      });
      if (data!['getCartKu']['code'] == 200) {
        List<Object?> dataSurvei = data["getCartKu"]["data"];
        List<SurveiData> list = List.generate(dataSurvei.length,
            (index) => SurveiData.fromJson(json.encode(dataSurvei[index])));
        List<Object?> listTemp = data["getCartKu"]["listCart"];
        List<String> listIdCart = List.generate(
            listTemp.length, (index) => listTemp[index] as String);
        DataCart dataCart = DataCart(idCart: listIdCart, hSurvei: list);
        return dataCart;
      } else {
        return DataCart(idCart: [], hSurvei: []);
      }
    } catch (e) {
      print(e.toString() + "ayaya");
      return DataCart(idCart: [], hSurvei: []);
    }
  }

  Future<bool> buatOrder({
    required List<String> listSurvei,
    required List<String> listCart,
    required int harga,
    required String email,
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? idUser = prefs.getString(prefUserId);
      String query = """
mutation Mutation(\$order: orderInput!, \$idUser: String!) {
  buatOrder(order: \$order, idUser: \$idUser) {
    code,data,status
  }
}
    """;
      final data = await Backend().serverConnection(query: query, mapVariable: {
        'order': {
          'listSurvei': listSurvei,
          'listCarts': listCart,
          'harga': harga,
          'email': email
        },
        "idUser": idUser,
      });
      if (data!['buatOrder']['code'] == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
