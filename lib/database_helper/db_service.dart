// services/db_service.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:water_watch/database_helper/entity/local_location_entity.dart';
import 'package:water_watch/database_helper/entity/local_parameter_entity.dart';
import '../database_helper/database.dart';
import 'entity/record_entity.dart';


class DBService extends GetxService {
  late AppDatabase _database;

  Future<DBService> init() async {
    _database = await $FloorAppDatabase
        .databaseBuilder('offlinewwe.db')
        .build();
    return this;
  }

  Future<void> saveLocations(List<LocationEntity> locations) async {
    await _database.locationDao.insertLocations(locations);
  }

  Future<List<LocationEntity>> loadLocations() async {
    return await _database.locationDao.findAllLocations();
  }

  Future<void> saveParameters(List<ParameterEntity> params) async {
    await _database.parameterDao.insertParameters(params);
  }

  Future<List<ParameterEntity>> loadParameters() async {
    return await _database.parameterDao.findAllParameters();
  }

  Future<void> saveRecord(RecordEntity record) async {
    await _database.recordDao.insertRecord(record);
  }

  Future<List<RecordEntity>> loadRecords() async {
    return await _database.recordDao.getAllRecords();
  }

  Future<void> deleteRecord(RecordEntity record) async {
    await _database.recordDao.deleteRecord(record);
  }

  Future<List<RecordEntity>> loadRecordsByDateAndParam(String year, String paramId) async {
    print('check loadRecordsByDateAndParam: $year, $paramId');
    return await _database.recordDao.getRecordsByYearAndParam(year, paramId);
  }

  Future<List<RecordEntity>> loadRecordsByStationAndParameter(String stationId, String parameterId) async {
    return await _database.recordDao.getRecordsByStationAndParam(stationId, parameterId);
  }
}