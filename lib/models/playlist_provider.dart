import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_padi/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  //playlist of songs

  final List<Song> _playlist = [
    Song(
      artistName: 'Ruger',
      albumArtImagePath: 'assets/images/urban.jpeg',
      audioPath: 'audio/ruger.mp3',
      songName: "Tour",
    ),
    Song(
      artistName: 'Kizz Daniel',
      albumArtImagePath: 'assets/images/djparty.jpeg',
      audioPath: 'audio/Kizz-Daniel-Twe-Twe-New-Song-(TrendyBeatz.com).mp3',
      songName: "Twe Twe",
    ),
    Song(
      artistName: 'Nasboi',
      albumArtImagePath: 'assets/images/urban.jpeg',
      audioPath: 'audio/Nasboi-Ft-Wande-Coal-Umbrella-(TrendyBeatz.com).mp3',
      songName: "Umbrella",
    ),
  ];

  int? _currentSongIndex;

  /*
  AUDIO PLAYER CONTROLS 
  */

  //audio player
  final _audioPlayer = AudioPlayer();

  //durations

  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  //constructor

  PlaylistProvider() {
    listenToDuration();
  }

  //initially not playing
  bool _isPlaying = false;

  //play the song
  void play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;

    await _audioPlayer.stop(); //stop playing current song
    await _audioPlayer.play(AssetSource(path)); //play new song
    _isPlaying = true;
    notifyListeners();
  }

  //pause current song

  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  //resume playinng

  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }
  //pause or resume

  void pauseOrResume() {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  //seek to a specific position in the current song
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  //play next song
  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        //go to the next song if its not the last
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        //if its the last song loop back to the first song
        currentSongIndex = 0;
      }
    }
  }

  //play prevoius song

  void playPreviousSong() {
    //if its more than 2 seconds , restart the song
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    }
    //if its within 2 seconds, go to the previous song
    else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        //if its the first song, loop back to the last song
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

  //listen to duration
  void listenToDuration() {
    //listen for total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });
    //listen for current duration
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    //listen for duration completed
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  //dispose audio player

  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  set currentSongIndex(int? newIndex) {
    //update current song index
    _currentSongIndex = newIndex;
    if (newIndex != null) {
      play();
    }

    //update UI
    notifyListeners();
  }
}
