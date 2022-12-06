import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:tvapp/widgets/chewie_player.dart';
import 'package:tvapp/widgets/video_player.dart';

class CallCustomMethods {
  static void _playOnMX(String link) {
    final AndroidIntent intent = AndroidIntent(
      action: 'action_view',
      data: Uri.encodeFull(link),
      package: 'com.mxtech.videoplayer.ad',
      // arguments: <String, dynamic>{
      //   'headers' : ['Cookie',
      // '_ga=GA1.2.863992754.1585894355; _gid=GA1.2.1774785778.1585894355; approve=1; captcha=03AHaCkAadTvT4gou81zJ-mmFJALlDpXuFKf9vuEys-K0ysWotD0P8QWD858ijDwaeh8dS0kr6uGHK9i5eDqnK5FMQ2p9JasomCrHNPFxVe8uiYP_4mc9oz5PgkGE6B504Ng8KVbGXsOYxnetBPA1BJcucq6PAAwsJJS8LW453pXZ9yNv780WAxr_7fWJwdupTIebIitqIAp3JHr_hx5regQBJ1p9ffk-qFcHal-JIBDWTK9lIKo_ID8N4YhNhAsvkRpQpveMlpK4Kij5gx_ws9Zii77EaHoTcbC6JtW4bvq6s6ZBH24vRT6pEBGAsDrCQJNIFYMxNjdLx0iJLMBIXf17MnQ4PNa3VefzgA0bG1uDBd5toO1v_pZEivCALAcP9uee-APQyQKv3']
      // }
    );
    intent.launch();
  }

  static void myDialog(String link, BuildContext context,
      {Map<String, String> header}) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Container(
          child: AlertDialog(
            title: new Text("Choose Player"),
            content: Column(
              children: <Widget>[
                ListTile(
                  title: Text("MX Player"),
                  onTap: () {
                    Navigator.pop(context);
                    _playOnMX(link);
                  },
                ),
                // Divider(),
                // ListTile(
                //   title: Text("Flutter Player"),
                //   onTap: (){
                //     Navigator.pop(context);
                //     Navigator.push(
                //                 context,
                //                 new MaterialPageRoute(
                //                     builder: (context) => VideoApp(
                //                           link: link,
                //                         )));
                //   },
                // ),
                Divider(),
                ListTile(
                  title: Text("IJK Player"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => CustomVideoPlayer(
                                  link: link,
                                )));
                  },
                ),
                Divider(),
                ListTile(
                  title: Text("Chewie Player"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => ChewieDemo(
                                  link: link,
                                )));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
