import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ircell/app_theme.dart';
import 'package:ircell/login/widget_tree.dart';
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
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const WidgetTree()),
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
        body: Container(
          decoration: AppTheme.gradientBackground,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with shimmer effect
                Shimmer.fromColors(
                  baseColor: Colors.white.withOpacity(0.5),
                  highlightColor: Colors.white,
                  period: const Duration(milliseconds: 1500),
                  child: Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                            'assets/images/ircircle2.png',
                            width: 150,
                            height: 150,
                            fit: BoxFit.fill,
                          )
                          .animate(
                            onInit: (controller) => controller.repeat(reverse: true),
                          )
                          .scale(
                            begin: const Offset(1.0, 1.0),
                            end: const Offset(1.2, 1.2),
                            duration: 1500.ms,
                            curve: Curves.easeInOut,
                          ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // App Name text with fade-in animation
                const Text(
                  'IR CELL',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                )
                .animate()
                .fade(duration: 800.ms, delay: 500.ms)
                .slideY(begin: 0.2, end: 0, duration: 800.ms, curve: Curves.easeOut),
                
                const SizedBox(height: 16),
                
                // Tagline with fade-in animation
                const Text(
                  'Connect. Collaborate. Create.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                )
                .animate()
                .fade(duration: 800.ms, delay: 1000.ms)
                .slideY(begin: 0.2, end: 0, duration: 800.ms, curve: Curves.easeOut),
              ],
            ),
          ),
        ),
      ),
    );
  }
}