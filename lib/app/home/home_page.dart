import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import '../../services/logging_service.dart';
import 'my_scaffold.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final loggingService = Provider.of<LoggingService>(context, listen: false);

    List<CarouselImage> carouselImages = [
      CarouselImage("Fishing", "images/carousel/fishing.png"),
      CarouselImage("Boating", "images/carousel/boating.png"),
      CarouselImage("Camping", "images/carousel/camping.png"),
      CarouselImage("Canoeing", "images/carousel/canoeing.png"),
      CarouselImage("Hiking", "images/carousel/hiking.png"),
      CarouselImage("Sailing", "images/carousel/sailing.png"),
    ];

    final logger = loggingService.getLogger(this);
    logger.i("kDebugMode: $kDebugMode");
    logger.i("kIsWeb    : $kIsWeb");
    logger.i("Images in ${(kDebugMode && kIsWeb)?"":"assets/"}${carouselImages[0]}");

    return MyScaffold(
      navName: "Home",
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right:15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Opacity(opacity: 0.6,  
                child: CarouselSlider(
                  options: CarouselOptions(
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
                            Expanded(
                              child: FittedBox(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Image.asset("${(kDebugMode && kIsWeb)?"":"assets/"}${i.imageName}",),
                                )
                              )
                            ),
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
                ),
              ),
              const SizedBox(height: 32),
                Text(
                  'Keep a check on the rivers that you frequent for your leisure or work activities. \n\nYou can easily browse by location or can search by name or proximity. \n\nSign In to set high and low level thresholds for your favourite locations and then be alerted whenever those thresholds are breached.',
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