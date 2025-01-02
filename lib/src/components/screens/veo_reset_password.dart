import 'package:flutter/material.dart';
import '../../../veoui.dart';
import '../feedback/veo_toast.dart';

class VeoResetPassword extends StatefulWidget {
  final String appName;
  final Widget? appIcon;
  final String? appLogo;
  final String title;
  final String subtitle;
  final String emailPlaceholder;
  final String resetButtonTitle;
  final String backToLoginButtonTitle;
  final bool showToast;
  final String pleaseFillEmailMessage;
  final Future<void> Function(String email)? onResetTapped;
  final VoidCallback? onBackToLoginTapped;
  final VoidCallback? onResetSuccess;
  final Function(String error)? onResetError;

  const VeoResetPassword({
    Key? key,
    required this.appName,
    this.appIcon,
    this.appLogo,
    this.title = "Reset Password",
    this.subtitle = "Enter your email address and we'll send you a link to reset your password.",
    this.emailPlaceholder = "Your Email",
    this.resetButtonTitle = "Send Reset Link",
    this.backToLoginButtonTitle = "Back to Login",
    this.showToast = false,
    this.pleaseFillEmailMessage = "Please enter your email!",
    this.onResetTapped,
    this.onBackToLoginTapped,
    this.onResetSuccess,
    this.onResetError,
  }) : super(key: key);

  @override
  _VeoResetPasswordState createState() => _VeoResetPasswordState();
}

class _VeoResetPasswordState extends State<VeoResetPassword> {
  String _email = '';
  bool _isLoading = false;
  VeoToastMessage? _currentToast;
  bool _isEmailValid = true;

  void _handleReset() async {
    if (_email.isEmpty) {
      setState(() {
        _currentToast = VeoToastMessage(
          message: widget.pleaseFillEmailMessage,
          style: VeoToastStyle.warning,
          position: VeoToastPosition.bottom,
        );
      });
      return;
    }

    if (!_isEmailValid) {
      setState(() {
        _currentToast = VeoToastMessage(
          message: "Please enter a valid email address",
          style: VeoToastStyle.error,
          position: VeoToastPosition.bottom,
        );
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _currentToast = null;
    });

    try {
      await widget.onResetTapped?.call(_email);
      widget.onResetSuccess?.call();
    } catch (error) {
      setState(() {
        _currentToast = VeoToastMessage(
          message: error.toString(),
          style: VeoToastStyle.error,
          position: VeoToastPosition.bottom,
        );
      });
      widget.onResetError?.call(error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: VeoUI.isRTL ? TextDirection.ltr : TextDirection.ltr,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    VeoUI.primaryColor,
                    VeoUI.primaryDarkColor,
                  ],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.appIcon != null) widget.appIcon!,
                          if (widget.appLogo != null)
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(VeoUI.defaultCornerRadius),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: VeoUI.defaultElevation,
                                    offset: Offset(0, VeoUI.defaultElevation),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(VeoUI.defaultCornerRadius),
                                child: Image.asset(
                                  widget.appLogo!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                          VeoText(
                            widget.appName,
                            style: VeoTextStyle.title,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 20),
                          VeoText(
                            widget.title,
                            style: VeoTextStyle.subtitle,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: VeoText(
                              widget.subtitle,
                              style: VeoTextStyle.body,
                              color: Colors.white.withOpacity(0.8)
                            ),
                          ),
                          const SizedBox(height: 40),
                          VeoTextField(
                            text: _email,
                            onChanged: (value) {
                              setState(() {
                                _email = value;
                                _isEmailValid = _validateEmail(value);
                              });
                            },
                            icon: Icons.email,
                            placeholder: widget.emailPlaceholder,
                            keyboardType: TextInputType.emailAddress,
                            validation: _validateEmail,
                          ),
                          const SizedBox(height: 30),
                          VeoButton(
                            title: widget.resetButtonTitle,
                            onPressed: _handleReset,
                            isEnabled: !_isLoading,
                            style: VeoButtonStyle.primary,
                            gradientColors: [VeoUI.primaryColor, VeoUI.primaryDarkColor],
                            shape: VeoButtonShape.rounded,
                            elevation: VeoUI.defaultElevation,
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: widget.onBackToLoginTapped,
                            child: VeoText(
                              widget.backToLoginButtonTitle,
                              style: VeoTextStyle.body,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (widget.showToast)
              VeoToast(
                currentToast: _currentToast,
                onToastChanged: (toast) {
                  setState(() {
                    _currentToast = toast;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}