import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../components/app_bar_and_nav_bar_scaffold.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    List<CarouselImage> carouselImages = [
      CarouselImage("Fishing", "images/carousel/fishing.png"),
      CarouselImage("Boating", "images/carousel/boating.png"),
      CarouselImage("Camping", "images/carousel/camping.png"),
      CarouselImage("Canoeing", "images/carousel/canoeing.png"),
      CarouselImage("Hiking", "images/carousel/hiking.png"),
      CarouselImage("Sailing", "images/carousel/sailing.png"),
    ];

    return AppBarAndNavBarScaffold(
      navName: "Home",
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Opacity(opacity: 0.6,  
                  child: CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 1,
                      height: 400.0,
                      enlargeCenterPage: false,
                      autoPlay: true,
                      viewportFraction: 1.0
                    ),
                    items: carouselImages.map<Widget>((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Column(
                            children: <Widget>[
                              // Expanded(
                              //   child: FittedBox(
                              //     child: SizedBox(
//                                    width: MediaQuery.of(context).size.width,
//                                    height: MediaQuery.of(context).size.height,
//                                    child: Image.asset("${(kDebugMode && kIsWeb)?"":"assets/"}${i.imageName}",),
                                    Image.asset("${(kDebugMode && kIsWeb)?"":"assets/"}${i.imageName}", height: 320),
                              //     )
                              //   )
                              // ),
                              const SizedBox(height: 12),
                              Text(
                                i.displayName,
                                style: Theme.of(context).textTheme.headlineLarge,
                              ),
                            ],
                          );
                        },
                      );
                    }).toList(),
                  )
              ),
              const SizedBox(height: 32),
              Text(
                'Keep a check on the rivers that you frequent for your leisure or work activities. \n\nYou can easily browse by location or can search by name or proximity. \n\nSign In to select favourite locations then set high and low level thresholds that will send notifications whenever those thresholds are breached.',
                  style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        )
      ),
    );

  }
}

class CarouselImage {
  String displayName;
  String imageName;

  CarouselImage(this.displayName, this.imageName);
}