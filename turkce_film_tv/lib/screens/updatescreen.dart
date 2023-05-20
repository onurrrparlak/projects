import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_installer/flutter_app_installer.dart';
import 'package:path_provider/path_provider.dart';

class UpdateScreen extends StatefulWidget {
  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  bool downloading = false;
  double downloadProgress = 0;
  String downloadUrl = '';
  String patchNotes = '';
  String versionNumber = '';

  Future<void> fetchAppVersion() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('AppVersion')
          .doc('latestVersion')
          .get();

      final data = snapshot.data();

      if (data != null && data is Map<String, dynamic>) {
        setState(() {
          downloadUrl = data['downloadUrl'];
          patchNotes = data['patchNotes'];
          versionNumber = data['versionNumber'];
        });
      } else {
        print('Invalid data format or document does not exist');
      }
    } catch (error) {
      print('Error fetching app version: $error');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAppVersion();
  }

  void downloadFile(String url) async {
    Dio dio = Dio();
    try {
      setState(() {
        downloading = true;
        downloadProgress = 0;
      });

      final fileName = 'app-release.apk';
      final downloadDir = await getExternalStorageDirectory();
      final savePath = '${downloadDir!.path}/Download/$fileName';

      await dio.download(url, savePath,
          onReceiveProgress: (receivedBytes, totalBytes) {
        if (totalBytes != -1) {
          setState(() {
            downloadProgress = receivedBytes / totalBytes;
          });
        }
      });

      setState(() {
        downloading = false;
      });

      print('Downloaded file path: $savePath');
      doSomethingAfterDownload(savePath);
    } catch (e) {
      print(e.toString());
      setState(() {
        downloading = false;
      });
    }
  }

  Future<String> getFilePath(String fileName) async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    return '$appDocumentsPath/$fileName';
  }

  void doSomethingAfterDownload(String savePath) {
    FlutterAppInstaller.installApk(filePath: savePath).then((value) {
      // Installation successful
      print('APK installation completed!');
      // Perform your desired job here
    }).catchError((error) {
      // Installation failed
      print('APK installation failed: $error');
      // Handle the error if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Text(
                'Versiyon Numarası: $versionNumber',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Güncelleme Notları:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              RichText(
                text: TextSpan(
                  children: patchNotes
                      .split('. ')
                      .map((note) => TextSpan(
                            text: '$note\n',
                            style: TextStyle(fontSize: 16),
                          ))
                      .toList(),
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  downloadFile(downloadUrl);
                },
                child: Text('Güncelle'),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8.0), // Adjust the radius as needed
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 24.0), // Adjust the padding as needed
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  overlayColor: MaterialStateProperty.all<Color>(
                      Colors.green.withOpacity(0.8)),
                  elevation: MaterialStateProperty.all<double>(
                      0.0), // Remove the button shadow
                ),
              ),
              if (downloading)
                Column(
                  children: [
                    LinearProgressIndicator(
                      value: downloadProgress,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${(downloadProgress * 100).toStringAsFixed(0)}%',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
