import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/localization/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../controllers/auth_controller.dart';
import '../widgets/ios_error_banner.dart';

/// Apple iOS-styled Login and Sign-up screen.
/// Offers both Google OAuth and Email/Password flows with input validation.
class LoginScreen extends StatefulWidget {
  final AuthController authController;
  final AppStrings strings;

  const LoginScreen({
    super.key,
    required this.authController,
    this.strings = const AppStrings(),
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUpMode = false;

  Future<void> _submitEmailAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) return;

    if (_isSignUpMode) {
      await widget.authController.signUpWithPassword(
        email: email,
        password: password,
      );
    } else {
      await widget.authController.signInWithPassword(
        email: email,
        password: password,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final borderSubtle = isDark
        ? AppColors.darkBorderSubtle
        : AppColors.lightBorderSubtle;
    final accentColor = isDark ? AppColors.darkAccent : AppColors.lightAccent;
    final hoverColor = isDark ? AppColors.darkHover : AppColors.lightHover;

    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.authController,
          builder: (context, _) {
            final isLoading = widget.authController.isLoading;
            final errorMessage = widget.authController.errorMessage;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Brand Pill
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: hoverColor,
                            borderRadius: BorderRadius.circular(
                              AppGeometry.radiusFull,
                            ),
                            border: Border.all(color: borderSubtle),
                          ),
                          child: Text(
                            widget.strings.appTitle,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                              color: accentColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Title & Subtitle
                      Text(
                        _isSignUpMode
                            ? widget.strings.signUpTitle
                            : widget.strings.signInTitle,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                          color: textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isSignUpMode
                            ? widget.strings.signUpSubtitle
                            : widget.strings.signInSubtitle,
                        style: TextStyle(
                          fontSize: 15,
                          color: textSecondary,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),

                      // Error Banner
                      if (errorMessage != null)
                        IosErrorBanner(
                          message: errorMessage,
                          onDismiss: widget.authController.clearError,
                          strings: widget.strings,
                        ),

                      // Card with Auth Actions
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(
                            AppGeometry.radiusCard,
                          ),
                          border: Border.all(color: borderSubtle),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: isDark ? 0.3 : 0.04,
                              ),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Google OAuth Button
                            Semantics(
                              button: true,
                              label: widget.strings.continueWithGoogle,
                              child: CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: isLoading
                                    ? null
                                    : widget.authController.signInWithGoogle,
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.darkHover
                                        : AppColors.lightHover,
                                    borderRadius: BorderRadius.circular(
                                      AppGeometry.radiusMd,
                                    ),
                                    border: Border.all(color: borderSubtle),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Google 'G' Symbol representation
                                      Image.asset(
                                        'assets/images/google_icon_colored.png',
                                        width: 20,
                                        height: 20,
                                        fit: BoxFit.contain,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        widget.strings.continueWithGoogle,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Divider "or continue with email"
                            Row(
                              children: [
                                Expanded(child: Divider(color: borderSubtle)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    widget.strings.orContinueWithEmail,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: textSecondary,
                                    ),
                                  ),
                                ),
                                Expanded(child: Divider(color: borderSubtle)),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Email Field
                            Text(
                              widget.strings.emailLabel,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            CupertinoTextField(
                              controller: _emailController,
                              placeholder: widget.strings.emailPlaceholder,
                              keyboardType: TextInputType.emailAddress,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.darkHover
                                    : AppColors.lightHover,
                                borderRadius: BorderRadius.circular(
                                  AppGeometry.radiusSm,
                                ),
                                border: Border.all(color: borderSubtle),
                              ),
                              style: TextStyle(color: textPrimary),
                            ),
                            const SizedBox(height: 16),

                            // Password Field
                            Text(
                              widget.strings.passwordLabel,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            CupertinoTextField(
                              controller: _passwordController,
                              placeholder: widget.strings.passwordPlaceholder,
                              obscureText: true,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.darkHover
                                    : AppColors.lightHover,
                                borderRadius: BorderRadius.circular(
                                  AppGeometry.radiusSm,
                                ),
                                border: Border.all(color: borderSubtle),
                              ),
                              style: TextStyle(color: textPrimary),
                              onSubmitted: (_) => _submitEmailAuth(),
                            ),
                            const SizedBox(height: 22),

                            // Submit Button
                            Semantics(
                              button: true,
                              label: _isSignUpMode
                                  ? widget.strings.signUpButton
                                  : widget.strings.signInButton,
                              child: CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: isLoading ? null : _submitEmailAuth,
                                child: Container(
                                  height: 48,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: accentColor,
                                    borderRadius: BorderRadius.circular(
                                      AppGeometry.radiusMd,
                                    ),
                                  ),
                                  child: isLoading
                                      ? const CupertinoActivityIndicator(
                                          color: Colors.white,
                                        )
                                      : Text(
                                          _isSignUpMode
                                              ? widget.strings.signUpButton
                                              : widget.strings.signInButton,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Toggle Switch between Sign In and Sign Up
                      CupertinoButton(
                        onPressed: () {
                          setState(() {
                            _isSignUpMode = !_isSignUpMode;
                            widget.authController.clearError();
                          });
                        },
                        child: Text(
                          _isSignUpMode
                              ? widget.strings.switchToSignIn
                              : widget.strings.switchToSignUp,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
