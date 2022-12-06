import 'package:flutter/material.dart';
import 'package:tvapp/widgets/methods.dart';

class TestingClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            CallCustomMethods.myDialog("https://lh3.googleusercontent.com/ai-u36kG_ShXb3Ytp5YHrp--nsCdylwBe4L9lk5hOnZj9K1j1qCHbddCbcPvGFXUSFSrP3_jtcZ6X1jkCNe_WeQo_0NjGLbOHlBSAhQ2szx-WHAm89D_jKtSGyIJx-Y_exl05lU3o2U=dv", context);
          },
          child: Icon(
           Icons.play_arrow
          ),
        ),
    );
  }
}