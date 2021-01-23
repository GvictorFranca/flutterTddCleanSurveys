import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterClean/ui/helpers/helpers.dart';

import 'components/components.dart';

class SurveysPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final image =
        'https://itcraftapps.com/wp-content/uploads/2019/11/flutter-DART.jpg';
    return Scaffold(
        appBar: AppBar(
          title: Text(R.string.surveys),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: CarouselSlider(
            options: CarouselOptions(
              enlargeCenterPage: true,
              aspectRatio: 1,
            ),
            items: [
              SurveyItem(image: image),
              SurveyItem(image: image),
              SurveyItem(image: image),
            ],
          ),
        ));
  }
}
