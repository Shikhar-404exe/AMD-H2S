import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'api_client.dart';

class ImageService {
  static final ImageService _instance = ImageService._internal();
  factory ImageService() => _instance;
  ImageService._internal();

  final ImagePicker _picker = ImagePicker();
  final ApiClient _apiClient = ApiClient();

  Future<bool> requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.request();

    if (status.isDenied) {
      status = await Permission.camera.request();
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }

    return status.isGranted;
  }

  Future<bool> requestStoragePermission() async {
    PermissionStatus status = await Permission.photos.request();

    if (status.isDenied) {
      status = await Permission.photos.request();
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }

    return status.isGranted;
  }

  Future<File?> pickImageFromCamera() async {
    try {
      bool hasPermission = await requestCameraPermission();
      if (!hasPermission) return null;

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image == null) return null;
      return File(image.path);
    } catch (e) {
      return null;
    }
  }

  Future<File?> pickImageFromGallery() async {
    try {
      bool hasPermission = await requestStoragePermission();
      if (!hasPermission) return null;

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image == null) return null;
      return File(image.path);
    } catch (e) {
      return null;
    }
  }

  Future<File?> pickMultipleImages() async {
    try {
      bool hasPermission = await requestStoragePermission();
      if (!hasPermission) return null;

      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image == null) return null;
      return File(image.path);
    } catch (e) {
      return null;
    }
  }

  Future<String?> uploadImage(File imageFile,
      {String endpoint = '/upload/image'}) async {
    try {
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final response = await _apiClient.upload(endpoint, formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['url'] ?? response.data['imageUrl'];
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<String>> uploadMultipleImages(List<File> imageFiles,
      {String endpoint = '/upload/images'}) async {
    try {
      List<MultipartFile> files = [];
      for (var imageFile in imageFiles) {
        String fileName = imageFile.path.split('/').last;
        files.add(await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ));
      }

      FormData formData = FormData.fromMap({
        'files': files,
      });

      final response = await _apiClient.upload(endpoint, formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> urls = response.data['urls'] ?? [];
        return urls.map((url) => url.toString()).toList();
      }

      return [];
    } catch (e) {
      return [];
    }
  }
}
