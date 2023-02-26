import 'package:flutter/material.dart';

import '../../../common_models/view_argument.dart';
import '../../../common_services/app_settings_service.dart';
import '../../../common_services/logging_service.dart';
import '../../../ioc.dart';
import '../models/favourites_list.dart';

// ignore: must_be_immutable
class FavouritesSection extends StatelessWidget {
  FavouritesSection({super.key, required this.favouritesList, required this.sectionLabel});

  final String sectionLabel;
  final List<FavouritesList> favouritesList; 
  
  // ignore: unused_field
  final _appSettingsService = getIt.get<AppSettingsService>();
  final _loggingService = getIt.get<LoggingService>();

  @override
  Widget build(BuildContext context) {

    // ignore: unused_local_variable
    var logger = _loggingService.getLogger(this);

    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              const SizedBox(
                height: 20,
                child: SizedBox.expand(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xFF2196F3)
                    ),
                  )
                )
              ),
              Text(" $sectionLabel", style: const TextStyle(color: Colors.white)),
            ],
          ),

          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: favouritesList.length,
              itemBuilder: (BuildContext context, int index) {

                IconData icon = Icons.compare_arrows;
                
                if (favouritesList[index].isRising) {
                  icon = Icons.arrow_upward;
                } else if (favouritesList[index].isFalling) {
                  icon = Icons.arrow_downward;
                } else if (favouritesList[index].isIdeal) {
                  icon = Icons.compare_arrows;
                }

                return Card(
                  margin: const EdgeInsets.only(top: 1, bottom: 1),
                  child: ListTile(
                    dense: true,
                    onTap: () async {
                        Navigator.pushNamed(
                          context, 
                          "/station", 
                          arguments: ViewArgument(argString: "", argInt: favouritesList[index].id, navNameOverride: "Favourites"));
                    },
                    leading: Icon(icon),
                    title: Text(favouritesList[index].label)
                  )
                );
              }
            )
          )
        ],
      )
    );

  }

}