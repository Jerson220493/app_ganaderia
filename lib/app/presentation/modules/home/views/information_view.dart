import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';

class QrRepresentationScreen extends StatelessWidget {
  final int bobinoId;
  final ScreenshotController screenshotController = ScreenshotController();

  QrRepresentationScreen({Key? key, required this.bobinoId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'QR del Bobino $bobinoId',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bobino ID: $bobinoId',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 20),
            // Envolver el QR en el widget Screenshot
            Screenshot(
              controller: screenshotController,
              child: QrImageView(
                data: bobinoId.toString(), // El ID del bobino se convierte a QR
                version: QrVersions.auto,
                size: 250.0,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _saveQrCode(context);
              },
              child: const Text('Imprimir'),
            ),
          ],
        ),
      ),
    );
  }

  // Función para capturar el QR y guardarlo como imagen
  Future<void> _saveQrCode(BuildContext context) async {
    try {
      // Capturar la imagen del widget QR
      final image = await screenshotController.capture();

      if (image != null) {
        // Obtener el directorio para almacenar la imagen
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = '${directory.path}/bobino_$bobinoId.png';

        // Guardar la imagen como archivo PNG
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(image);

        // Mostrar un diálogo de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('QR guardado en $imagePath')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el QR: $e')),
      );
    }
  }
}
