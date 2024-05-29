part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class ShowPopUpState extends HomeState {}

final class ImagePickedSuccessState extends HomeState {}

final class ImagePickedErrorState extends HomeState {
  final String error;

  ImagePickedErrorState(this.error);
}

final class AddImagePickedLoadingState extends HomeState {}

final class AddImagePickedSuccessState extends HomeState {}

final class AddImagePickedErrorState extends HomeState {
  final String error;

  AddImagePickedErrorState(this.error);
}

final class GetImageLoadingState extends HomeState {}

final class GetImageSuccessState extends HomeState {}

final class GetImageErrorState extends HomeState {}
