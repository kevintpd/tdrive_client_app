import 'dart:convert';
import 'global.dart';

const serverAddress = "http://172.20.10.3:8000/";
const apiUserinfo = "user/info/";
const apiRegister = "register/";
const apiSendcode = "sendcode/";
const apiFolders = "folders/";
const apiFiles = "files/";
const apiItems = "items/";
const apiFileDownload = "filedownload/";
const apiFolderDownload = "folderdownload/";
const apiShareitem = "shareitem/";
const apiJoinedshare = "joinedshare/";
const apiJoinshare = "joinshare/";
const apiQuitShare = "quitShare/";
const apiCreateShareFolder = "createsharefolder/";
const apiUploadShareFile = "uploadfiletoshare/";
const apiShareFolder = "sharefolder/";
const apiShareFile = "sharefile/";
const apiAllShare = "AllShare/";
const apiRoot = "root/";
const apiLogin = "user/info/";
const apiRefresh = "Refresh/";
const fileSearch = "fileSearch/";
const joinshareSearch = "searchsharefile/";


Map<String, String> get headers => {
  'content-type': 'application/json',
  'accept': 'application/json',
  'authorization': prefs.getString("token")??""
};