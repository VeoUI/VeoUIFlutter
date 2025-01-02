import 'package:flutter/material.dart';
import '../../../veoui.dart';
import '../feedback/veo_toast.dart';

class VeoRegister extends StatefulWidget {
  final String appName;
  final Widget? appIcon;
  final String? appLogo;
  final String title;
  final String fullNamePlaceholder;
  final String emailPlaceholder;
  final String passwordPlaceholder;
  final String confirmPasswordPlaceholder;
  final String registerButtonTitle;
  final String alreadyHaveAccountButtonTitle;
  final bool showToast;
  final String pleaseFillInAllFieldsToastMessage;
  final String passwordsDontMatchMessage;
  final Future<void> Function(String fullName, String email, String password)? onRegisterTapped;
  final VoidCallback? onLoginTapped;
  final VoidCallback? onRegisterSuccess;
  final Function(String error)? onRegisterError;

  const VeoRegister({
    Key? key,
    required this.appName,
    this.appIcon,
    this.appLogo,
    this.title = "Register",
    this.fullNamePlaceholder = "Full Name",
    this.emailPlaceholder = "Your Email",
    this.passwordPlaceholder = "Your Password",
    this.confirmPasswordPlaceholder = "Confirm Password",
    this.registerButtonTitle = "Register",
    this.alreadyHaveAccountButtonTitle = "Already have an account? Login Now!",
    this.showToast = false,
    this.pleaseFillInAllFieldsToastMessage = "Please fill in all fields!",
    this.passwordsDontMatchMessage = "Passwords don't match!",
    this.onRegisterTapped,
    this.onLoginTapped,
    this.onRegisterSuccess,
    this.onRegisterError,
  }) : super(key: key);

  @override
  _VeoRegisterState createState() => _VeoRegisterState();
}

class _VeoRegisterState extends State<VeoRegister> {
  String _fullName = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  bool _isLoading = false;
  VeoToastMessage? _currentToast;
  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  bool _isFullNameValid = true;

  void _handleRegister() async {
    if (_fullName.isEmpty || _email.isEmpty || _password.isEmpty || _confirmPassword.isEmpty) {
      setState(() {
        _currentToast = VeoToastMessage(
          message: widget.pleaseFillInAllFieldsToastMessage,
          style: VeoToastStyle.warning,
          position: VeoToastPosition.bottom,
        );
      });
      return;
    }

    if (_password != _confirmPassword) {
      setState(() {
        _currentToast = VeoToastMessage(
          message: widget.passwordsDontMatchMessage,
          style: VeoToastStyle.warning,
          position: VeoToastPosition.bottom,
        );
      });
      return;
    }

    if (!_isEmailValid || !_isPasswordValid || !_isFullNameValid) {
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
      await widget.onRegisterTapped?.call(_fullName, _email, _password);
      widget.onRegisterSuccess?.call();
    } catch (error) {
      setState(() {
        _currentToast = VeoToastMessage(
          message: error.toString(),
          style: VeoToastStyle.error,
          position: VeoToastPosition.bottom,
        );
      });
      widget.onRegisterError?.call(error.toString());
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

  bool _validatePassword(String password) {
    return password.length >= 6;
  }

  bool _validateFullName(String fullName) {
    return fullName.length >= 2;
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
                          const SizedBox(height: 40),
                          VeoTextField(
                            text: _fullName,
                            onChanged: (value) {
                              setState(() {
                                _fullName = value;
                                _isFullNameValid = _validateFullName(value);
                              });
                            },
                            icon: Icons.person,
                            placeholder: widget.fullNamePlaceholder,
                            validation: _validateFullName,
                          ),
                          const SizedBox(height: 20),
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
                          const SizedBox(height: 20),
                          VeoTextField(
                            text: _confirmPassword,
                            onChanged: (value) {
                              setState(() {
                                _confirmPassword = value;
                              });
                            },
                            icon: Icons.lock,
                            placeholder: widget.confirmPasswordPlaceholder,
                            isSecure: true,
                          ),
                          const SizedBox(height: 30),
                          VeoButton(
                            title: widget.registerButtonTitle,
                            onPressed: _handleRegister,
                            isEnabled: !_isLoading,
                            style: VeoButtonStyle.primary,
                            gradientColors: [VeoUI.primaryColor, VeoUI.primaryDarkColor],
                            shape: VeoButtonShape.rounded,
                            elevation: VeoUI.defaultElevation,
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: widget.onLoginTapped,
                            child: VeoText(
                              widget.alreadyHaveAccountButtonTitle,
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