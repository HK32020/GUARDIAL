import 'package:flutter/material.dart';
import 'package:guardial/utils/utils.dart';
import 'package:guardial/widgets/widgets.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
        backgroundColor: Palette.guardialPurple,
        builder: (context, size) {
          return Container(
            height: size.height,
            width: size.width,
            child: Stack(
              children: [
                Center(
                  child: Container(
                    child: GuardialLogoWidget(width: size.width / 3 * 2),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 100.h,
                    color: Palette.lightBlue.withOpacity(.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20.w),
                          child: Button(
                            text: 'Log in',
                            onPressed: () {
                              // Navigator.pushNamed(context, )
                            },
                            color: Palette.offWhite,
                            textColor: Palette.lightBlue,
                            isSmall: true,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 20.w),
                          child: Button(
                            text: 'Register',
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, setupScreenViewRoute);
                            },
                            color: Palette.darkGrey,
                            textColor: Colors.white,
                            isSmall: true,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
