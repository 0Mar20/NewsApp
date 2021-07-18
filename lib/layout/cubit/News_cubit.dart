import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/layout/cubit/News_states.dart';
import 'package:news_app/models/business/business.dart';
import 'package:news_app/models/science/science.dart';
import 'package:news_app/models/settings/settings.dart';
import 'package:news_app/models/sports/sports.dart';
import 'package:news_app/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates> {

  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<BottomNavigationBarItem> bottomItems =
  [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.business,
      ),
      label: 'Business',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.sports,
      ),
      label: 'Sports',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.science,
      ),
      label: 'Science',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.settings,
      ),
      label: 'Settings',
    ),
  ];

  List<Widget> screens =
  [
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),
    SettingsScreen(),
  ];

  List<dynamic> business = [];
  List<dynamic> sports = [];
  List<dynamic> science = [];
  List<dynamic> search = [];

  void changeBottomNavBarState(int index) {
    currentIndex = index;
    if(index == 1)
      {
        getSports();
      }
    if(index == 2)
      {
        getScience();
      }
    emit(BottomNavBarState());
  }

  void getBusiness() {
    emit(NewsGetBusinessLoadingState());

    if (business.length == 0) {
      DioHelper.getData(url: 'v2/top-headlines', query:
      {
        'country': 'us',
        'category': 'business',
        'apiKey': '0a01a8633ece4705aac5cdcdad2442ca',
      },
      ).then((value) {
        business = value.data['articles'];
        emit(NewsGetBusinessSuccessState());
      }).catchError((onError) {
        print(onError.toString());
        emit(NewsGetBusinessErrorState(onError.toString()));
      });
    } else
      {
      emit(NewsGetBusinessSuccessState());
      }
  }

  void getSports() {
    emit(NewsGetSportsLoadingState());

    if(sports.length == 0)
      {
        DioHelper.getData(
          url: 'v2/top-headlines',
          query: {
            'country': 'us',
            'category': 'sports',
            'apiKey': '0a01a8633ece4705aac5cdcdad2442ca',
          },
        ).then((value) {
          sports = value.data['articles'];
          emit(NewsGetSportsSuccessState());
        }).catchError((onError){
          print(onError.toString());
          emit(NewsGetSportsErrorState(onError));
        });
      } else
        {
          emit(NewsGetSportsSuccessState());
        }
  }

  void getScience() {
    emit(NewsGetScienceLoadingState());

    if(science.length == 0)
    {
      DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country': 'us',
          'category': 'science',
          'apiKey': '0a01a8633ece4705aac5cdcdad2442ca',
        },
      ).then((value) {
        science = value.data['articles'];
        emit(NewsGetScienceSuccessState());
      }).catchError((onError){
        print(onError.toString());
        emit(NewsGetScienceErrorState(onError));
      });
    } else
    {
      emit(NewsGetScienceSuccessState());
    }
  }

  void getSearch(String value) {

    emit(NewsGetSearchLoadingState());
    DioHelper.getData(
      url: 'v2/everything',
      query: {
        'q': '$value',
        'apiKey': '0a01a8633ece4705aac5cdcdad2442ca',
      },
    ).then((value) {
      search = value.data['articles'];
      emit(NewsGetSearchSuccessState());
    }).catchError((onError){
      print(onError.toString());
      emit(NewsGetSearchErrorState(onError));
    });
  }

}