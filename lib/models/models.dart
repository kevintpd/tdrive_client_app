class User {
  String id;
  String username;
  String email;
  String rootdrive;

  User(this.id, this.username, this.email, this.rootdrive);

  factory User.fromjson(Map<String, dynamic> json) {
    return User(
        json['id'], json['username'], json['email'], json['root_drive']);
  }
}

class Item {
  String id;
  String ownerId;
  String name;
  String creatorId;
  bool IsShared;

  Item(this.id, this.ownerId, this.name, this.creatorId, this.IsShared);

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(json['Id'], json['Owner'], json['Name'], json['Creator'],
        json['IsShared']);
  }
}

class Folder {
  String id;
  String name;
  String ownerId;
  String creatorId;
  bool IsShared;
  dynamic parentFolder;
  List<dynamic> subFolders;
  List<dynamic> files;
  String dateCreated;
  String dateModified;

  Folder(this.id, this.name, this.ownerId, this.creatorId, this.IsShared,
      this.parentFolder,
      this.subFolders, this.files, this.dateCreated, this.dateModified);

  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
        json['Id'],
        json['Name'],
        json['Owner'],
        json['Creator'],
        json['IsShared'],
        json['ParentFolder'],
        json['SubFolders'],
        json['Files'],
        json['DateCreated'],
        json['DateModified']);
  }

  factory Folder.clone(Folder source) {
    return Folder(
      source.id,
      source.name,
      source.ownerId,
      source.creatorId,
      source.IsShared,
      source.parentFolder,
      source.subFolders,
      source.files,
      source.dateCreated,
      source.dateModified,);
  }
}

class File {
  String id;
  String name;
  String ownerId;
  String creatorId;
  String dateUpload;
  String hash;
  String fileData;
  String fileType;
  String fileSize;
  bool isImage;
  String fileTags;
  dynamic parentFolder;

  File(this.id,
      this.name,
      this.ownerId,
      this.creatorId,
      this.dateUpload,
      this.hash,
      this.fileData,
      this.fileType,
      this.fileSize,
      this.isImage,
      this.fileTags,
      this.parentFolder);

  factory File.fromJson(Map<String, dynamic> json) {
    return File(
        json['Id'],
        json['Name'],
        json['Owner'],
        json['Creator'],
        json['DateUpload'],
        json['Hash'],
        json['FileData'],
        json['FileType'],
        json['FileSize'],
        json['IsImage'],
        json['FileTags'],
        json['ParentFolder']);
  }

  factory File.clone(File source) {
    return File(
        source.id,
        source.name,
        source.ownerId,
        source.creatorId,
        source.dateUpload,
        source.hash,
        source.fileData,
        source.fileType,
        source.fileSize,
        source.isImage,
        source.fileTags,
        source.parentFolder);
  }
}

class ShareItem {
  String id;
  String name;
  User owner;
  List<dynamic> items;
  Folder root;
  String createdTime;
  dynamic outdatedTime;
  List<User> members;
  String code;
  int sharetype;
  String description;

  ShareItem(this.id,
      this.name,
      this.owner,
      this.items,
      this.root,
      this.createdTime,
      this.outdatedTime,
      this.members,
      this.code,
      this.sharetype,
      this.description);

  factory ShareItem.fromjson(Map<String, dynamic> json) {
    return ShareItem(
        json['Id'],
        json['Name'],
        User.fromjson(json['Owner']),
        json['Items'],
        Folder.fromJson(json['Root']),
        json['CreatedTime'],
        json['OutdatedTime'],
        List<User>.from(json['Members'].map((item) => User.fromjson(item))),
        json['Code'],
        json['ShareType'],
        json['Description']);
  }

  factory ShareItem.clone(ShareItem source){
    return ShareItem(
        source.id,
        source.name,
        source.owner,
        source.items,
        source.root,
        source.createdTime,
        source.outdatedTime,
        source.members,
        source.code,
        source.sharetype,
        source.description);
  }
}


class ShareItemSample {
  String id;
  String name;
  String owner;
  List<dynamic> items;
  String root;
  String createdTime;
  dynamic outdatedTime;
  List<dynamic> members;
  String code;
  int sharetype;
  String description;

  ShareItemSample(this.id,
      this.name,
      this.owner,
      this.items,
      this.root,
      this.createdTime,
      this.outdatedTime,
      this.members,
      this.code,
      this.sharetype,
      this.description);

  factory ShareItemSample.fromjson(Map<String, dynamic> json) {
    return ShareItemSample(
        json['Id'],
        json['Name'],
        json['Owner'],
        json['Items'],
        json['Root'],
        json['CreatedTime'],
        json['OutdatedTime'],
        json['Members'],
        json['Code'],
        json['ShareType'],
        json['Description']);
  }

  factory ShareItemSample.clone(ShareItemSample source){
    return ShareItemSample(
        source.id,
        source.name,
        source.owner,
        source.items,
        source.root,
        source.createdTime,
        source.outdatedTime,
        source.members,
        source.code,
        source.sharetype,
        source.description);
  }
}