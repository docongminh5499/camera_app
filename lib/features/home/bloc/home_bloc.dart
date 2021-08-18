import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:my_camera_app_demo/features/app/presentation/bloc/app_bloc.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AppBloc appBloc;

  HomeBloc({@required this.appBloc}) : super(HomeInitial());
  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is PrepareLogoutEvent) {
      yield PrepareLogoutState();
      Future.delayed(Duration(milliseconds: 500), () {
        appBloc.add(LogoutEvent());
      });
    }
  }
}
