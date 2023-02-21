import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/app_bar_and_nav_bar_scaffold.dart';
import '../../components/app_error.dart';
import '../../components/app_loading.dart';
import '../../components/browse_list_row.dart';
import '../view_models/browse_view_model.dart';

class BrowseView extends StatefulWidget {
  const BrowseView({super.key});

  @override
  BrowseViewState createState() => BrowseViewState();
}

class BrowseViewState extends State<BrowseView> {

  late BrowseViewModel _viewModel;

  late String _parents = "";

  @override
  void initState() {

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
              return _ui(model);
            }
          )
        ),
    );
  }

  _ui(BrowseViewModel browseViewModel) {

    if (browseViewModel.loading) {
      return const AppLoading(); 
    }
  
    if (browseViewModel.hasError) {
      return AppError(appError: browseViewModel.browseError); 
    }

    return BrowseListRow(browseViewModel: browseViewModel, initialParents: _parents);
  }

}