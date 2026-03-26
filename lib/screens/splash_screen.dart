import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  //////To display the logo/image of the splash view,
  final Widget image;

  /// To hide/show the loading.
  final bool? showLoading;

  /// To show loading to the bottom of the page.
  final bool? bottomLoading;

  /// Redirect to another page, when loading is completed.
  final Widget home;

  ///To display the title or name of you application.
  final String title;

  ///The [TextStyle] of the title.
  final TextStyle? titleTextStyle;

  ///  Redirected time (in seconds).
  final int? seconds;

  /// Background Color can be set using [backgroundColor]
  final Color? backgroundColor;

  /// The [Widget] of the loading indicator.
  final Widget? loading;

  ///Background image can be set using [backgroundImage]
  final ImageProvider<Object>? backgroundImage;

  ///The [BoxFit] of the background image.
  final BoxFit? backgroundImageFit;

  ///The opacity of the background image.
  final double? backgroundImageOpacity;

  ///The [ColorFilter] of the background image.
  final ColorFilter? backgroundImageColorFilter;

  const SplashView({
    super.key,
    required this.image,
    required this.title,
    required this.home,
    this.seconds = 3,
    this.showLoading = true,
    this.backgroundColor,
    this.backgroundImage,
    this.titleTextStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
    this.loading,
    this.bottomLoading = false,
    this.backgroundImageFit = BoxFit.cover,
    this.backgroundImageOpacity = 1.0,
    this.backgroundImageColorFilter,
  });

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: widget.seconds!),
      () {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => widget.home,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          image: (widget.backgroundImage != null)
              ? DecorationImage(
                  image: widget.backgroundImage!,
                  fit: widget.backgroundImageFit,
                  opacity: widget.backgroundImageOpacity!,
                  colorFilter: widget.backgroundImageColorFilter ??
                      ColorFilter.mode(
                        Colors.black.withValues(alpha: 0.6),
                        BlendMode.darken,
                      ),
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (widget.bottomLoading!) ? const Spacer() : const SizedBox(),
            widget.image,
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                widget.title,
                style: widget.titleTextStyle,
              ),
            ),
            (widget.bottomLoading!) ? const Spacer() : const SizedBox(),
            Visibility(
              visible: widget.showLoading!,
              child: widget.loading ?? const RefreshProgressIndicator(),
            ),
            (widget.bottomLoading!)
                ? const SizedBox(height: 20)
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
