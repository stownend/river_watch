// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';

import '../../ioc.dart';
import '../../common_services/app_settings_service.dart';

class AppBarAndNavBarScaffold extends StatelessWidget {

  const AppBarAndNavBarScaffold({super.key, required this.body, this.navName});
  final Widget body;
  final String? navName;

  @override
  Widget build(BuildContext context) {
    final _appSettingsService = getIt.get<AppSettingsService>();

    //final colorService = Provider.of<ColorService>(context, listen: false);

    var navBarItems = _appSettingsService.getNavigationBarItems();

    return Scaffold(

      appBar: AppBar(
        title: Text("${_appSettingsService.appName} ${navName != null ? ": $navName" : ""}"),
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
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
          iconSize: 24,

          //backgroundColor: MaterialColor(0xFF2196F3, colorService.colorSwatchShades),
          type: BottomNavigationBarType.fixed, // Prevents background going to white when "shifting" e.g. more than 3 icons

          unselectedItemColor: Colors.grey[500],
          //selectedItemColor: Colors.amberAccent,
          currentIndex: _appSettingsService.getRouteIndexByUiName(navName?? "Home"),

          items: navBarItems,
          onTap: (index)
          {
              Navigator.pushNamed(context, _appSettingsService.getRouteByIndex(index).routeName, arguments: "");
          },
        ),
      body: body
    );
  }
}

