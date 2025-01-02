import 'package:flutter/material.dart';
import '../../../veoui.dart';

enum VeoImageContentMode {
  fill,
  fit,
}

class VeoImage extends StatefulWidget {
  final String? assetName;
  final String? url;
  final String placeholder;
  final VeoImageContentMode contentMode;
  final double cornerRadius;
  final bool showLoadingIndicator;
  final Color tintColor;
  final double? maxWidth;
  final double? maxHeight;
  final double? minWidth;
  final double? minHeight;

  const VeoImage({
    Key? key,
    this.assetName,
    this.url,
    this.placeholder = "photo",
    this.contentMode = VeoImageContentMode.fill,
    this.cornerRadius = 8,
    this.showLoadingIndicator = true,
    this.tintColor = Colors.grey,
    this.maxWidth,
    this.maxHeight,
    this.minWidth,
    this.minHeight,
  }) : super(key: key);

  @override
  State<VeoImage> createState() => _VeoImageState();
}

class _VeoImageState extends State<VeoImage> {
  late ImageProvider _imageProvider;
  bool _isLoading = true;
  bool _hasError = false;
  ImageStream? _imageStream;
  ImageStreamListener? _imageStreamListener;

  @override
  void initState() {
    super.initState();
    _initializeImage();
  }

  @override
  void didUpdateWidget(VeoImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url || oldWidget.assetName != widget.assetName) {
      _initializeImage();
    }
  }

  void _initializeImage() {
    _isLoading = true;
    _hasError = false;

    if (widget.assetName != null) {
      _imageProvider = AssetImage(widget.assetName!);
    } else if (widget.url != null) {
      _imageProvider = NetworkImage(widget.url!);
    } else {
      _hasError = true;
      _isLoading = false;
      return;
    }

    _imageStream?.removeListener(_imageStreamListener!);

    _imageStreamListener = ImageStreamListener(
          (_, __) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      },
      onError: (_, __) {
        if (mounted) {
          setState(() {
            _hasError = true;
            _isLoading = false;
          });
        }
      },
    );

    _imageStream = _imageProvider.resolve(const ImageConfiguration());
    _imageStream!.addListener(_imageStreamListener!);
  }

  @override
  void dispose() {
    _imageStream?.removeListener(_imageStreamListener!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: widget.minWidth ?? 0,
        maxWidth: widget.maxWidth ?? double.infinity,
        minHeight: widget.minHeight ?? 0,
        maxHeight: widget.maxHeight ?? double.infinity,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.cornerRadius),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_hasError) {
      return _buildErrorView();
    }

    if (_isLoading) {
      return _buildLoadingView();
    }

    return _buildImage();
  }

  Widget _buildImage() {
    return Image(
      image: _imageProvider,
      fit: widget.contentMode == VeoImageContentMode.fill
          ? BoxFit.cover
          : BoxFit.contain,
      width: widget.maxWidth,
      height: widget.maxHeight,
      errorBuilder: (context, error, stackTrace) => _buildErrorView(),
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: child,
        );
      },
    );
  }

  Widget _buildLoadingView() {
    return Container(
      color: Colors.grey.withOpacity(0.1),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.photo,
            size: 24,
            color: widget.tintColor.withOpacity(0.3),
          ),
          if (widget.showLoadingIndicator)
            VeoLoader(primaryColor: VeoUI.primaryColor, primaryDarkColor: VeoUI.primaryDarkColor,),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Container(
      color: Colors.grey.withOpacity(0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 24,
            color: widget.tintColor,
          ),
          const SizedBox(height: 8),
          VeoText(
            'Failed to load image',
            style: VeoTextStyle.caption,
            color: widget.tintColor,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _initializeImage,
            child: VeoText(
              'Retry',
              style: VeoTextStyle.caption,
              color: VeoUI.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}