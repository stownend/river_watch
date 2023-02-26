import 'package:flutter/material.dart';

import '../../common_services/app_settings_service.dart';
import '../../common_services/logging_service.dart';
import '../../ioc.dart';
import '../search/models/search_station_list.dart';
import '../search/view_models/search_view_model.dart';

class SearchListRow extends StatefulWidget {
  const SearchListRow({super.key, required this.searchViewModel});

  final SearchViewModel searchViewModel;

  @override
  // ignore: no_logic_in_create_state
  SearchListRowState createState() => SearchListRowState(searchViewModel: searchViewModel);
}

class SearchListRowState extends State<SearchListRow> {
  SearchListRowState({required this.searchViewModel});

  final SearchViewModel searchViewModel;


  // ignore: unused_field
  final _appSettingsService = getIt.get<AppSettingsService>();
  final _loggingService = getIt.get<LoggingService>();

  final controller = TextEditingController();

  List<SearchStationList> stations = [];

  @override
  void initState() {

    stations = searchViewModel.searchList;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    // ignore: unused_local_variable
    var logger = _loggingService.getLogger(this);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: 'What are you looking for?',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.blue)
            ),
          ),
          onChanged: search,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: stations.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  onTap: () {
                    //await Future.delayed(const Duration(seconds: 5));
                    
                    Navigator.pushNamed(
                      context, 
                      "/station", 
                      arguments: stations[index].id);

                  },
                  title: Text(stations[index].label),
                  subtitle: Text(stations[index].subLabel),
                )
              );
            }
          )
        )
      ],
    );
  }

  void search(String query) {
    final suggestions = searchViewModel.searchList.where((item) {
      final searchText = query.toLowerCase();

      return item.label.toLowerCase().contains(searchText);
    }).toList();  

    setState(() => stations = suggestions);
  }
}