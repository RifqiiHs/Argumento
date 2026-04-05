import 'dart:convert';

void main(){
  String jsonString = '{"nama":"wilson", "angka_favorit":18, "hobi": "main_musik"}';
  Map<String, dynamic> jsonMap = jsonDecode(jsonString);

  print("nama = ${jsonMap['nama']}");
  print("angka_favorit = ${jsonMap['angka_favorit']}");
  print("hobi = ${jsonMap['hobi']}"); 
}