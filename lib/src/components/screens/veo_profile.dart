import 'package:flutter/material.dart';
import '../../../veoui.dart';
import '../feedback/veo_toast.dart';

class VeoProfile extends StatefulWidget {
  final String appName;
  final Widget? appIcon;
  final String? appLogo;
  final String title;
  final String subtitle;
  final String fullNamePlaceholder;
  final String emailPlaceholder;
  final String phonePlaceholder;
  final String bioPlaceholder;
  final String saveButtonTitle;
  final String changePhotoButtonTitle;
  final String logoutButtonTitle;
  final bool showToast;
  final String pleaseFillRequiredFieldsMessage;
  final String profileUpdatedMessage;
  final String? avatarUrl;
  final Map<String, String>? initialData;
  final Future<void> Function(Map<String, String> data, String? newAvatarPath)? onSaveProfile;
  final Future<void> Function()? onLogout;
  final VoidCallback? onPhotoChanged;
  final VoidCallback? onSaveSuccess;
  final Function(String error)? onSaveError;

  const VeoProfile({
    Key? key,
    required this.appName,
    this.appIcon,
    this.appLogo,
    this.title = "Profile",
    this.subtitle = "Manage your profile information",
    this.fullNamePlaceholder = "Full Name",
    this.emailPlaceholder = "Email",
    this.phonePlaceholder = "Phone Number",
    this.bioPlaceholder = "Bio",
    this.saveButtonTitle = "Save Changes",
    this.changePhotoButtonTitle = "Change Photo",
    this.logoutButtonTitle = "Logout",
    this.showToast = false,
    this.pleaseFillRequiredFieldsMessage = "Please fill in all required fields!",
    this.profileUpdatedMessage = "Profile updated successfully!",
    this.avatarUrl,
    this.initialData,
    this.onSaveProfile,
    this.onLogout,
    this.onPhotoChanged,
    this.onSaveSuccess,
    this.onSaveError,
  }) : super(key: key);

  @override
  _VeoProfileState createState() => _VeoProfileState();
}

class _VeoProfileState extends State<VeoProfile> {
  String _fullName = '';
  String _email = '';
  String _phone = '';
  String _bio = '';
  bool _isLoading = false;
  VeoToastMessage? _currentToast;
  String? _newAvatarPath;

  @override
  void initState() {
    super.initState();
    _fullName = widget.initialData?['fullName'] ?? '';
    _email = widget.initialData?['email'] ?? '';
    _phone = widget.initialData?['phone'] ?? '';
    _bio = widget.initialData?['bio'] ?? '';
  }

  Future<void> _handleSave() async {
    if (_fullName.isEmpty || _email.isEmpty) {
      setState(() {
        _currentToast = VeoToastMessage(
          message: widget.pleaseFillRequiredFieldsMessage,
          style: VeoToastStyle.warning,
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
      final profileData = {
        'fullName': _fullName,
        'email': _email,
        'phone': _phone,
        'bio': _bio,
      };

      await widget.onSaveProfile?.call(profileData, _newAvatarPath);

      setState(() {
        _currentToast = VeoToastMessage(
          message: widget.profileUpdatedMessage,
          style: VeoToastStyle.success,
          position: VeoToastPosition.bottom,
        );
      });

      widget.onSaveSuccess?.call();
    } catch (error) {
      setState(() {
        _currentToast = VeoToastMessage(
          message: error.toString(),
          style: VeoToastStyle.error,
          position: VeoToastPosition.bottom,
        );
      });
      widget.onSaveError?.call(error.toString());
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

  bool _validateName(String name) {
    return name.length >= 2;
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: ClipOval(
                                child: widget.avatarUrl != null
                                    ? Image.network(
                                  widget.avatarUrl!,
                                  fit: BoxFit.cover,
                                )
                                    : Icon(
                                  Icons.person,
                                  size: 80,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        VeoIconButton(
                          icon: Icons.camera_alt,
                          title: widget.changePhotoButtonTitle,
                          onPressed: widget.onPhotoChanged ?? () {},
                        ),
                        const SizedBox(height: 30),

                        VeoTextField(
                          text: _fullName,
                          onChanged: (value) => setState(() => _fullName = value),
                          icon: Icons.person,
                          placeholder: widget.fullNamePlaceholder,
                          validation: _validateName,
                        ),
                        const SizedBox(height: 20),

                        VeoTextField(
                          text: _email,
                          onChanged: (value) => setState(() => _email = value),
                          icon: Icons.email,
                          placeholder: widget.emailPlaceholder,
                          keyboardType: TextInputType.emailAddress,
                          validation: _validateEmail,
                        ),
                        const SizedBox(height: 20),

                        VeoTextField(
                          text: _phone,
                          onChanged: (value) => setState(() => _phone = value),
                          icon: Icons.phone,
                          placeholder: widget.phonePlaceholder,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 20),

                        VeoTextField(
                          text: _bio,
                          onChanged: (value) => setState(() => _bio = value),
                          icon: Icons.description,
                          placeholder: widget.bioPlaceholder,
                        ),
                        const SizedBox(height: 30),

                        VeoButton(
                          title: widget.saveButtonTitle,
                          onPressed: _handleSave,
                          isEnabled: !_isLoading,
                          style: VeoButtonStyle.primary,
                          shape: VeoButtonShape.rounded,
                          elevation: 4.0,
                          gradientColors: [
                            VeoUI.primaryColor,
                            VeoUI.primaryDarkColor,
                          ],
                        ),
                        const SizedBox(height: 20),

                        VeoButton(
                          title: widget.logoutButtonTitle,
                          onPressed: widget.onLogout ?? () {},
                          style: VeoButtonStyle.danger,
                          shape: VeoButtonShape.rounded,
                        ),
                      ],
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