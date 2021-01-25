import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterClean/ui/components/components.dart';
import 'package:flutterClean/ui/helpers/helpers.dart';
import 'package:flutterClean/ui/pages/pages.dart';

import 'components/components.dart';

class SurveysPage extends StatelessWidget {
  final SurveysPresenter presenter;

  SurveysPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.string.surveys),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) {
          presenter.isLoadingStream.listen((isLoading) {
            if (isLoading == true) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });

          presenter.loadData();
          return StreamBuilder<List<SurveyViewModel>>(
            stream: presenter.surveysStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.only(top: 100.0, left: 58),
                  child: Container(
                    height: 200,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(60.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            snapshot.error,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          RaisedButton(
                            onPressed: presenter.loadData,
                            child: Text(
                              R.string.reload,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }

              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      enlargeCenterPage: true,
                      aspectRatio: 1,
                    ),
                    items: snapshot.data
                        .map((viewModel) => SurveyItem(viewModel))
                        .toList(),
                  ),
                );
              }
              return SizedBox(
                height: 0,
              );
            },
          );
        },
      ),
    );
  }
}
