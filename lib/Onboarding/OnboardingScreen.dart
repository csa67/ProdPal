import 'package:flutter/material.dart';
import 'package:hci/Onboarding/intro_page_1.dart';
import 'package:hci/Onboarding/intro_page_2.dart';
import 'package:hci/Onboarding/intro_page_3.dart';
import 'package:hci/Onboarding/intro_page_4.dart';
import 'package:hci/main.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget{
  const OnBoardingScreen({super.key});

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>{

  final PageController _controller = PageController();

  bool onLastPage = false;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index){
              setState(() {
                onLastPage = index == 3;
              });
            },
            children: const [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
              IntroPage4(),
            ],
          ),
          Container(
              alignment: const Alignment(0,0.75),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: (){
                        _controller.previousPage(
                          duration:const Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                        );
                      },
                      child: const Text('Back'),
                    ),
                    SmoothPageIndicator(controller: _controller, count: 4),
                    //next or done
                    onLastPage ?
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(
                            builder: (context) {
                              return const MyHomePage();
                        },
                        ));
                      },
                      child: const Text('Done'),
                    ) :
                    GestureDetector(
                      onTap: (){
                        _controller.nextPage(
                          duration:const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      },
                      child: const Text('Next'),
                    )

                  ]

              )
          )
        ],
      ),
    );
  }
}