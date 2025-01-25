
import 'package:rice_milling_mobile/domain/network/group_middleware.dart';
//import 'package:rice_milling_mobile/domain/network/maintenance.dart';
import 'package:rice_milling_mobile/domain/network/middleware.dart';
import 'package:http/http.dart' as http;

class BioApiResponse{
 static http.Response check(http.Response response,{Middleware? middleware,GroupMiddleware? groupMiddleWare}){
   _commonCheck(response);
   if(middleware!=null){
     middleware.next(response);
   }
   if(groupMiddleWare!=null){
     groupMiddleWare.next(response);
   }
    return response;
  }

 static _commonCheck(http.Response response){
   //MaintenanceMiddleware().next(response);
 }
}