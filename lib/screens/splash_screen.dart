import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimatedSplashScreen extends ConsumerStatefulWidget {
  final Color backgroundColor;

  const AnimatedSplashScreen({
    super.key,
    required this.backgroundColor,
  });

  @override
  ConsumerState<AnimatedSplashScreen> createState() => AnimatedSplashScreenState();
}

class AnimatedSplashScreenState extends ConsumerState<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  static final StateProvider<bool> isAnimationComplete = StateProvider<bool>((ref) => false);

  @override
  void initState() {
    super.initState();
    ref.read(isAnimationComplete.notifier).state = false;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 0.9, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            ref.read(isAnimationComplete.notifier).state = true;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
          ),
          child: Center(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Icon Container
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: colorScheme.onPrimary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.onPrimary.withValues(alpha: 0.2),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.local_shipping_rounded,
                          size: 64,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Animated Title
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: Column(
                          children: [
                            Text(
                              "Hello Truck",
                              style: textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: colorScheme.onPrimary,
                                letterSpacing: 1.5,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Your Logistics Partner',
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.onPrimary.withValues(alpha: 0.85),
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Loading Indicator
                    if (ref.watch(isAnimationComplete))
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}