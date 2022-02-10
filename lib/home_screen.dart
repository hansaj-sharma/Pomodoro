import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pomodoro/utils/constants.dart';
import 'package:pomodoro/widget/custom_button.dart';
import 'package:pomodoro/widget/progress_icons.dart';
import 'package:pomodoro/model/pomodoro_status.dart';



class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

const buttonStartText = "Start Pomodoro";
const buttonResume = "Resume Pomodoro";
const buttonResumePomodoro = "Resume Break";
const buttonStartShortBreak = "Take short Break";
const buttonLongBreak = "Take long break";
const buttonTextPause = "Pause";
const buttonReset = "Reset";
const buttonNewSet = "Start New Set";

class _HomeState extends State<Home> {
  static AudioCache player = AudioCache();
  int remainingTime = pomodoroTime;
  String mainBtnText = buttonStartText;
  PomodoroStatus pomodoroStatus = PomodoroStatus.pausedPomodoro;
  Timer? _timer;
  int pomodoroNum = 0;
  int setNum = 0;

  @override
  void dispose(){
    _cancelTimer();
    super.dispose();
  }
  
  @override
  void initState(){
    super.initState();
    player.load('bell.mp3');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Center(
          child: Column(
            children:  <Widget>[
              const SizedBox(height: 10,),
               Text(
                "Pomodoro number: $pomodoroNum ",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white
                ),
              ),
          SizedBox(height: 10,),
          Text(
            "set: $setNum",
            style: TextStyle(
                fontSize: 22,
                color: Colors.white
            ),
          ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: CircularPercentIndicator(radius: 220,
                      lineWidth: 15.0,
                      percent: _getPomodoroPercentage(),
                      progressColor: statusColor[pomodoroStatus],
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Text(_secondsToFormattedString(remainingTime),
                      style: TextStyle(
                        fontSize: 40, color: Colors.white
                      )
                      ),
                      ),

                    ),
                    SizedBox(height: 10,),
                    ProgressIcons(total: pomodoriPerSet, done: pomodoroNum - (setNum * pomodoriPerSet)),
                    SizedBox(height: 10,),
                    Text(statusDescription[pomodoroStatus].toString(),
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    SizedBox(height: 20,),
                    CustomButton(onTap: _mainButtonPressed, text: mainBtnText),
                    CustomButton(onTap: _resetButtonPressed, text: buttonReset)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _secondsToFormattedString(int seconds){
    int roundedMinutes = seconds ~/ 60;
    int remainingSeconds = seconds - (roundedMinutes * 60);
    String remainingSecondsFormatted;

    if(remainingSeconds<10){
      remainingSecondsFormatted = "0$remainingSeconds";

    }
    else{
      remainingSecondsFormatted = remainingSeconds.toString();
    }

    return "$roundedMinutes:$remainingSecondsFormatted";
  }

  _getPomodoroPercentage(){
    int totalTime;

    switch (pomodoroStatus){
      case PomodoroStatus.runningPomodoro:
        totalTime = pomodoroTime;
        break;
      case PomodoroStatus.pausedPomodoro:
        totalTime = pomodoroTime;
        break;
      case PomodoroStatus.runningShortBreak:
        totalTime = shortBreak;
        break;
      case PomodoroStatus.pausedShortBreak:
        totalTime = shortBreak;
        break;
      case PomodoroStatus.runningLongBreak:
        totalTime = longBreakTime;
        break;
      case PomodoroStatus.pausedLongBreak:
        totalTime = longBreakTime;
        break;
      case PomodoroStatus.setFinished:
        totalTime = pomodoroTime;
        break;
    }

    double percentage = (totalTime - remainingTime) / totalTime;
    // print(percentage);
    return percentage;

  }
  _mainButtonPressed() {
    //print("button pressed");1
  switch(pomodoroStatus){
    case PomodoroStatus.pausedPomodoro:
      _startPomodoroCountDown();
      break;

    case PomodoroStatus.runningPomodoro:
      _pausePomodoroCountDown();
      break;
    case PomodoroStatus.runningShortBreak:
      _pauseShortBreakCountDown();
      break;
    case PomodoroStatus.pausedShortBreak:
      _startShortBreak();
      break;
    case PomodoroStatus.runningLongBreak:
      _pauseLongBreakCountDown();
      break;
    case PomodoroStatus.pausedLongBreak:
     _startLongBreak();
      break;
    case PomodoroStatus.setFinished:
     setNum++;
     _startPomodoroCountDown();
      break;
    }
  }
_startPomodoroCountDown(){
    pomodoroStatus= PomodoroStatus.runningPomodoro;
    _cancelTimer();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) => {
      if (remainingTime>0){
        setState(() {
          remainingTime--;
          mainBtnText = buttonTextPause;
        })
      }
      else{
        _playSound(),
        pomodoroNum++,
        _cancelTimer(),
        if(pomodoroNum % pomodoriPerSet == 0){
          pomodoroStatus =PomodoroStatus.pausedLongBreak,
          setState(() {
            remainingTime= longBreakTime;
            mainBtnText = buttonLongBreak;
          }),
        }
        else{
          pomodoroStatus = PomodoroStatus.pausedShortBreak,
          setState(() {
            remainingTime= shortBreak;
            mainBtnText = buttonStartShortBreak;
          }),
        }
      }
    });
  }

  _startShortBreak(){
    pomodoroStatus = PomodoroStatus.runningShortBreak;
    setState(() {
      mainBtnText =buttonTextPause;
    });
    _cancelTimer();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) => {
      if (remainingTime > 0 ){
        setState(() {
                   remainingTime--;
        }),
      }
      else{

        _playSound(),
        remainingTime = pomodoroTime,
        _cancelTimer(),
        pomodoroStatus = PomodoroStatus.pausedPomodoro,
        setState(() {
          mainBtnText = buttonStartText;

        }),
      }
    });
  }

  _startLongBreak(){
    pomodoroStatus = PomodoroStatus.runningLongBreak;
    setState(() {
      mainBtnText =buttonTextPause;
    });
    _cancelTimer();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) => {
      if (remainingTime > 0 ){
        setState(() {
          remainingTime--;
        }),
      }
      else{
        //todo play sound
        _playSound(),
        remainingTime = pomodoroTime,
        _cancelTimer(),
        pomodoroStatus = PomodoroStatus.setFinished,
        setState(() {
          mainBtnText = buttonNewSet;

        }),
      }
    });
  }
_pausePomodoroCountDown(){
 pomodoroStatus = PomodoroStatus.pausedPomodoro;
 _cancelTimer();
 setState(() {
   mainBtnText = buttonResume;
 });
}

_pauseShortBreakCountDown(){
    pomodoroStatus = PomodoroStatus.pausedShortBreak;
    _pausedBreakCountDown();
}
  _pauseLongBreakCountDown(){
    pomodoroStatus = PomodoroStatus.pausedLongBreak;
    _pausedBreakCountDown();
  }

_pausedBreakCountDown(){
    _cancelTimer();
    setState(() {
      mainBtnText = buttonResume;
    });
}

_resetButtonPressed(){
    setNum = 0;
    pomodoroNum = 0;
    _cancelTimer();
    _stopCountdown();
}
_stopCountdown(){
    pomodoroStatus = PomodoroStatus.pausedPomodoro;
    setState(() {
      mainBtnText = buttonStartText;
      remainingTime = pomodoroTime;
    });
}
  _cancelTimer()
  {
    if (_timer != null){
      _timer!.cancel();
    }
  }

  _playSound(){
   player.play('bell.mp3');
  }
}
