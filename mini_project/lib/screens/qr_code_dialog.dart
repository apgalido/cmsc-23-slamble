import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:mini_project/models/user.dart';

class QRCodeDialog extends StatefulWidget {
  final UserModel userModel;

  const QRCodeDialog({super.key, required this.userModel});

  @override
  _QRCodeDialogState createState() => _QRCodeDialogState();
}

class _QRCodeDialogState extends State<QRCodeDialog> {
  @override
  Widget build(BuildContext context) {
    final qrData = jsonEncode(widget.userModel.toJson());

    print(qrData);

    return AlertDialog(
      title: const Text('Your QR Code',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      content: SizedBox(
        width: 250,
        height: 250,
        child: Center(
          child: QrImageView(
            data: qrData,
            version: QrVersions.auto,
            size: 200.0,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            try {
              final qrPainter = QrPainter(
                data: qrData,
                version: QrVersions.auto,
                gapless: true,
              );

              final directory = (await getApplicationDocumentsDirectory()).path;
              final fileName = '$directory/qr_code.png';
              final file = File(fileName);

              final imageData = await qrPainter.toImageData(200);
              if (imageData != null) {
                await file.writeAsBytes(imageData.buffer.asUint8List(
                    imageData.offsetInBytes, imageData.lengthInBytes));

                await GallerySaver.saveImage(file.path);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('QR Code saved to gallery!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to generate QR Code')),
                );
              }
            } catch (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to save QR Code: $error')),
              );
            }

            Navigator.of(context).pop();
          },
          child: const Text(
            'Download',
            style: TextStyle(color: Colors.black),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}
