class User {
  int id;
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
  int ownerId;
  String name;
  String creatorId;

  Item(this.id, this.ownerId, this.name, this.creatorId);

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(json['Id'], json['Owner'], json['Name'], json['Creator']);
  }
}

class Folder {
  String id;
  String name;
  int ownerId;
  int creatorId;
  dynamic parentFolder;
  List<dynamic> subFolders;
  List<dynamic> files;
  String dateCreated;
  String dateModified;

  Folder(this.id, this.name, this.ownerId, this.creatorId, this.parentFolder,
      this.subFolders, this.files, this.dateCreated, this.dateModified);

  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
        json['Id'],
        json['Name'],
        json['Owner'],
        json['Creator'],
        json['ParentFolder'],
        json['SubFolders'],
        json['Files'],
        json['DateCreated'],
        json['DateModified']);
  }
}

class File {
  String id;
  String name;
  int ownerId;
  int creatorId;
  String dateUpload;
  String hash;
  Uri fileData;
  String fileType;
  int fileSize;
  bool isImage;
  String fileTags;
  dynamic parentFolder;

  File(
      this.id,
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
  int ownerId;
  List<dynamic> items;
  String root;
  String createdTime;
  String outdatedTime;
  List<dynamic> members;
  String code;
  int sharetype;
  String description;

  ShareItem(
      this.id,
      this.ownerId,
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
}