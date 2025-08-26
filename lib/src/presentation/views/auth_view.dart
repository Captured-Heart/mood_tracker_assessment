// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mood_tracker_assessment/constants/app_images.dart';
import 'package:mood_tracker_assessment/constants/button_state.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';
import 'package:mood_tracker_assessment/constants/nav_routes.dart';
import 'package:mood_tracker_assessment/constants/spacings.dart';
import 'package:mood_tracker_assessment/constants/text_constants.dart';
import 'package:mood_tracker_assessment/src/data/controller/auth_controller.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/buttons/primary_button.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/textfield/app_textfield.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/texts/texts_widget.dart';
import 'package:mood_tracker_assessment/utils/validations.dart';

class AuthView extends ConsumerWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authCtrl = ref.read(authProvider.notifier);
    final authState = ref.watch(authProvider);
    final isLoginView = authState.isLogin;

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        // Show error message
        context.showSnackBar(message: next.errorMessage!, isError: true);
        authCtrl.resetErrorMessage();
      }
      if (next.isAuthenticated) {
        context.showSnackBar(message: TextConstants.authenticationSuccessful.tr(), isError: false);
        context.pushNamed(NavRoutes.homeRoute);
      }
    });

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(AppImages.loginBackground.pngPath, fit: BoxFit.cover),
          ),

          //bottomsheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacings.k20, vertical: AppSpacings.k28),
              decoration: BoxDecoration(
                color: context.theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSpacings.k20),
                  topRight: Radius.circular(AppSpacings.k20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // BODY
                  Form(
                    key: authCtrl.loginFormKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      spacing: 20,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Hero(
                              tag: AppImages.appLogo.pngPath,
                              child: Image.asset(
                                    AppImages.appLogo.pngPath,
                                    width: context.deviceWidth(0.5),
                                    height: 100,
                                  )
                                  .padSymmetric(vertical: AppSpacings.k4)
                                  .shakeExtension(delay: 10.ms, animationDuration: 600.ms),
                            ),

                            MoodText.text(
                              text:
                                  '${isLoginView ? TextConstants.login.tr() : TextConstants.welcome.tr()} to Mood Tracker',
                              context: context,
                              textStyle: context.textTheme.titleLarge,
                            ),
                          ],
                        ),

                        // enter your full name
                        if (!isLoginView)
                          MoodTextfield(
                            filled: true,
                            hintText: TextConstants.enterYourFullName.tr(),
                            controller: authCtrl.nameController,
                            keyboardType: TextInputType.name,
                            inputFormatters: [],
                            validator: (p0) => AppValidations.validatedName(p0),
                          ),

                        //enter your email address
                        MoodTextfield(
                          filled: true,
                          hintText: TextConstants.enterYourEmailAddress.tr(),
                          controller: authCtrl.emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (p0) => AppValidations.validatedEmail(p0),
                        ),

                        //enter password
                        MoodTextfield(
                          filled: true,
                          hintText: TextConstants.password.tr(),
                          controller: authCtrl.passwordController,
                          validator: (p0) => AppValidations.validatePassword(p0),
                          obscureText: authState.hidePassword,
                          suffixIcon: SizedBox(
                            height: AppSpacings.k12,
                            width: AppSpacings.k12,
                            child: Center(
                              child: Icon(authState.hidePassword ? Icons.visibility : Icons.visibility_off),
                            ),
                          ).onTap(
                            onTap: () {
                              authCtrl.hideShowPassword();
                            },
                            tooltip: authState.hidePassword ? TextConstants.show.tr() : TextConstants.hide.tr(),
                          ),
                        ),
                        // sign up / login button
                        MoodPrimaryButton(
                          state: authState.isLoading ? ButtonState.loading : ButtonState.loaded,
                          onPressed: () {
                            // context.pushNamed(NavRoutes.homeRoute);
                            if (authCtrl.loginFormKey.currentState!.validate()) {
                              if (isLoginView) {
                                authCtrl.signInWithEmailAndPassword();
                              } else {
                                authCtrl.createUserWithEmailAndPassword();
                              }
                            }
                          },
                          title: isLoginView ? TextConstants.login.tr() : TextConstants.signUp.tr(),
                        ),

                        // already have an account
                        Row(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: MoodText.text(
                                context: context,
                                text:
                                    !isLoginView
                                        ? TextConstants.alreadyHaveAccount.tr()
                                        : TextConstants.dontHaveAccount.tr(),
                                textStyle: context.textTheme.bodyLarge,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            MoodText.text(
                              context: context,
                              text: !isLoginView ? TextConstants.login.tr() : TextConstants.signUp.tr(),
                              textStyle: context.textTheme.bodyLarge,
                              color: context.theme.primaryColor,
                              fontWeight: FontWeight.w700,
                            ).onTap(
                              onTap: () {
                                authCtrl.toggleLoginState();
                              },
                              tooltip: !isLoginView ? TextConstants.login.tr() : TextConstants.signUp.tr(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
