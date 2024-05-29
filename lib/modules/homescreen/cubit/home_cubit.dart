import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:http_parser/src/media_type.dart';
import 'package:my_gellary/models/imagemodel.dart';
import 'package:my_gellary/shared/components/constants.dart';
import 'package:my_gellary/shared/network/endpoints.dart';
import 'package:my_gellary/shared/network/remote/diohelper.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of(context);

  bool isShowingPopup = false;
  ImageModel? imageModel;
  String? firstName;

  void showPopUp(bool showPopUp) {
    isShowingPopup = showPopUp;

    emit(ShowPopUpState());
  }

  File? image;
  var picker = ImagePicker();
  Future pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      emit(ImagePickedSuccessState());
    } else {
      emit(ImagePickedErrorState('No Image Selected'));
    }
  }

  Future<void> pickImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      emit(ImagePickedSuccessState());
    } else {
      emit(ImagePickedErrorState('No Image Selected'));
    }
  }

  Future<void> uploadImage() async {
    emit(AddImagePickedLoadingState());

    if (image == null) {
      emit(AddImagePickedErrorState('No Image Select'));
      return;
    }

    FormData formData = FormData();

    String fileName = image!.path;
    MediaType mediaType;
    if (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg')) {
      mediaType = MediaType('image', 'jpeg');
    } else if (fileName.endsWith('.png')) {
      mediaType = MediaType('image', 'png');
    } else if (fileName.endsWith('.gif')) {
      mediaType = MediaType('image', 'gif');
    } else {
      throw Exception('Unsupported file type');
    }
    formData.files.add(MapEntry(
        "img",
        await MultipartFile.fromFile(image!.path,
            filename: fileName, contentType: mediaType)));

    DioHelper.postData(url: upload, data: formData, token: token)
        .then((value) async {
      emit(AddImagePickedSuccessState());
    }).catchError((error) {
      emit(AddImagePickedErrorState(error));
    });
  }

  void getData() {
    emit(GetImageLoadingState());
    DioHelper.getData(url: getImages, token: token).then((value) {
      imageModel = ImageModel.fromJson(value.data);
      emit(GetImageSuccessState());
    }).catchError((error) {
      emit(GetImageErrorState());
    });
  }

  String getFirstName(String fullName) {
    List<String> nameParts = fullName.split(" ");
    return nameParts.isNotEmpty ? nameParts[0] : "";
  }
}
