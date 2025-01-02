import 'package:flutter/material.dart';
import '../../../veoui.dart';
import '../feedback/veo_toast.dart';

class VeoLogin extends StatefulWidget {
  final String appName;
  final Widget? appIcon;
  final String? appLogo;
  final String title;
  final String emailPlaceholder;
  final String passwordPlaceholder;
  final String loginButtonTitle;
  final String forgotPasswordButtonTitle;
  final String dontHaveAccountButtonTitle;
  final bool showToast;
  final String pleaseFillInAllFieldsToastMessage;
  final Future<void> Function(String email, String password)? onLoginTapped;
  final VoidCallback? onRegisterTapped;
  final VoidCallback? onForgotPasswordTapped;
  final VoidCallback? onLoginSuccess;
  final Function(String error)? onLoginError;

  const VeoLogin({
    Key? key,
    required this.appName,
    this.appIcon,
    this.appLogo,
    this.title = "Login",
    this.emailPlaceholder = "Your Email",
    this.passwordPlaceholder = "Your Password",
    this.loginButtonTitle = "Login",
    this.forgotPasswordButtonTitle = "Forgot Password?",
    this.dontHaveAccountButtonTitle = "Don't have an account? Register Now!",
    this.showToast = false,
    this.pleaseFillInAllFieldsToastMessage = "Please fill in all fields!",
    this.onLoginTapped,
    this.onRegisterTapped,
    this.onForgotPasswordTapped,
    this.onLoginSuccess,
    this.onLoginError,
  }) : super(key: key);

  @override
  _VeoLoginState createState() => _VeoLoginState();
}

class _VeoLoginState extends State<VeoLogin> {
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  VeoToastMessage? _currentToast;
  bool _isEmailValid = true;
  bool _isPasswordValid = true;

  void _handleLogin() async {
    if (_email.isEmpty || _password.isEmpty) {
      setState(() {
        _currentToast = VeoToastMessage(
          message: widget.pleaseFillInAllFieldsToastMessage,
          style: VeoToastStyle.warning,
          position: VeoToastPosition.bottom,
        );
      });
      return;
    }

    if (!_isEmailValid || !_isPasswordValid) {
      setState(() {
        _currentToast = VeoToastMessage(
          message: "Please check your input fields",
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
      await widget.onLoginTapped?.call(_email, _password);
      widget.onLoginSuccess?.call();
    } catch (error) {
      setState(() {
        _currentToast = VeoToastMessage(
          message: error.toString(),
          style: VeoToastStyle.error,
          position: VeoToastPosition.bottom,
        );
      });
      widget.onLoginError?.call(error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _validateEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegex.hasMatch(email);
  }

  bool _validatePassword(String password) {
    return password.length >= 6;
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
                                borderRadius: BorderRadius.circular(
                                    VeoUI.defaultCornerRadius),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: VeoUI.defaultElevation,
                                    offset: Offset(0, VeoUI.defaultElevation),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    VeoUI.defaultCornerRadius),
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
                          const SizedBox(height: 20),
                          VeoTextField(
                            text: _password,
                            onChanged: (value) {
                              setState(() {
                                _password = value;
                                _isPasswordValid = _validatePassword(value);
                              });
                            },
                            icon: Icons.lock,
                            placeholder: widget.passwordPlaceholder,
                            isSecure: true,
                            validation: _validatePassword,
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: VeoUI.isRTL
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: TextButton(
                              onPressed: widget.onForgotPasswordTapped,
                              child: VeoText(
                                widget.forgotPasswordButtonTitle,
                                style: VeoTextStyle.body,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          VeoButton(
                            title: widget.loginButtonTitle,
                            onPressed: _handleLogin,
                            isEnabled: !_isLoading,
                            style: VeoButtonStyle.primary,
                            gradientColors: [
                              VeoUI.primaryColor,
                              VeoUI.primaryDarkColor
                            ],
                            shape: VeoButtonShape.rounded,
                            elevation: VeoUI.defaultElevation,
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: widget.onRegisterTapped,
                            child: VeoText(
                              widget.dontHaveAccountButtonTitle,
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
