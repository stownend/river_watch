import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/app_settings_service.dart';

class MyScaffold extends StatelessWidget {

  const MyScaffold({super.key, required this.body, this.navName});
  final Widget body;
  final String? navName;


  @override
  Widget build(BuildContext context) {
    final appSettingsService = Provider.of<AppSettingsService>(context, listen: false);
    //final colorService = Provider.of<ColorService>(context, listen: false);

    return Scaffold(

      appBar: AppBar(
        title: Text("${appSettingsService.appName} ${navName != null ? ": $navName" : ""}"),
        actions: <Widget>[
          PopupMenuButton(
          // add icon, by default "3 dot" icon
          // icon: Icon(Icons.book)
          itemBuilder: (context){
            return [
                  const PopupMenuItem<int>(
                      value: 0,
                      child: Text("Home"),
                  ),

                  const PopupMenuItem<int>(
                      value: 1,
                      child: Text("Test Rest API"),
                  ),

                  const PopupMenuItem<int>(
                      value: 2,
                      child: Text("About"),
                  ),
              ];
          },
          onSelected:(value){
            if(value == 0){
                Navigator.pushNamed(context, "/home");
            }else if(value == 1){
                Navigator.pushNamed(context, "/testRestAPI");
            }else if(value == 2){
                Navigator.pushNamed(context, "/about");
            }
          }
        ),
/*
         IconButton(
            icon: const Icon(
            Icons.person_2,
              size: 32,
            ),
            onPressed: () {
              //_onAbout(context);
            },
          ),
*/          
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
          iconSize: 24,

          //backgroundColor: MaterialColor(0xFF2196F3, colorService.colorSwatchShades),
          type: BottomNavigationBarType.fixed, // Prevents background going to white when "shifting" e.g. more than 3 icons

          unselectedItemColor: Colors.grey[500],
          //selectedItemColor: Colors.amberAccent,
          currentIndex: appSettingsService.getRouteIndexByUiName(navName?? "Home"),

          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: appSettingsService.getRouteByIndex(0).icon,
              label: appSettingsService.getRouteByIndex(0).uiName,
            ),
            BottomNavigationBarItem(
              icon: appSettingsService.getRouteByIndex(1).icon,
              label: appSettingsService.getRouteByIndex(1).uiName,
            ),
            BottomNavigationBarItem(
              icon: appSettingsService.getRouteByIndex(2).icon,
              label: appSettingsService.getRouteByIndex(2).uiName,
            ),
            BottomNavigationBarItem(
              icon: appSettingsService.getRouteByIndex(3).icon,
              label: appSettingsService.getRouteByIndex(3).uiName,
            ),
          ],

          onTap: (index)
          {
              Navigator.pushNamed(context, appSettingsService.getRouteByIndex(index).routeName, arguments: "Arg sent from MyScaffold");
          },
        ),
      body: body
    );
  }
}

