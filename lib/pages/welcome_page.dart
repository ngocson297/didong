import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/login_page.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_chat_app/pages/widgets/button_widget.dart';


class OnBoardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SafeArea(
    child: IntroductionScreen(
      pages: [
        PageViewModel(
          title: 'Chat anytime, anywhere',
          body: 'Chat with the people you want',
          // image: buildImage('/assets/images/1.png'),
          image:  new Image.asset('assets/images/1.png'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'your space in your dream',
          body: 'quickly and easy to chat and messenging with your friends',
          // image: buildImage('/assets/images/2.png'),
          image:  new Image.asset('assets/images/2.png'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'Simple UI',
          body: 'For a great chat experience',
          // image: buildImage('/assets/images/3.png'),
          image:  new Image.asset('assets/images/3.png'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'Perfect Chat Solution',
          body: 'Start your chat',
          footer: ButtonWidget(
            text: 'Get Started',
            onClicked: () => goToHome(context),
          ),
          // image: buildImage('/assets/images/4.png'),
          image:  new Image.asset('assets/images/4.png'),
          decoration: getPageDecoration(),
        ),
      ],
      done: Text('Login', style: TextStyle(fontWeight: FontWeight.w600)),
      onDone: () => goToHome(context),
      showSkipButton: true,
      skip: Text('Skip'),
      onSkip: () => goToHome(context),
      next: Icon(Icons.arrow_forward),
      dotsDecorator: getDotDecoration(),
      onChange: (index) => print('Page $index selected'),
      globalBackgroundColor: Theme.of(context).primaryColorDark,
      skipFlex: 0,
      nextFlex: 0,
      // isProgressTap: false,
      // isProgress: false,
      // showNextButton: false,
      // freeze: true,
      // animationDuration: 1000,
    ),
  );

  void goToHome(context) => Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => LoginPage()),
  );

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 350));

  DotsDecorator getDotDecoration() => DotsDecorator(
    color: Color(0xFFFF5722),
    activeColor: Colors.orange,
    size: Size(10, 10),
    activeSize: Size(22, 10),
    activeShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  );

  PageDecoration getPageDecoration() => PageDecoration(
    titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    bodyTextStyle: TextStyle(fontSize: 20),
    descriptionPadding: EdgeInsets.all(16).copyWith(bottom: 0),
    imagePadding: EdgeInsets.all(24),
    pageColor: Colors.white,
  );
}







