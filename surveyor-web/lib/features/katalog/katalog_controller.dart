import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hei_survei/utils/backend.dart';
import 'package:hei_survei/constants.dart';
import 'package:hei_survei/features/katalog/model/kategori.dart';
import 'package:hei_survei/features/katalog/model/survei_data.dart';
import 'package:hei_survei/utils/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KatalogController {
  //ingat nanti bikin yg survei-dibeli juga
  // Future<List<String>> getSurveiPengecualian() async {
  //   try {
  //     List<String> hasil = [];
  //     String idUser = SharedPrefs.getString(prefUserId) ?? "70fc9a56";
  //     String request = """
  //       query Query(\$idUser: String!) {
  //         surveiPengecualianSearch(idUser: \$idUser) {
  //           code,data,status
  //         }
  //       }
  //     """;
  //     Map<String, dynamic>? data =
  //         await Backend().serverConnection(query: request, mapVariable: {
  //       "idUser": idUser,
  //     });
  //     if (data!['surveiPengecualianSearch']['code'] == 200) {
  //       List<Object?> result = data['surveiPengecualianSearch']['data'];
  //       hasil =
  //           List.generate(result.length, (index) => result[index] as String);
  //     } else {
  //       return [];
  //     }
  //     return hasil;
  //   } catch (e) {
  //     print(e);
  //     return [];
  //   }
  // }

  Future<List<String>> getSurveiPengecualian() async {
    try {
      List<String> hasil = [];
      String idUser = SharedPrefs.getString(prefUserId) ?? "70fc9a56";
      String request = """
query Query(\$idUser: String!) {
  getSurveiPengecualian(idUser: \$idUser) {
    code,data,status
  }
}
      """;
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: request, mapVariable: {
        "idUser": idUser,
      });
      if (data!['getSurveiPengecualian']['code'] == 200) {
        List<Object?> result = data['getSurveiPengecualian']['data'];
        hasil =
            List.generate(result.length, (index) => result[index] as String);
      } else {
        return [];
      }
      return hasil;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> masukkanCart(String idSurvei, BuildContext context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? idUser = prefs.getString(prefUserId);
      String request = """
mutation Mutation(\$idSurvei: String!, \$idUser: String!) {
  buatCart(idSurvei: \$idSurvei, idUser: \$idUser) {
    code,data,status
  }
}
      """;
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: request, mapVariable: {
        // "idUser": (isModeTesting) ? "70fc9a56" : idUser,
        "idUser": idUser,
        "idSurvei": idSurvei,
      });
      if (data!['buatCart']['code'] == 200) {
        if (!context.mounted) return false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(data['buatCart']['data'])));
        return true;
      } else {
        if (!context.mounted) return false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(data['buatCart']['data'])));
        return false;
      }
    } catch (e) {
      print(e);
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Terjadi Kesalahan Server")));
      return false;
    }
  }

  Future<List<SurveiData>> searchHSurvei(
      {required String search, required List<String> kategori}) async {
    try {
      List<SurveiData> hasil = [];
      String request = """
query ExampleQuery(\$search: String!, \$kategori: [String]!) {
  searchHSurvei(search: \$search, kategori: \$kategori) {
    code,status,data {
    id_survei,hargaJual,tanggal_penerbitan,judul,kategori,idUser,deskripsi,durasi,jumlahPartisipan,batasPartisipan,isKlasik,status,gambarSurvei
  } 
  }
}
      """;

      Map<String, dynamic>? data =
          await Backend().serverConnection(query: request, mapVariable: {
        "search": search,
        "kategori": kategori,
      });
      print(data.toString() + "ayaya");
      if (data!['searchHSurvei']['code'] == 200) {
        List<Object?> dataHSurvei = data['searchHSurvei']['data'];
        hasil = List.generate(dataHSurvei.length,
            (index) => SurveiData.fromJson(json.encode(dataHSurvei[index])));
      }
      return hasil;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<String>> getAllKategori() async {
    try {
      List<Kategori> hasil = [];
      String request = """
query Query {
  getAllKategori {
  code,message,data {
    id,nama
  }  
  }
}
      """;
      Map<String, dynamic>? data =
          await Backend().serverConnection(query: request, mapVariable: {});
      if (data!['getAllKategori']['code'] == 200) {
        // List<String> result = data['getAllKategori']['data'];
        List<Object?> result = data['getAllKategori']['data'];
        hasil = List.generate(result.length,
            (index) => Kategori.fromJson(json.encode(result[index])));
      }
      return List.generate(hasil.length, (index) => hasil[index].nama);
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<SurveiData>> searchJudul(
      String searchQuery, String orderBy) async {
    try {
      String request = """ 
        query SearchByJudul(\$kata: String!, \$order: String!) {
          searchByJudul(kata: \$kata, order: \$order) {
            data {
              judul,harga,tanggal
            }
          }
        }
      """;

      final variables = {
        "kata": searchQuery,
        "order": orderBy,
      };

      final data = await Backend()
          .serverConnection(query: request, mapVariable: variables);

      if (data!['searchByJudul']['code'] == 200) {
        List<Object?> dataQuery = data["searchByJudul"]["data"];
        List<SurveiData> list = List.generate(dataQuery.length,
            (index) => SurveiData.fromJson(json.encode(dataQuery[index])));

        return list;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<Map<String, dynamic>?> searchByKategori(
      List<String> arrFilter, String orderBy) async {
    try {
      HttpLink link = HttpLink(linkGraphql);
      GraphQLClient qlClient = GraphQLClient(
        link: link,
        cache: GraphQLCache(store: HiveStore()),
      );

      String request = """
        query SearchByKategori(\$kategori: [String]!, \$order: String!) {
          searchByKategori(kategori: \$kategori, order: \$order) {
            code,data {
              judul,harga,tanggal
            }
          }
        }
        """;

      QueryResult query = await qlClient.query(QueryOptions(
        document: gql(request),
        variables: {
          "kategori": arrFilter,
          "order": orderBy,
        },
      ));
      print(query.data);

      return query.data;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<SurveiData>> searchByKategoriV2(
      List<String> arrFilter, String orderBy) async {
    try {
      String request = """
        query SearchByKategori(\$kategori: [String]!, \$order: String!) {
          searchByKategori(kategori: \$kategori, order: \$order) {
            code,data {
              judul,harga,tanggal
            }
          }
        }
        """;
      final variables = {
        "kategori": arrFilter,
        "order": orderBy,
      };

      final data = await Backend()
          .serverConnection(query: request, mapVariable: variables);

      if (data!['searchByKategori']['code'] == 200) {
        List<Object?> dataQuery = data["searchByKategori"]["data"];
        List<SurveiData> list = List.generate(dataQuery.length,
            (index) => SurveiData.fromJson(json.encode(dataQuery[index])));

        return list;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<Map<String, dynamic>?> getListKategori() async {
    try {
      HttpLink link = HttpLink(linkGraphql);
      GraphQLClient qlClient = GraphQLClient(
        link: link,
        cache: GraphQLCache(store: HiveStore()),
      );
      String request = """
                query GetAllKategori {
          getAllKategori {
            code,data {
              id,nama
            },message
          }
        }
        """;

      QueryResult query = await qlClient.query(QueryOptions(
        document: gql(request),
      ));
      print(query.data);

      return query.data;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<String>> getListKategoriV2() async {
    try {
      String request = """
                query GetAllKategori {
          getAllKategori {
            code,data {
              id,nama
            },message
          }
        }
        """;

      final data =
          await Backend().serverConnection(query: request, mapVariable: {});

      List<Object?> listObject = data!["getAllKategori"]['data'];

      if (data['getAllKategori']['code'] == 200) {
        return List.generate(listObject.length, (index) {
          Map<String, dynamic> temp = listObject[index] as Map<String, dynamic>;
          return temp['nama'] as String;
        });
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}


//   Future<List<SurveiData>> getHSurvei() async {
//     try {
//       List<SurveiData> hasil = [];
//       String request = """
// query GetHSurvei {
//   getHSurvei {
//   code,status,data {
//     harga,judul,tanggal_penerbitan
//   }
//   }
// }
//       """;

//       Map<String, dynamic>? data =
//           await Backend().serverConnection(query: request, mapVariable: {});
//       if (data!['getHSurvei']['code'] == 200) {
//         List<Object?> dataHSurvei = data['getHSurvei']['data'];
//         print("ambil datahsurvei");
//         hasil = List.generate(dataHSurvei.length,
//             (index) => SurveiData.fromJson(json.encode(dataHSurvei[index])));
//       }
//       return hasil;
//     } catch (e) {
//       print(e);
//       return [];
//     }
//   }
  //diatas yg terbaru

  // Future<Map<String, dynamic>?> searchJudul(
  //     String searchQuery, String orderBy) async {
  //   try {
  //     HttpLink link = HttpLink(linkGraphql);
  //     GraphQLClient qlClient = GraphQLClient(
  //       link: link,
  //       cache: GraphQLCache(store: HiveStore()),
  //     );

  //     String request = """
  //       query SearchByJudul(\$kata: String!, \$order: String!) {
  //         searchByJudul(kata: \$kata, order: \$order) {
  //           data {
  //             judul,harga,tanggal
  //           }
  //         }
  //       }
  //     """;

  //     QueryResult query = await qlClient.query(QueryOptions(
  //       document: gql(request),
  //       variables: {
  //         "kata": searchQuery,
  //         "order": orderBy,
  //       },
  //     ));

  //     return query.data;
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

// void searchDataV2(String statusSearch) async {
//     if (statusSearch == "normal") {
//       try {
//         setState(() {
//           statusSearch = "loading";
//         });
//         HttpLink link = HttpLink("http://localhost:3001/graphql");
//         GraphQLClient qlClient = GraphQLClient(
//           link: link,
//           cache: GraphQLCache(store: HiveStore()),
//         );

//         String request = """
//         query SearchByJudul(\$kata: String!, \$order: String!) {
//           searchByJudul(kata: \$kata, order: \$order) {
//             data {
//               judul,harga,tanggal
//             }
//           }
//         }
//         """;

//         QueryResult query = await qlClient.query(QueryOptions(
//           document: gql(request),
//           variables: {
//             "kata": controllerSearch.text,
//             "order": pilihanOrder,
//           },
//         ));
//         setState(() {
//           statusSearch = "normal";
//           //pesanPercobaan = query.data!["filterSurvei"]["message"] as String;
//           pesanPercobaan = "berhasil ambil data";

//           List<Object?> hasilQuery = query.data!["searchByJudul"]["data"];
//           //print(query.data!);
//           print(hasilQuery.length);

//           List<SurveiData> data = List.generate(hasilQuery.length,
//               (index) => SurveiData.fromJson(json.encode(hasilQuery[index])));

//           hasilSearch = List.generate(
//               data.length, (index) => KartuSurvei(surveiData: data[index]));

//           if (hasilSearch.isEmpty) {
//             jumlahHalaman = 0;
//             _ctrPagination = 0;
//             isiHasilDitampilkan(0);
//           } else {
//             jumlahHalaman = (hasilSearch.length ~/ jumlahItemPerhalaman) +
//                 ((hasilSearch.length % jumlahItemPerhalaman > 0) ? 1 : 0);
//             isiHasilDitampilkan(1);
//             _ctrPagination = 1;
//           }
//         });
//       } catch (e) {
//         print(e);
//       }
//     }
//   }

// void searchKategori() async {
//   _ctrPagination = 1;
//   if (statusSearch == "normal") {
//     try {
//       setState(() {
//         statusSearch = "loading";
//       });
//       HttpLink link = HttpLink("http://localhost:3001/graphql");
//       GraphQLClient qlClient = GraphQLClient(
//         link: link,
//         cache: GraphQLCache(store: HiveStore()),
//       );

//       String request = """
//         query SearchByKategori(\$kategori: [String]!, \$order: String!) {
//           searchByKategori(kategori: \$kategori, order: \$order) {
//             code,data {
//               judul,harga,tanggal
//             }
//           }
//         }
//         """;

//       QueryResult query = await qlClient.query(QueryOptions(
//         document: gql(request),
//         variables: {
//           "kategori": arrFilter,
//           "order": pilihanOrder,
//         },
//       ));
//       setState(() {
//         statusSearch = "normal";
//         //pesanPercobaan = query.data!["filterSurvei"]["message"] as String;
//         pesanPercobaan = "berhasil ambil data";

//         List<Object?> hasilQuery = query.data!["searchByKategori"]["data"];
//         //print(query.data!);
//         print(hasilQuery.length);

//         List<SurveiData> data = List.generate(hasilQuery.length,
//             (index) => SurveiData.fromJson(json.encode(hasilQuery[index])));

//         hasilSearch = List.generate(
//             data.length, (index) => KartuSurvei(surveiData: data[index]));
//         if (hasilSearch.isEmpty) {
//           jumlahHalaman = 0;
//           _ctrPagination = 0;
//           isiHasilDitampilkan(0);
//         } else {
//           jumlahHalaman = (hasilSearch.length ~/ jumlahItemPerhalaman) +
//               ((hasilSearch.length % jumlahItemPerhalaman > 0) ? 1 : 0);
//           isiHasilDitampilkan(1);
//           _ctrPagination = 1;
//         }
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
// }

// void searchData() async {
//   print(controllerSearch.text);
//   if (statusSearch == "normal") {
//     try {
//       setState(() {
//         statusSearch = "loading";
//       });
//       HttpLink link = HttpLink("http://localhost:3001/graphql");
//       GraphQLClient qlClient = GraphQLClient(
//         link: link,
//         cache: GraphQLCache(store: HiveStore()),
//       );

// //         String request = """
// // query FilterSurvei(\$nama: String!, \$orderBy: String!, \$kategori: [String]) {
// //   filterSurvei(nama: \$nama, orderBy: \$orderBy, kategori: \$kategori) {
// //     code,message,data {
// //             judul,batasPartisipan,deskripsi,durasi,harga,isKlasik,jumlahPartisipan,kategori,status,tanggal
// //     }
// //   }
// // }
// // """;
//       // QueryResult query = await qlClient.query(QueryOptions(
//       //   document: gql(request),
//       //   variables: {
//       //     "nama": controllerSearch.text,
//       //     "orderBy": pilihanFilter,
//       //     "kategori": [],
//       //   },
//       // ));
//       String request = """
// query SearchByJudul(\$kata: String!, \$order: String!) {
//   searchByJudul(kata: \$kata, order: \$order) {
//     data {
//       judul,harga,tanggal
//     }
//   }
// }
// """;
//       QueryResult query = await qlClient.query(QueryOptions(
//         document: gql(request),
//         variables: {
//           "kata": controllerSearch.text,
//           "order": pilihanOrder,
//         },
//       ));
//       setState(() {
//         statusSearch = "normal";
//         pesanPercobaan = query.data!["filterSurvei"]["message"] as String;
//         // List<Map<dynamic, dynamic>> hasil =
//         //     query.data!["filterSurvei"]["data"];
//         List<Object?> hasilQuery = query.data!["filterSurvei"]["data"];
//         print(query.data!["filterSurvei"]["data"]);

//         //final hasil = json.encode(query.data!["filterSurvei"]["data"]);

//         List<SurveiData> data = List.generate(hasilQuery.length,
//             (index) => SurveiData.fromJson(json.encode(hasilQuery[index])));

//         // hasilSearch = List.generate(
//         //     data.length, (index) => KartuSurvei(surveiData: data[index]));

//         hasilSearch = List.generate(
//             data.length, (index) => KartuSurvei(surveiData: data[index]));
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
// }

//   void searchDataV2() async {
//     if (statusSearch == "normal") {
//       try {
//         setState(() {
//           statusSearch = "loading";
//         });
//         HttpLink link = HttpLink("http://localhost:3001/graphql");
//         GraphQLClient qlClient = GraphQLClient(
//           link: link,
//           cache: GraphQLCache(store: HiveStore()),
//         );

//         String request = """
//         query SearchByJudul(\$kata: String!, \$order: String!) {
//           searchByJudul(kata: \$kata, order: \$order) {
//             data {
//               judul,harga,tanggal
//             }
//           }
//         }
//         """;

//         QueryResult query = await qlClient.query(QueryOptions(
//           document: gql(request),
//           variables: {
//             "kata": controllerSearch.text,
//             "order": pilihanOrder,
//           },
//         ));
//         setState(() {
//           statusSearch = "normal";
//           //pesanPercobaan = query.data!["filterSurvei"]["message"] as String;
//           pesanPercobaan = "berhasil ambil data";

//           List<Object?> hasilQuery = query.data!["searchByJudul"]["data"];
//           //print(query.data!);
//           print(hasilQuery.length);

//           List<SurveiData> data = List.generate(hasilQuery.length,
//               (index) => SurveiData.fromJson(json.encode(hasilQuery[index])));

//           hasilSearch = List.generate(
//               data.length, (index) => KartuSurvei(surveiData: data[index]));

//           if (hasilSearch.isEmpty) {
//             jumlahHalaman = 0;
//             _ctrPagination = 0;
//             isiHasilDitampilkan(0);
//           } else {
//             jumlahHalaman = (hasilSearch.length ~/ jumlahItemPerhalaman) +
//                 ((hasilSearch.length % jumlahItemPerhalaman > 0) ? 1 : 0);
//             isiHasilDitampilkan(1);
//             _ctrPagination = 1;
//           }
//         });
//       } catch (e) {
//         print(e);
//       }
//     }
//   }

//   void searchKategori() async {
//     _ctrPagination = 1;
//     if (statusSearch == "normal") {
//       try {
//         setState(() {
//           statusSearch = "loading";
//         });
//         HttpLink link = HttpLink("http://localhost:3001/graphql");
//         GraphQLClient qlClient = GraphQLClient(
//           link: link,
//           cache: GraphQLCache(store: HiveStore()),
//         );

//         String request = """
//         query SearchByKategori(\$kategori: [String]!, \$order: String!) {
//           searchByKategori(kategori: \$kategori, order: \$order) {
//             code,data {
//               judul,harga,tanggal
//             }
//           }
//         }
//         """;

//         QueryResult query = await qlClient.query(QueryOptions(
//           document: gql(request),
//           variables: {
//             "kategori": arrFilter,
//             "order": pilihanOrder,
//           },
//         ));
//         setState(() {
//           statusSearch = "normal";
//           //pesanPercobaan = query.data!["filterSurvei"]["message"] as String;
//           pesanPercobaan = "berhasil ambil data";

//           List<Object?> hasilQuery = query.data!["searchByKategori"]["data"];
//           //print(query.data!);
//           print(hasilQuery.length);

//           List<SurveiData> data = List.generate(hasilQuery.length,
//               (index) => SurveiData.fromJson(json.encode(hasilQuery[index])));

//           hasilSearch = List.generate(
//               data.length, (index) => KartuSurvei(surveiData: data[index]));
//           if (hasilSearch.isEmpty) {
//             jumlahHalaman = 0;
//             _ctrPagination = 0;
//             isiHasilDitampilkan(0);
//           } else {
//             jumlahHalaman = (hasilSearch.length ~/ jumlahItemPerhalaman) +
//                 ((hasilSearch.length % jumlahItemPerhalaman > 0) ? 1 : 0);
//             isiHasilDitampilkan(1);
//             _ctrPagination = 1;
//           }
//         });
//       } catch (e) {
//         print(e);
//       }
//     }
//   }

//   void searchData() async {
//     print(controllerSearch.text);
//     if (statusSearch == "normal") {
//       try {
//         setState(() {
//           statusSearch = "loading";
//         });
//         HttpLink link = HttpLink("http://localhost:3001/graphql");
//         GraphQLClient qlClient = GraphQLClient(
//           link: link,
//           cache: GraphQLCache(store: HiveStore()),
//         );

// //         String request = """
// // query FilterSurvei(\$nama: String!, \$orderBy: String!, \$kategori: [String]) {
// //   filterSurvei(nama: \$nama, orderBy: \$orderBy, kategori: \$kategori) {
// //     code,message,data {
// //             judul,batasPartisipan,deskripsi,durasi,harga,isKlasik,jumlahPartisipan,kategori,status,tanggal
// //     }
// //   }
// // }
// // """;
//         // QueryResult query = await qlClient.query(QueryOptions(
//         //   document: gql(request),
//         //   variables: {
//         //     "nama": controllerSearch.text,
//         //     "orderBy": pilihanFilter,
//         //     "kategori": [],
//         //   },
//         // ));
//         String request = """
// query SearchByJudul(\$kata: String!, \$order: String!) {
//   searchByJudul(kata: \$kata, order: \$order) {
//     data {
//       judul,harga,tanggal
//     }
//   }
// }
// """;
//         QueryResult query = await qlClient.query(QueryOptions(
//           document: gql(request),
//           variables: {
//             "kata": controllerSearch.text,
//             "order": pilihanOrder,
//           },
//         ));
//         setState(() {
//           statusSearch = "normal";
//           pesanPercobaan = query.data!["filterSurvei"]["message"] as String;
//           // List<Map<dynamic, dynamic>> hasil =
//           //     query.data!["filterSurvei"]["data"];
//           List<Object?> hasilQuery = query.data!["filterSurvei"]["data"];
//           print(query.data!["filterSurvei"]["data"]);

//           //final hasil = json.encode(query.data!["filterSurvei"]["data"]);

//           List<SurveiData> data = List.generate(hasilQuery.length,
//               (index) => SurveiData.fromJson(json.encode(hasilQuery[index])));

//           // hasilSearch = List.generate(
//           //     data.length, (index) => KartuSurvei(surveiData: data[index]));

//           hasilSearch = List.generate(
//               data.length, (index) => KartuSurvei(surveiData: data[index]));

//           //print(hasilSearch.length);
//           //print(hasil);
//           //final tes = SurveiData.fromJson(hasil);
//           //print(tes.toString());
//           //print(json.encode(query.data!["filterSurvei"]["data"]));
//           // List.generate(
//           //     hasil.length,
//           //     (index) => hasilSearch.add(
//           //         KartuSurvei(surveiData: SurveiData.fromMap(hasil[index]))));
//           //print(query.data!["filterSurvei"]["data"]);
//         });
//       } catch (e) {
//         print(e);
//       }
//     }
//   }

//   void searchData() async {
//     print(controllerSearch.text);
//     if (statusSearch == "normal") {
//       try {
//         setState(() {
//           statusSearch = "loading";
//         });
//         HttpLink link = HttpLink("http://localhost:3001/graphql");
//         GraphQLClient qlClient = GraphQLClient(
//           link: link,
//           cache: GraphQLCache(store: HiveStore()),
//         );

// //         String request = """
// // query FilterSurvei(\$nama: String!, \$orderBy: String!, \$kategori: [String]) {
// //   filterSurvei(nama: \$nama, orderBy: \$orderBy, kategori: \$kategori) {
// //     code,message,data {
// //             judul,batasPartisipan,deskripsi,durasi,harga,isKlasik,jumlahPartisipan,kategori,status,tanggal
// //     }
// //   }
// // }
// // """;
//         // QueryResult query = await qlClient.query(QueryOptions(
//         //   document: gql(request),
//         //   variables: {
//         //     "nama": controllerSearch.text,
//         //     "orderBy": pilihanFilter,
//         //     "kategori": [],
//         //   },
//         // ));
//         String request = """
// query SearchByJudul(\$kata: String!, \$order: String!) {
//   searchByJudul(kata: \$kata, order: \$order) {
//     data {
//       judul,harga,tanggal
//     }
//   }
// }
// """;
//         QueryResult query = await qlClient.query(QueryOptions(
//           document: gql(request),
//           variables: {
//             "kata": controllerSearch.text,
//             "order": pilihanOrder,
//           },
//         ));
//         setState(() {
//           statusSearch = "normal";
//           pesanPercobaan = query.data!["filterSurvei"]["message"] as String;
//           // List<Map<dynamic, dynamic>> hasil =
//           //     query.data!["filterSurvei"]["data"];
//           List<Object?> hasilQuery = query.data!["filterSurvei"]["data"];
//           print(query.data!["filterSurvei"]["data"]);

//           //final hasil = json.encode(query.data!["filterSurvei"]["data"]);

//           List<SurveiData> data = List.generate(hasilQuery.length,
//               (index) => SurveiData.fromJson(json.encode(hasilQuery[index])));

//           // hasilSearch = List.generate(
//           //     data.length, (index) => KartuSurvei(surveiData: data[index]));

//           hasilSearch = List.generate(
//               data.length, (index) => KartuSurvei(surveiData: data[index]));

//           //print(hasilSearch.length);
//           //print(hasil);
//           //final tes = SurveiData.fromJson(hasil);
//           //print(tes.toString());
//           //print(json.encode(query.data!["filterSurvei"]["data"]));
//           // List.generate(
//           //     hasil.length,
//           //     (index) => hasilSearch.add(
//           //         KartuSurvei(surveiData: SurveiData.fromMap(hasil[index]))));
//           //print(query.data!["filterSurvei"]["data"]);
//         });
//       } catch (e) {
//         print(e);
//       }
//     }
//   }
