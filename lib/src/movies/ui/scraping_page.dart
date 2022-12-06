import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tvapp/src/movies/models/scraped_data_model.dart';
import 'package:tvapp/widgets/methods.dart';

class ScrapingPage extends StatefulWidget {
  final VoidCallback load;
  final String query;
  final Stream<dynamic> bloc;

  ScrapingPage({this.load, this.query, this.bloc});

  @override
  _ScrapingPageState createState() => _ScrapingPageState();
}

String titleCase(String text) {
  if (text.length <= 1) return text.toUpperCase();
  var words = text.split(' ');
  var capitalized = words.map((word) {
    var first = word.substring(0, 1).toUpperCase();
    var rest = word.substring(1);
    return '$first$rest';
  });
  return capitalized.join(' ');
}

class _ScrapingPageState extends State<ScrapingPage> {
  Map<String, String> header = {
    "Cookie":
        '_ga=GA1.2.863992754.1585894355; _gid=GA1.2.1774785778.1585894355; approve=1; captcha=03AHaCkAadTvT4gou81zJ-mmFJALlDpXuFKf9vuEys-K0ysWotD0P8QWD858ijDwaeh8dS0kr6uGHK9i5eDqnK5FMQ2p9JasomCrHNPFxVe8uiYP_4mc9oz5PgkGE6B504Ng8KVbGXsOYxnetBPA1BJcucq6PAAwsJJS8LW453pXZ9yNv780WAxr_7fWJwdupTIebIitqIAp3JHr_hx5regQBJ1p9ffk-qFcHal-JIBDWTK9lIKo_ID8N4YhNhAsvkRpQpveMlpK4Kij5gx_ws9Zii77EaHoTcbC6JtW4bvq6s6ZBH24vRT6pEBGAsDrCQJNIFYMxNjdLx0iJLMBIXf17MnQ4PNa3VefzgA0bG1uDBd5toO1v_pZEivCALAcP9uee-APQyQKv3',
  };

  @override
  void initState() {
    widget.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent()
      },
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text(titleCase(widget.query))),
        ),
        body: StreamBuilder<List<ScrapingModel>>(
            stream: widget.bloc,
            builder: (context, AsyncSnapshot<List<ScrapingModel>> snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data);
                if (snapshot.data.isEmpty) {
                  return Center(
                    child: Text("No Data"),
                  );
                } else {
                  return Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        ScrapingModel scrapingModel = snapshot.data[index];
                        return ListTile(
                          leading: Icon(Icons.link),
                          title: Text(scrapingModel.name),
                          onTap: () async {
                            // http.Response response = await http.head(snapshot.data[index], headers: header);

                            //   var response = await Dio().head(
                            //   snapshot.data[index],
                            //   options: Options(
                            //       followRedirects: false,
                            //       headers: header,
                            //       validateStatus: (status) {
                            //         return status < 500;
                            //       }),
                            // );
                            // String link = response.headers["location"][0];
                            // link = "https:"+link;
                            // print(link);
                            CallCustomMethods.myDialog(
                              scrapingModel.url,
                              context,
                              header: header,
                            );
                          },
                        );
                      },
                    ),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
