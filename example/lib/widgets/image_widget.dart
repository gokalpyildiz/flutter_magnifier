import 'package:flutter/material.dart';
import 'package:flutter_magnifier_example/viewmodel/magnifier_view_model.dart';
import 'package:image_picker/image_picker.dart';

class ImageWidget extends StatelessWidget {
  final MagnifierViewModel viewModel;

  const ImageWidget({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final image = viewModel.state.image;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (image != null)
          Expanded(
            child: Stack(
              children: [
                Image.file(
                  image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showImageSourceDialog(context),
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          ElevatedButton.icon(
            onPressed: () => _showImageSourceDialog(context),
            icon: const Icon(Icons.add_photo_alternate),
            label: const Text('Select Image'),
          ),
      ],
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                viewModel.pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                viewModel.pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }
}
