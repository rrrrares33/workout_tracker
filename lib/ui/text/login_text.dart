import 'package:flutter/material.dart';

// Common texts
const String emailEnterHere = 'Enter your email here..';
const String emailNotValid = 'Email is not valid';
const String emailLabel = 'Email..';
const String passwordLabel = 'Password..';
const String logInButtonLabel = 'Log In with email and password';
const String createANewAccount = 'Register a new local account';

// Forgotten password text
const SnackBar recoveryEmailSent = SnackBar(content: Text('Recovery email is on the way!'));
const String emailRecoveryButton = 'Send email to reset password';

// Login email and password
const SnackBar loggedInSuccess = SnackBar(content: Text('You have successfully logged in!'));
const String logInYourAccountAppBar = 'Log into your account';
const String accountDoesNotExist = 'This account does not exist';
const String didYouForgetPass = 'Did you forget your password? Tap here';

// Login page
const SnackBar loggedSuccessful = SnackBar(content: Text('You have successfully logged in!'));
const String alreadyAccountLogIn = 'You already have an account? Log In!';
const String logInWithOtherServices = 'Do you want to log in using other services?';
const String logInWithGoogle = 'Sign In with a Google account';
const String logInWithFacebook = 'Sign In with a Facebook account';
const String createANewAccountQuestion = 'Do you want to create a new account?';

// Register page
const SnackBar registerComplete = SnackBar(content: Text('You have successfully created a new account!'));
const SnackBar registerFailed = SnackBar(content: Text('Register failed: email already used!'));
const String registerAccountAppBar = 'Create a new account';
const String confirmPasswordLabel = 'Confirm password...';
const String passwordsDoNotMatch = 'The passwords do not match';
const String emailAlreadyInUse = 'This email is already in use';
const String passwordNotSecureEnough = 'The password is not secure enough';
const String passwordCapitalChecker = '  At least one upper case letter (ex: ABC)';
const String passwordLowerChecker = '  At least one lower case letter (ex: abc)';
const String passwordNumberChecker = '  At least one numbers (ex: 523)';
const String passwordSymbolChecker = '  At least one numbers (ex: 523)';
