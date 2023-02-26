import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../common_services/logging_service.dart';
import '../../../ioc.dart';
import '../../components/app_bar_and_nav_bar_scaffold.dart';
import '../../components/app_error.dart';
import '../../components/app_loading.dart';
import 'browse_list_row.dart';
import '../models/browse_list.dart';
import '../repositories/browse_service.dart';
import '../view_models/browse_view_model.dart';

// ignore: must_be_immutable
class BrowseView extends StatelessWidget {
  BrowseView({super.key});

  late String _parents = "";

  @override
  Widget build(BuildContext context) {

    var args = ModalRoute.of(context)!.settings.arguments;
    _parents = args == null ? "" : args as String;

    return AppBarAndNavBarScaffold(
      navName: "Browse",
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: _ui()
      )
    );
  }

  _ui() {

    var browseService = getIt.get<BrowseService>();
    var loggingService = getIt.get<LoggingService>();
    var logger = loggingService.getLogger(this);

    List<String> parentList = _parents == "" ? [] : _parents.split('|');

    BrowseList browseList;
    
    if (parentList.length < 4) {
      browseList = browseService.getSimpleBrowseList(parentList);
    } else {
      browseList = browseService.getSimpleStationList();
    }

    // if (_viewModel.loading) {
    //   return const AppLoading(); 
    // }
  
    // if (_viewModel.hasError) {
    //   return AppError(appError: _viewModel.browseError); 
    // }

    logger.d("Called for: $_parents");

    return BrowseListRow(browseList: browseList, initialParents: _parents);
  }


}




class BrowseViewFull extends StatefulWidget {
  const BrowseViewFull({super.key});

  @override
  BrowseViewState createState() => BrowseViewState();
}

class BrowseViewState extends State<BrowseViewFull> {

  late BrowseViewModel _viewModel;
  late LoggingService _loggingService;
  late Logger _logger;

  late String _parents = "";

  @override
  void initState() {

    _loggingService = getIt.get<LoggingService>();
    
    _logger = _loggingService.getLogger(this);

    _viewModel = Provider.of<BrowseViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

          var args = ModalRoute.of(context)!.settings.arguments;
          _parents = args == null ? "" : args as String;

          _viewModel.getBrowseList(_parents);
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    
    return AppBarAndNavBarScaffold(
      navName: "Browse",
      body: Padding(
          padding: const EdgeInsets.all(15),
          child: Consumer<BrowseViewModel>(
            builder: (_, model, child) {

              _logger.i("Called with $_parents");
    
              return _ui(model);
            }
          )
        ),
    );
  }

  _ui(BrowseViewModel viewModel) {

    if (viewModel.loading) {
      return const AppLoading(); 
    }
  
    if (viewModel.hasError) {
      return AppError(appError: viewModel.browseError); 
    }

    return BrowseListRow(browseList: viewModel.browseList, initialParents: _parents);
  }

}