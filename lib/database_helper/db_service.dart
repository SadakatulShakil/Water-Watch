// // services/db_service.dart
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:uuid/uuid.dart';
// import '../database_helper/database.dart';
//
//
// class DBService extends GetxService {
//   late AppDatabase _database;
//
//   Future<DBService> init() async {
//     _database = await $FloorAppDatabase
//         .databaseBuilder('landslide_offline.db')
//         .build();
//     return this;
//   }
//   final userPrefService = UserPrefService();
//
//
// }