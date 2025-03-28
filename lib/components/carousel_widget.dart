import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselWidget extends StatelessWidget {
  final List<String> imageList;

  CarouselWidget({required this.imageList});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        // height: 100,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 12 / 6,
        viewportFraction: 0.7,
      ),
      items: imageList
          .map((item) => Container(
                child: Center(
                  child: Image.asset(item, fit: BoxFit.cover),
                ),
              ))
          .toList(),
    );
  }
}
