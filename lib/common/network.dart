import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'server_spec.dart' as server;
import 'package:tdrive_client_app/models/models.dart';
import 'file_system.dart';



var dio = Dio(BaseOptions(baseUrl: server.serverAddress, headers: server.headers));

Future<List<Item>> fetchUserItems() async {
  List<Item> items = [];
  final response = await dio.get(server.apiItems);
  if (response.statusCode == 200) {
    response.data.forEach((item) => items.add(Item.fromJson(item)));
  }
  return items;
}

Future<int?> login() async{
  dio.options.headers = server.headers;
  final response = await dio.get(server.apiLogin);
  print(response.data);
  return response.statusCode;
}

Future<dynamic> sendcode(String email) async{
  final response = await dio.get(server.apiSendcode,queryParameters: {'email':email});
  print(response.data);
  return response.statusCode;
}

Future<dynamic> register(String username, String password, String email, String code) async{
  final response = await dio.post(server.apiRegister,data: {'username':username, 'password':password, 'email':email, 'code':code});
  return response.statusCode;
}

Future<List<Folder>> fetchRoot() async {
  List<Folder> root = [];
  final response = await dio.get(server.apiRoot);
  try {
    if (response.statusCode == 200) {
      response.data.forEach((item) => root.add(Folder.fromJson(item)));
    }
  } catch (e) {
    print(e);
  }
  return root;
}

Future<Folder?> fetchFolder(String folderId) async {
  final response = await dio.get(server.apiFolders + folderId, queryParameters: {'expand': '~all'});
  if (response.statusCode == 200) {
    return Folder.fromJson(response.data);
  }
  return null;
}

Future<dynamic> deleteFolder(String folderId) async{
  try{
  final response = await dio.delete(server.apiFolders+folderId);
  return response.statusCode;
  }
  catch (e) {
    return null;
  }
}

Future<dynamic> renameFolder(String folderid, String name) async{
  try{
    final response = await dio.put(server.apiFolders + folderid, data: {"Name":name});
    if(response.statusCode == 200){
      return response.statusCode;
    }

  }
      catch(e){
    print(e.toString());
      }
      return null;
}

Future<dynamic> newFolder(String ParentfolderId, String name) async{
  try{
  final response = await dio.post(server.apiFolders,data: {'Name':name, 'ParentFolder':ParentfolderId});
  return response.statusCode;
  }
      catch(e){
    return null;
      }
}

Future<void> downloadFile(BuildContext context, File file) async {
  bool hasStoragePermission = await checkStoragePermission();
  if (hasStoragePermission) {
    Directory saveDir = await prepareSaveDir();
    print('Starting Downloading');
    try {
      await dio.download(server.apiFileDownload + file.id, '${saveDir.path}${file.name}');
      print('Download Finished ->${saveDir.path}${file.name}');
    } catch (e) {
      print(e);
    }
  }
}