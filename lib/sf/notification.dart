import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo_app/models/task.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  late FlutterLocalNotificationsPlugin notificationsPlugin;

  NotificationService._private() {
    initNotification();
  }
  static final NotificationService instance = NotificationService._private();
  Future<void> initNotification() async {
    notificationsPlugin = FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('flutter_logo');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      print("Click notification");
    });
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('taskID', 'taskName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

  Future<void> scheduleSendNotifi(Task task) async {
    //dueDate -  1 phút thì gửi notification;
    DateTime notificationTime = task.dueDate;

    // if (now.isAfter(notificationTime) && now.isBefore(task.dueDate)) {
    notificationsPlugin.zonedSchedule(
      task.taskId.hashCode,
      'Task Reminder',
      'Your task "${task.title}" is approaching its due date!',
      tz.TZDateTime.from(notificationTime, tz.local),
      const NotificationDetails(
          android: AndroidNotificationDetails(
              'full screen channel id', 'full screen channel name',
              channelDescription: 'full screen channel description',
              priority: Priority.high,
              importance: Importance.high,
              fullScreenIntent: true)),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: task.taskId,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
    // }
  }
}
