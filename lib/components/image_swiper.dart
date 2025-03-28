import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

class ImageSwiper extends StatelessWidget {
  final List<String> images = [
    'lib/assets/images/slider1.jpg',
    'lib/assets/images/slider2.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // size
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              images[index],
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          );
        },
        itemCount: images.length,
        pagination: SwiperPagination(), // dots
        // control: SwiperControl(), // arrows
        autoplay: true,
        viewportFraction: 0.96, //image width
        scale: 0.95,
      ),
    );
  }
}
