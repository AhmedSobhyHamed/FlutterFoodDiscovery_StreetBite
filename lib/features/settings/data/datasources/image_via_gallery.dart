import 'package:flutterfooddiscovery_streetbite/core/services/image_service.dart';
import 'package:image_picker/image_picker.dart';

class ImageViaGallery implements ImageService {
  final ImagePicker _picker = ImagePicker();

  @override
  Future<String?> pickOneFromGallery() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    return image?.path;
  }
}
