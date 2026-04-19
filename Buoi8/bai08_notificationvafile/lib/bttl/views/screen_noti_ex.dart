import 'package:flutter/material.dart';
import 'package:bai08_notificationvafile/bttl/services/bai1.dart';

class ScreenNotiEx extends StatelessWidget {
  const ScreenNotiEx({super.key});
  @override
  Widget build(BuildContext context) {
    NotificationService notificatiosnservice = NotificationService();
    notificatiosnservice.init();
    return Scaffold(
      appBar: AppBar(title: Text("Screen Noti Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //nut lenh len lich notification
            ElevatedButton(
              onPressed: () {
                notificatiosnservice.showSimpleNotification();
              },
              child: Text("Gửi thông báo nhắc học Ngoại ngữ"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                notificatiosnservice.scheduleNotificationAfter(
                  Duration(minutes: 2),
                  'drink_water_channel',
                  'Uống nước',
                  'Nhắc uống nước đúng giờ',
                );
              },
              child: Text("Gửi thông báo nhắc uống nước sau 2 phút"),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed:
                  () {}, //sinh viên tự viết code để đặt lịch gửi thông báo nhắc học Ngoại ngữ sau 10 phút

              child: Text("Hẹn giờ gửi thông báo học Ngoại ngữ sau 10 phút"),
            ),
          ],
        ),
      ),
    );
  }
}
