import 'package:flutter/cupertino.dart';

class BaseProvider extends ChangeNotifier{
  final BuildContext context;
  BaseProvider(this.context){
    // print("test Initial Provider");
  }
  String apiUrl ="www.google.com";
}