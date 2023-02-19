import 'package:flutter/material.dart';

import '../../common_services/app_settings_service.dart';
import '../../ioc.dart';
import '../browse/view_models/browse_view_model.dart';

class BrowseListRow extends StatelessWidget {
  BrowseListRow({super.key, required this.browseViewModel});

  final BrowseViewModel browseViewModel;

  final _appSettingsService = getIt.get<AppSettingsService>();

  @override
  Widget build(BuildContext context) {

    var browseList = browseViewModel.browseList;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(browseList.scope, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: browseList.names.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, _appSettingsService.getRouteByIndex(_appSettingsService.getRouteIndexByUiName("Browse")).routeName, arguments: browseViewModel.getNewParents(browseList.names[index]));
                  },
                  title: Text(browseList.names[index])
                )
              );
            }
          )
        )
      ],
    );
  }

}