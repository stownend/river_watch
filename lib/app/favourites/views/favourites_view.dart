import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common_models/constants.dart';
import '../../components/app_bar_and_nav_bar_scaffold.dart';
import '../../components/app_blank.dart';
import '../../components/app_error.dart';
import '../../components/app_loading.dart';
import '../models/favourites_list.dart';
import '../view_models/favourites_view_model.dart';
import 'favourites_section.dart';

class FavouritesView extends StatefulWidget {
  const FavouritesView({super.key});

 @override
  FavouritesViewState createState() => FavouritesViewState();
}

class FavouritesViewState extends State<FavouritesView> {

  late FavouritesViewModel _viewModel;

  @override
  void initState() {

    _viewModel = Provider.of<FavouritesViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

          _viewModel.getFavouritesList();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return AppBarAndNavBarScaffold(
      navName: "Favourites",
      body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Consumer<FavouritesViewModel>(
            builder: (_, model, child) {
              return Column( 
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ui(model, FavouriteCategory.TooDeep),
                  _ui(model, FavouriteCategory.Ideal),
                  _ui(model, FavouriteCategory.TooShallow),
                ],
              );
            }
          )
        ),
    );
  }

  _ui(FavouritesViewModel viewModel, FavouriteCategory category) {

    String label = "";
    List<FavouritesList> list = [];
    var allFavourites = viewModel.favouritesList;

    if (viewModel.loading && category == FavouriteCategory.TooDeep) {
      return const AppLoading(); 
    } else if (viewModel.loading) {
      return const AppBlank(); 
    }

  
    if (viewModel.hasError) {
      return AppError(appError: viewModel.browseError); 
    }

    switch(category) { 
      case FavouriteCategory.TooDeep: {
          label = "Too Deep"; 
          list = allFavourites.where((element) => element.level == 1).toList();
        } 
      break; 
     
      case FavouriteCategory.Ideal: {
          label = "Ideal"; 
          list = allFavourites.where((element) => element.level == 0).toList();
        } 
      break; 
     
      case FavouriteCategory.TooShallow: {
          label = "Too Shallow"; 
          list = allFavourites.where((element) => element.level == -1).toList();
        } 
      break; 
     
      default: { 
          label = "Unknown"; 
          list = [];
        } 
      break; 
   } 

    return FavouritesSection(sectionLabel: label, favouritesList: list);
  }

}