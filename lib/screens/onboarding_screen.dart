import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/utilities/helpers.dart';
import '../routes/app_router.dart';
import '../widgets/custom_button.dart';
import '../widgets/onboarding_illustration.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Smart City Reporting',
      description:
          'Report civic issues instantly. Our AI prioritizes them for faster resolution.',
      pageIndex: 0,
      color: AppColors.softTeal,
    ),
    OnboardingData(
      title: 'Environmental Awareness',
      description:
          'Real-time IoT monitoring for air quality, noise levels, and environmental health.',
      pageIndex: 1,
      color: AppColors.mintGreen,
    ),
    OnboardingData(
      title: 'Cognitive Wellness',
      description:
          'Find calm zones and manage stress with personalized recommendations.',
      pageIndex: 2,
      color: AppColors.mutedLavender,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      Navigator.pushReplacementNamed(context, AppRouter.login);
    }
  }

  void _skip() {
    Navigator.pushReplacementNamed(context, AppRouter.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: Helpers.getBackgroundGradient(context),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _skip,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 32 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? _pages[index].color
                                : AppColors.textTertiary.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      text: _currentPage == _pages.length - 1
                          ? 'Get Started'
                          : 'Next',
                      onPressed: _nextPage,
                      color: _pages[_currentPage].color,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OnboardingIllustration(
            pageIndex: data.pageIndex,
            size: 280,
          ),
          const SizedBox(height: 48),
          Text(
            data.title,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            data.description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final int pageIndex;
  final Color color;

  OnboardingData({
    required this.title,
    required this.description,
    required this.pageIndex,
    required this.color,
  });
}
