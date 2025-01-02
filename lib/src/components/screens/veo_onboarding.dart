import 'package:flutter/material.dart';
import '../../../veoui.dart';

class OnboardingItem {
  final String title;
  final String description;
  final String image;

  OnboardingItem({
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
  final VoidCallback? onFinish;
  final Color primaryColor;
  final Color primaryDarkColor;
  final bool isRTL;

  const VeoOnboarding({
    Key? key,
    required this.items,
    this.titleFontSize = 28,
    this.descriptionFontSize = 20,
    this.skipButtonText = 'Skip',
    this.nextButtonText = 'Next',
    this.getStartedButtonText = 'Get Started',
    this.navigationStyle = NavigationStyle.both,
    this.showSkipButton = true,
    this.showNextButton = true,
    this.buttonAlignment = ButtonAlignment.bottom,
    this.onFinish,
    required this.primaryColor,
    required this.primaryDarkColor,
    this.isRTL = false,
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

  String get buttonTitle =>
      isLastPage ? widget.getStartedButtonText : widget.nextButtonText;

  void _nextPage() {
    if (_currentPage < widget.items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onFinish?.call();
    }
  }

  void _skipOnboarding() {
    widget.onFinish?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Stack(
          children: [
            if (widget.navigationStyle != NavigationStyle.button)
              _buildPageView()
            else
              _buildCurrentPage(),
            _buildNavigationOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) => setState(() => _currentPage = index),
      itemCount: widget.items.length,
      itemBuilder: (context, index) => _buildPage(widget.items[index]),
    );
  }

  Widget _buildCurrentPage() {
    return _buildPage(widget.items[_currentPage]);
  }

  Widget _buildPage(OnboardingItem item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          item.image,
          height: 260,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Text(
                item.title,
                style: TextStyle(
                  fontFamily: VeoUI.mainFont,
                  fontSize: widget.titleFontSize,
                  color: widget.primaryDarkColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                item.description,
                style: TextStyle(
                  fontFamily: VeoUI.mainFont,
                  fontSize: widget.descriptionFontSize,
                  color: widget.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationOverlay() {
    return Column(
      children: [
        if (widget.showSkipButton)
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextButton(
                onPressed: _skipOnboarding,
                child: Text(
                  widget.skipButtonText,
                  style: TextStyle(
                    fontFamily: VeoUI.mainFont,
                    color: widget.primaryColor,
                  ),
                ),
              ),
            ),
          ),
        const Spacer(),
        _buildPageIndicators(),
        if (widget.showNextButton)
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.primaryColor,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                buttonTitle,
                style: TextStyle(
                  fontFamily: VeoUI.mainFont,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPageIndicators() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.items.length,
          (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 2.5),
            height: 8,
            width: _currentPage == index ? 24 : 8,
            decoration: BoxDecoration(
              color: _currentPage == index ? widget.primaryColor : Colors.grey,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}
