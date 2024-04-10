import 'package:marketplace/core/utils/extentions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/utils/helper.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: PopScope(
        canPop: false,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: Helper.introductionMessges.length,
                    itemBuilder: (
                      context,
                      index,
                    ) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 25,
                          right: 25,
                          bottom: 50,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox.shrink(),
                                Image(
                                  image: AssetImage(
                                      Helper.introductionMessges[index].image!),
                                  height:
                                      context.deviceSize.flipped.aspectRatio *
                                          150,
                                ),
                              ],
                            ),
                            const SizedBox.shrink(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  Helper.introductionMessges[index].title!,
                                  textAlign: TextAlign.center,
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  Helper.introductionMessges[index].subtitle!,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge!,
                                ),
                              ],
                            ),
                            const SizedBox.shrink(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Center(
                        child: SmoothPageIndicator(
                          controller: pageController,
                          onDotClicked: (value) {
                            pageController.animateToPage(
                              value,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                          effect: WormEffect(
                            activeDotColor:
                                Theme.of(context).colorScheme.primary,
                            dotColor: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(.5),
                            dotHeight: 10,
                            dotWidth: 10,
                            type: WormType.thin,
                          ),
                          count: Helper.introductionMessges.length,
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () {
                          Get.toNamed(AppRouteNames.register);
                        },
                        child: const Text(
                          "Register",
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          foregroundColor:
                              Theme.of(context).colorScheme.surface,
                        ),
                        onPressed: () {
                          Get.toNamed(AppRouteNames.login);
                        },
                        child: const Text(
                          "Login",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
