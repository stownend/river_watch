// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';

//import '../../common_services/logging_service.dart';
import '../../ioc.dart';
import '../../common_services/app_settings_service.dart';

class TabbedAppBarAndNavBarScaffold extends StatelessWidget {

  const TabbedAppBarAndNavBarScaffold({super.key, required this.body, this.navName, this.navNameOverride = ""});
  final Widget body;
  final String? navName;
  final String navNameOverride;

  @override
  Widget build(BuildContext context) {
    final _appSettingsService = getIt.get<AppSettingsService>();

    var navBarItems = _appSettingsService.getNavigationBarItems();

    return DefaultTabController(
      length:3,
      child: Scaffold(

        appBar: AppBar(
          title: Text("${_appSettingsService.appName} ${navName != null ? ": $navName" : ""}"),
          bottom: const TabBar(
            indicatorColor: Colors.white ,
            tabs: [
              Tab(text: "Info"),
              Tab(text: "Map"),
              Tab(text: "Thresholds"),
            ],
          ),
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

          type: BottomNavigationBarType.fixed, // Prevents background going to white when "shifting" e.g. more than 3 icons

          unselectedItemColor: Colors.grey[500],
          currentIndex: _appSettingsService.getRouteIndexByUiName(navNameOverride == "" ? navName?? "Home" : navNameOverride),

          items: navBarItems,
          onTap: (index)
          {
              Navigator.pushNamed(context, _appSettingsService.getRouteByIndex(index).routeName, arguments: "");
          },
        ),
        body: body
      )
    );
  }
}

