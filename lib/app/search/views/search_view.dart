import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/app_bar_and_nav_bar_scaffold.dart';
import '../../components/app_error.dart';
import '../../components/app_loading.dart';
import '../../components/search_list_row.dart';
import '../view_models/search_view_model.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  SearchViewState createState() => SearchViewState();
}

class SearchViewState extends State<SearchView> {

  late SearchViewModel _viewModel;

  @override
  void initState() {

    _viewModel = Provider.of<SearchViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

          _viewModel.getSearchList();
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return AppBarAndNavBarScaffold(
      navName: "Search",
      body: Padding(
          padding: const EdgeInsets.all(15),
          child: Consumer<SearchViewModel>(
            builder: (_, model, child) {
              return _ui(model);
            }
          )
        ),
    );
  }

  _ui(SearchViewModel viewModel) {

    if (viewModel.loading) {
      return const AppLoading(); 
    }
  
    if (viewModel.hasError) {
      return AppError(appError: viewModel.browseError); 
    }

    return SearchListRow(searchViewModel: viewModel);
  }

}