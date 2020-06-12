import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'authenticate/Authenticate.dart';

//Class to create the logic and UI for the welcome screen when starting the app
class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  //global key to track the intro screens state
  final introKey = GlobalKey<IntroductionScreenState>();

  //function that gets run at the end of the intro screen that takes the user to the login page
  void onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => Authenticate()),
    );
  }

  //function to make adding images on the screen easier by just taking in the image name
  Widget buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/$assetName.png', width: 250.0),
      alignment: Alignment.bottomCenter,
    );
  }

  //the build function draws the UI to the screen
  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );


    //Returns the IntroductionScreen package that creates nice looking cards that are horizontally scrollable
    return IntroductionScreen(
      key: introKey,
      pages: [
        //list of all the introduction cards
        PageViewModel(
          title: "Welcome to BarCard!",
          body:
              "We provide you with E-Business card with your contact details, so you can simply share it with a quick scan.",
          image: buildImage('1'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "QR Code Scanning",
          body:
              "Simply scan a cards QR code to add them to your list!",
          image: buildImage('2'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Local Networking",
          body:
              "View other cards in your area, and meet new people!",
          image: buildImage('3'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Let's get started",
          image: buildImage('appIcon2'),
          body: "Click Done To Login or Register!",
          decoration: pageDecoration,
        ),
      ],
      onDone: () => onIntroEnd(context),
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
