import 'package:citizenone_app/modules/agency_banking/core/models/file_model.dart';
import 'package:citizenone_app/modules/agency_banking/core/services/file_picker_service.dart';
import 'package:flutter/material.dart';

Future<FileModel?> pickFile(BuildContext context) async {
  return await showModalBottomSheet<FileModel>(
    context: context,
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Capture Image"),
            onTap: () async {
              final file = await FilePickerService().pickImageFromCamera();
              if (!context.mounted) return;
              Navigator.pop(context, file);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text("Select Image"),
            onTap: () async {
              final file = await FilePickerService().pickImageFromGallery();
              if (!context.mounted) return;
              Navigator.pop(context, file);
            },
          ),
          ListTile(
            leading: const Icon(Icons.insert_drive_file),
            title: const Text("Select Document"),
            onTap: () async {
              final file = await FilePickerService().pickDocument();
              if (!context.mounted) return;
              Navigator.pop(context, file);
            },
          ),
        ],
      );
    },
  );
}
