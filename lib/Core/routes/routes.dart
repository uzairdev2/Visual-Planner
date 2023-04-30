import 'package:get/get.dart';
import 'package:visual_planner/Features/Receive%20Invitation%20Screen/receive_invitation_screen.dart';

import '../../Features/Add Project Screen/add_project_screen.dart';
import '../../Features/Add Sprint Screen/add_sprint_screen.dart';
import '../../Features/Calendar Screen/calendar_screen.dart';
import '../../Features/Dashboard Screen/dashboard_screen.dart';
import '../../Features/ForgotPassword Screen/forgot_password_screen.dart';
import '../../Features/Profile Screen/profile_screen.dart';
import '../../Features/Project List Screen/project_list_screen.dart';
import '../../Features/Sprint List Screen/sprintlistScreen.dart';
import '../../Features/Welcome Screen/welcome_screen.dart';
import '../../Features/Login Screen/login_screen.dart';
import '../../Features/SignUp Screen/signUp_screen.dart';
import '../../Features/Splash Screen/splash_screen.dart';
import '../../Features/onBoarding Screens/onBoarding_Screens.dart';

class Routes {
  //splash screen
  static const splashScreen = '/splashScreen';
  //onBoardingScreens
  static const onBoardingOne = '/onBoardingOne';
  //homeScreen login, signUp
  static const welcomeScreen = '/welcomeScreen';
  //auth screens
  static const login = '/login';
  static const signUp = '/signUp';
  static const forgotPassword = '/forgotPassword';
  static const dashboard = '/dashboardScreen';
  static const addProject = '/AddProjectScreen';
  static const CreateSprint = '/CreateSprintScreen';
  static const Profile = '/ProfileScreen';
  static const ProjectList = '/ProjectListScreen';
  static const Calendar = '/CalendarScreen';
  static const SprintList = '/SprintListScreen';
  static const ReceiveInvitation = '/ReceiveInvitationScreen';

  static final List<GetPage> getPages = [
    GetPage(name: splashScreen, page: () => const SplashScreen()), //onboarding
    GetPage(name: onBoardingOne, page: () => onBoarding()),
    GetPage(name: welcomeScreen, page: () => const WelcomeScreen()),
    GetPage(name: signUp, page: () => SignUp()),
    GetPage(name: login, page: () => Login()),
    GetPage(name: forgotPassword, page: () => ForgotPassword()),
    GetPage(name: dashboard, page: () => DashboardScreen()),
    GetPage(name: Calendar, page: () => CalendarScreen()),
    GetPage(name: addProject, page: () => const AddProjectScreen()),
    GetPage(name: CreateSprint, page: () => const CreateSprintScreen()),

    GetPage(name: Profile, page: () => const ProfileScreen()),
    GetPage(name: ProjectList, page: () => const ProjectListScreen()),
    GetPage(name: SprintList, page: () => const SprintListScreen()),
    GetPage(name: ReceiveInvitation, page: () => ReceiveInvitationScreen()),
  ];
}
