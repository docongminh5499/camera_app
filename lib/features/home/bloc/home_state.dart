part of 'home_bloc.dart';

@immutable
abstract class HomeState extends Equatable {
  @override
  List<Object> get props => <dynamic>[];
}

class HomeInitial extends HomeState {}

class PrepareLogoutState extends HomeState {}
