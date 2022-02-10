import 'package:flutter/material.dart';
import 'package:pomodoro/model/pomodoro_status.dart';

const pomodoroTime =25 * 60;
const shortBreak =5 * 60;
const longBreakTime = 20 * 60;
const pomodoriPerSet = 4;

const Map<PomodoroStatus, String> statusDescription = {
  PomodoroStatus.runningPomodoro: "Pomodoro is running, time to be focused",
  PomodoroStatus.pausedPomodoro: "Pomodoro is paused",
  PomodoroStatus.runningShortBreak: "Time for a short Break!",
  PomodoroStatus.pausedShortBreak: "Short break paused",
  PomodoroStatus.runningLongBreak: "Let's have a long Break now",
  PomodoroStatus.pausedLongBreak: "Paused Long Break",
  PomodoroStatus.setFinished: "Congrats!!"
};

const Map<PomodoroStatus, MaterialColor> statusColor = {
  PomodoroStatus.runningPomodoro: Colors.green,
  PomodoroStatus.pausedPomodoro:  Colors.orange,
  PomodoroStatus.runningShortBreak: Colors.red,
  PomodoroStatus.pausedShortBreak:  Colors.orange,
  PomodoroStatus.runningLongBreak:  Colors.red,
  PomodoroStatus.pausedLongBreak: Colors.orange,
  PomodoroStatus.setFinished: Colors.orange,
};