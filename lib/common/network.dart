import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'server_spec.dart' as server;
import 'package:tdrive_client_app/models/models.dart';
import 'file_system.dart';

var dio =
    Dio(BaseOptions(baseUrl: server.serverAddress, headers: server.headers));

Future<List<Item>> fetchUserItems() async {
  List<Item> items = [];
  final response = await dio.get(server.apiItems);
  if (response.statusCode == 200) {
    response.data.forEach((item) => items.add(Item.fromJson(item)));
  }
  return items;
}

Future<int?> login() async {
  dio.options.headers = await server.headers;
  final response = await dio.get(server.apiLogin);
  print(response.data);
  return response.statusCode;
}

Future<dynamic> sendcode(String email) async {
  final response =
      await dio.get(server.apiSendcode, queryParameters: {'email': email});
  print(response.data);
  return response.statusCode;
}

Future<dynamic> register(
    String username, String password, String email, String code) async {
  FormData formData = FormData.fromMap({
    'username': username,
    'password': password,
    'email': email,
    'code': code
  });
  final response = await dio.post(server.apiRegister, data: formData);
  return response.statusCode;
}

Future<User?> fetchInfo() async {
  User user;
  try {
    final response = await dio.get(server.apiUserinfo);
    user = User.fromjson(response.data[0]);
    return user;
  } catch (e) {
    print(e.toString());
  }
  return null;
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

Future<List<ShareItem>> fetchMyShareRoot() async {
  List<ShareItem> root = [];
  final response =
      await dio.get(server.apiShareitem, queryParameters: {'expand': '~all'});
  try {
    if (response.statusCode == 200) {
      response.data.forEach((item) => root.add(ShareItem.fromjson(item)));
    }
  } catch (e) {
    print(e);
  }
  return root;
}

Future<List<ShareItem>> fetchJoinedShareRoot() async {
  List<ShareItem> root = [];
  final response =
      await dio.get(server.apiJoinedshare, queryParameters: {'expand': '~all'});
  try {
    if (response.statusCode == 200) {
      response.data.forEach((item) => root.add(ShareItem.fromjson(item)));
    }
  } catch (e) {
    print(e);
  }
  return root;
}

Future<List<ShareItem>> fetchAllShareItem() async {
  List<ShareItem> allitem = [];
  final response =
      await dio.get(server.apiAllShare, queryParameters: {'expand': '~all'});
  try {
    if (response.statusCode == 200) {
      response.data.forEach((item) => allitem.add(ShareItem.fromjson(item)));
    }
  } catch (e) {
    print(e);
  }
  return allitem;
}

Future<List<ShareItem>> fetchOneShareItem(String itemId) async {
  List<ShareItem> oneitem = [];
  final response = await dio
      .get(server.apiShareitem + itemId, queryParameters: {'expand': '~all'});
  try {
    if (response.statusCode == 200) {
      oneitem.add(ShareItem.fromjson(response.data));
    }
  } catch (e) {
    print(e);
  }
  return oneitem;
}

Future<Folder?> fetchFolder(String folderId) async {
  final response = await dio
      .get(server.apiFolders + folderId, queryParameters: {'expand': '~all'});
  if (response.statusCode == 200) {
    return Folder.fromJson(response.data);
  }
  return null;
}

Future<Folder?> fetchShareFolder(String folderId) async {
  final response = await dio.get(server.apiShareFolder + folderId,
      queryParameters: {'expand': '~all'});
  if (response.statusCode == 200) {
    return Folder.fromJson(response.data);
  }
  return null;
}

Future<Folder> fetchMoveFolder(String folderId) async {
  final response = await dio
      .get(server.apiFolders + folderId, queryParameters: {'expand': '~all'});
  if (response.statusCode == 200) {
    // print(response.data);
    return Folder.fromJson(response.data);
  } else {
    return Folder.fromJson(response.data);
  }
}

Future<dynamic> deleteFolder(String folderId) async {
  try {
    final response = await dio.delete(server.apiFolders + folderId);
    return response.statusCode;
  } catch (e) {
    return null;
  }
}

Future<dynamic> deleteFile(String fileId) async {
  try {
    final response = await dio.delete(server.apiFiles + fileId);
    return response.statusCode;
  } catch (e) {
    return null;
  }
}

Future<dynamic> deleteShareItem(String ShareItemId) async {
  try {
    final response = await dio.delete(server.apiShareitem + ShareItemId);
    return response.statusCode;
  } catch (e) {
    return null;
  }
}

//暂时没用处了
Future<dynamic> renameFolder(String folderid, String name) async {
  try {
    final response =
        await dio.put(server.apiFolders + folderid, data: {"Name": name});
    if (response.statusCode == 200) {
      return response.statusCode;
    }
  } catch (e) {
    print(e.toString());
  }
  return null;
}

Future<dynamic> updateFolder(Folder oldFolder, Folder newFolder) async {
  try {
    FormData formData = FormData.fromMap(
        {"Name": newFolder.name, 'ParentFolder': newFolder.parentFolder});
    final response =
        await dio.put(server.apiFolders + oldFolder.id, data: formData);
    if (response.statusCode == 200) {
      return response.statusCode;
    }
  } catch (e) {
    print(e.toString());
  }
  return null;
}

Future<dynamic> updateShareitem(
    ShareItem oldShareItem, ShareItemSample newShareItem) async {
  try {
    FormData formData = FormData.fromMap({
      "Root": oldShareItem.root.id,
      "OutdatedTime": newShareItem.outdatedTime,
      "Members": newShareItem.members,
      "Code": newShareItem.code,
      "ShareType": newShareItem.sharetype,
      "Description": newShareItem.description,
    });
    final response =
        await dio.put(server.apiShareitem + oldShareItem.id, data: formData);
    print(newShareItem.outdatedTime);
    if (response.statusCode == 200) {
      return response.statusCode;
    }
  } catch (e) {
    print(e.toString());
  }
  return null;
}

Future<dynamic> updateFile(File oldFile, File newFile) async {
  try {
    FormData formData = FormData.fromMap({
      "Name": newFile.name,
      'FileType': oldFile.fileType,
      'ParentFolder': newFile.parentFolder
    });
    final response =
        await dio.put(server.apiFiles + oldFile.id, data: formData);
    if (response.statusCode == 200) {
      return response.statusCode;
    }
  } catch (e) {
    print(e.toString());
  }
  return null;
}

Future<List<File>> SearchMyFile(String SearchWord) async {
  List<File> files = [];
  final response = await dio.get(server.fileSearch, queryParameters: {'searchWord':SearchWord});
  try {
    if (response.statusCode == 200){
      response.data.forEach((file) => files.add(File.fromJson(file)));
    }
  }
  catch(e){
    print(e);
  }
  return files;
}


Future<List<File>> SearchInJoinShare(String SearchWord) async {
  List<File> files = [];
  final response = await dio.get(server.joinshareSearch, queryParameters: {'searchWord':SearchWord});
  try {
    if (response.statusCode == 200){
      response.data.forEach((file) => files.add(File.fromJson(file)));
    }
  }
  catch(e){
    print(e);
  }
  return files;
}

Future<dynamic> newFolder(String ParentfolderId, String name) async {
  try {
    FormData formData =
        FormData.fromMap({'Name': name, 'ParentFolder': ParentfolderId});
    final response = await dio.post(server.apiFolders, data: formData);
    return response.statusCode;
  } catch (e) {
    return null;
  }
}

Future<dynamic> newShareFolder(
    String shareitemId, String ParentfolderId, String name) async {
  try {
    FormData formData =
        FormData.fromMap({'Name': name, 'ParentFolder': ParentfolderId});
    final response = await dio.post(server.apiCreateShareFolder + shareitemId,
        data: formData);
    return response.statusCode;
  } catch (e) {
    return null;
  }
}

Future<dynamic> newShareItem(String root, dynamic outdatedTime, dynamic code,
    int shareType, dynamic description) async {
  try {
    FormData formData = FormData.fromMap({
      'Root': root,
      'OutdatedTime': outdatedTime,
      'Members': null,
      'Code': code,
      'ShareType': shareType,
      'Description': description
    });
    final response = await dio.post(server.apiShareitem, data: formData);
    return response.statusCode;
  } catch (e) {
    return null;
  }
}

Future<dynamic> joinShare(String shareItemId) async {
  try {
    final response = await dio.patch(server.apiJoinshare + shareItemId);
    return response.statusCode;
  } catch (e) {
    return null;
  }
}

Future<dynamic> quitShare(String shareItemId) async {
  try {
    final response = await dio.patch(server.apiQuitShare + shareItemId);
    return response.statusCode;
  } catch (e) {
    return null;
  }
}

Future<void> RefreshShare() async {
  try {
    await dio.get(server.apiRefresh);
  } catch (e) {
    print(e.toString());
  }
}

Future<dynamic> uploadFile(
    String ParentFolder, String? filePath, String name) async {
  try {
    FormData formData = FormData.fromMap({
      'FileData': await MultipartFile.fromFile(filePath ?? "", filename: name),
      'ParentFolder': ParentFolder
    });
    final response = await dio.post(server.apiFiles, data: formData);
    return response.statusCode; //201
  } catch (e) {
    return null;
  }
}

Future<dynamic> uploadFileToShare(String shareitemId, String ParentFolder,
    String? filePath, String name) async {
  try {
    FormData formData = FormData.fromMap({
      'FileData': await MultipartFile.fromFile(filePath ?? "", filename: name),
      'ParentFolder': ParentFolder
    });
    final response =
        await dio.post(server.apiUploadShareFile + shareitemId, data: formData);
    return response.statusCode; //201
  } catch (e) {
    return null;
  }
}

Future<void> downloadFile(BuildContext context, File file) async {
  bool hasStoragePermission = await checkStoragePermission();
  if (hasStoragePermission) {
    Directory saveDir = await prepareSaveDir();
    print('Starting Downloading');
    try {
      await dio.download(
          server.apiFileDownload + file.id, '${saveDir.path}${file.name}');
      print('Download Finished ->${saveDir.path}${file.name}');
    } catch (e) {
      print(e);
    }
  }
}
