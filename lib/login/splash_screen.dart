import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ircell/screens/tabs_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/scheduler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 5));
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const TabsScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional(0, 1),
                  child: Shimmer.fromColors(
                    baseColor: Colors.white.withOpacity(0.5),
                    highlightColor: Colors.white,
                    period: const Duration(milliseconds: 400),
                    child: Container(
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                              'assets/images/ircircle2.png',
                              width: 150,
                              height: 150,
                              fit: BoxFit.fill,
                              alignment: const Alignment(0, 0),
                            )
                            .animate(
                              onInit:
                                  (controller) =>
                                      controller.repeat(reverse: true),
                            )
                            .scale(
                              begin: const Offset(1.2, 1.2),
                              end: const Offset(0.3, 0.3),
                              delay: 400.ms,
                              duration: 1000.ms,
                              curve: Curves.easeInOut,
                            )
                            .rotate(
                              begin: 0,
                              end: 1,
                              delay: 400.ms,
                              duration: 1000.ms,
                              curve: Curves.easeInOut,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
