import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mandaditos_express/layouts/line.dart';
import 'package:mandaditos_express/monitoreo/monitoreo_controller.dart';

class pedido_monitoreo_user extends StatefulWidget {
  const pedido_monitoreo_user ({key, required this.title});
  final String title;

  @override
  State<pedido_monitoreo_user> createState() => _pedido_monitoreo_userstate();

}

class _pedido_monitoreo_userstate extends State<pedido_monitoreo_user> {
  
  final _controller= monitoreo_controller();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
       setState(() { });
     });
  }
 

  @override
  Widget build(BuildContext context) {
    
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
   return Scaffold(
    appBar: PreferredSize(preferredSize: const Size.fromHeight(80),
    child: Container(margin: const EdgeInsets.only(top:40),child: Row(
                children: <Widget>[Center(child: Container(height: 50,width: 20,margin: const EdgeInsets.only(left: 10),child: Icon(Icons.arrow_back_ios),),)
                ,Container(height: 70, width: 70,margin: const EdgeInsets.only(left: 10) ,child: Image.asset("assets/images/Logo.png"),)
                ,]),)),
   
    body:  Column( mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
       
           SizedBox(width: width,
           height: height*.6,
           child:  GoogleMap(
            onMapCreated: _controller.onMapCreated,
            initialCameraPosition: _controller.initialCameraPosition , 
            zoomGesturesEnabled: false,
            zoomControlsEnabled: false,
            markers: _controller.markers,
            onTap:_controller.onTap ,
           ))
    ],
  )
   );
  }

}
