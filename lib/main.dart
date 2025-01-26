// import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
// import 'components/nfc_widget.dart';
import 'package:nfc_manager/nfc_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // runApp(const MaterialApp(home: MainApp()));
  runApp(MaterialApp(
      title: 'MagnifyingGlass',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(115, 34, 255, 1)),
      ),
      home: MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  AppState createState() => AppState();
}

class AppState extends State<MainApp> {
  late AudioPlayer player = AudioPlayer();
  ValueNotifier<dynamic> result = ValueNotifier(null);

  @override
  void initState() {
    super.initState();

    // Create the audio player.
    player = AudioPlayer();

    // Set the release mode to keep the source after playback has completed.
    player.setReleaseMode(ReleaseMode.stop);

    // Start the player as soon as the app is displayed.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await player.setSource(AssetSource('sound/mossberg.mp3'));
    });
  }

  @override
  void dispose() {
    // Release all sources and dispose the player.
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Magnifying Glass'),
          backgroundColor: Theme.of(context).primaryColor,
          titleTextStyle:
              TextStyle(color: Theme.of(context).secondaryHeaderColor),
        ),
        // body: PlayerWidget(player: player),
        body: Column(
          children: [
            ElevatedButton(child: Text('Tag Read?'), onPressed: _tagRead),
          ],
        ));
  }

  void _tagRead() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      result.value = tag.data;
      print('!!!');
      await player.resume();
      // NfcManager.instance.stopSession();
    });
  }
}
