import 'package:flutter/material.dart';
import '../../../veoui.dart';

class OnboardingItem {
  final String title;
  final String description;
  final String image;

  const OnboardingItem({
    required this.title,
    required this.description,
    required this.image,
  });
}

enum NavigationStyle {
  swipe,
  button,
  both,
}

enum ButtonAlignment {
  bottom,
  bottomTrailing,
}

class VeoOnboarding extends StatefulWidget {
  final List<OnboardingItem> items;
  final double titleFontSize;
  final double descriptionFontSize;
  final String skipButtonText;
  final String nextButtonText;
  final String getStartedButtonText;
  final NavigationStyle navigationStyle;
  final bool showSkipButton;
  final bool showNextButton;
  final ButtonAlignment buttonAlignment;
  final VoidCallback onFinish;

  const VeoOnboarding({
    Key? key,
    required this.items,
    this.titleFontSize = 28,
    this.descriptionFontSize = 20,
    this.navigationStyle = NavigationStyle.both,
    this.skipButtonText = "Skip",
    this.nextButtonText = "Next",
    this.getStartedButtonText = "Get Started",
    this.showSkipButton = true,
    this.showNextButton = true,
    this.buttonAlignment = ButtonAlignment.bottom,
    required this.onFinish,
  }) : super(key: key);

  @override
  State<VeoOnboarding> createState() => _VeoOnboardingState();
}

class _VeoOnboardingState extends State<VeoOnboarding> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool get isLastPage => _currentPage == widget.items.length - 1;

  String get buttonTitle => isLastPage
      ? widget.getStartedButtonText
      : widget.nextButtonText;

  void _nextPage() {
    if (_currentPage < widget.items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onFinish();
    }
  }

  void _skipOnboarding() {
    widget.onFinish();
  }

  Widget _buildPageView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          widget.items[_currentPage].image,
          height: 260,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 20),
        VeoText(
          widget.items[_currentPage].title,
          style: VeoTextStyle.title,
          color: VeoUI.primaryDarkColor
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: VeoText(
            widget.items[_currentPage].description,
            style: VeoTextStyle.subtitle,
            color: VeoUI.primaryColor
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.items.length,
            (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 2.5),
          height: 8,
          width: _currentPage == index ? 24 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? VeoUI.primaryColor
                : Colors.grey,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: VeoUI.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Container(
          color: VeoUI.primaryColor.withOpacity(0.05),
          child: Stack(
            children: [
              if (widget.navigationStyle != NavigationStyle.button)
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) => _buildPageView(),
                )
              else
                _buildPageView(),

              Column(
                children: [
                  if (widget.showSkipButton)
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextButton(
                          onPressed: _skipOnboarding,
                          child: VeoText(
                            widget.skipButtonText,
                            style: VeoTextStyle.subtitle,
                            color: VeoUI.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _buildPageIndicators(),
                  ),
                  if (widget.showNextButton)
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 20,
                        left: 20,
                        right: 20,
                      ),
                      child: VeoButton(
                        title: buttonTitle,
                        onPressed: _nextPage,
                        gradientColors: [
                          VeoUI.primaryColor,
                          VeoUI.primaryDarkColor,
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}