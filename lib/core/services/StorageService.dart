import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {

  Future<String> uploadFile(File file,String diretory) async{

    try{
      final uploadTask = await FirebaseStorage.instance.ref().child(diretory).putFile(file);

      String url = await uploadTask.ref.getDownloadURL();
      return url;
    } on FirebaseException catch(e){
      throw e;
    }
  }
}