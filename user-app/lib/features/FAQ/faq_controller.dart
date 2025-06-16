// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:survei_aplikasi/utils/graphql_db.dart';

class FAQController {
  Future<List<FAQ>> getAllFAQ() async {
    try {
      String query = """ 
        query GetFAQ {
          getFAQ {
          code,data {
            id,jawaban,pertanyaan
          },status
          }
        }
    """;

      Map<String, dynamic>? data = await BackendConnection()
          .serverConnection(query: query, mapVariable: {});
      print(data);
      if (data!['getFAQ']['code'] == 200) {
        List<Object?> dataFAQ = data["getFAQ"]["data"];
        List<FAQ> temp = List.generate(dataFAQ.length,
            (index) => FAQ.fromJson(json.encode(dataFAQ[index])));
        //print("ini temp -> $temp");
        return temp;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  List<DataFAQ> processData(List<FAQ> data) {
    List<DataFAQ> listData = [];
    for (var i = 0; i < data.length; i++) {
      listData.add(DataFAQ(
          angka: i + 1,
          gKey: GlobalKey(debugLabel: 'FAQSoal-$i'),
          faq: data[i]));
    }
    return listData;
  }
}

class FAQ {
  String pertanyaan;
  String jawaban;
  FAQ({
    required this.pertanyaan,
    required this.jawaban,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pertanyaan': pertanyaan,
      'jawaban': jawaban,
    };
  }

  factory FAQ.fromMap(Map<String, dynamic> map) {
    return FAQ(
      pertanyaan: map['pertanyaan'] as String,
      jawaban: map['jawaban'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FAQ.fromJson(String source) =>
      FAQ.fromMap(json.decode(source) as Map<String, dynamic>);
}

class DataFAQ {
  int angka;
  GlobalKey gKey;
  FAQ faq;
  DataFAQ({
    required this.angka,
    required this.gKey,
    required this.faq,
  });
}
