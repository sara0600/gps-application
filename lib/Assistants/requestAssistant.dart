import 'dart:convert';
import 'package:http/http.dart'as http;
class RequestAssistant {
  static  getRequest(String url) async{
    http.Response response= await http.get(Uri.parse(url));
    //try{
     //f(response.statusCode==200){

       //var decodeData=  jsonDecode(response.body);
        return response;
      //}
   //   else{
     //   return"failed";
      //}
    }
    //catch(exp){
   //   return"failed";
  //  }

 // }
}