import 'package:dropill_project/features/config/config_controller.dart';
import 'package:dropill_project/features/confirmation/confirmation_controller.dart';
import 'package:dropill_project/features/home/home_controller.dart';
import 'package:dropill_project/features/medication/medication_controller.dart';
import 'package:dropill_project/features/monitoring/monitoring_controller.dart';
import 'package:dropill_project/features/profile/profile_controller.dart';
import 'package:dropill_project/features/sign_in/sign_in_controller.dart';
import 'package:dropill_project/features/sign_up/sign_up_controller.dart';
import 'package:dropill_project/features/splash/splash_controller.dart';
import 'package:dropill_project/services/auth_service.dart';
import 'package:dropill_project/services/confirmation_service.dart';
import 'package:dropill_project/services/firebase_service.dart';
import 'package:dropill_project/services/medication_service.dart';
import 'package:dropill_project/services/profile_service.dart';
import 'package:dropill_project/services/secure_storage.dart';
import 'package:dropill_project/services/sympton_service.dart';
import 'package:dropill_project/services/user_service.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupDependencies() {
  locator.registerLazySingleton<SecureStorage>(() => const SecureStorage());

  locator.registerLazySingleton<FirebaseMessagingService>(
      () => FirebaseMessagingService(locator.get<SecureStorage>()));
  locator.registerLazySingleton<ConfirmationService>(
      () => ConfirmationService(locator.get<SecureStorage>()));
  locator.registerLazySingleton<UserService>(
      () => UserService(locator.get<SecureStorage>()));
  locator.registerLazySingleton<ProfileService>(
      () => ProfileService(locator.get<SecureStorage>()));
  locator.registerLazySingleton<MedicationService>(
      () => MedicationService(locator.get<SecureStorage>()));
  locator.registerLazySingleton<SymptomService>(() => SymptomService(locator.get<SecureStorage>()));

  locator.registerFactory<HomeController>(() => HomeController(
      locator.get<SecureStorage>(), locator.get<MedicationService>()));
  locator.registerFactory<MedicationController>(() => MedicationController(
      locator.get<MedicationService>(), locator.get<SecureStorage>()));
  locator.registerFactory<SplashController>(
      () => SplashController(locator.get<SecureStorage>()));
  locator.registerFactory<SignInController>(
      () => SignInController(locator.get<UserService>()));
  locator.registerFactory<SignUpController>(
      () => SignUpController(locator.get<UserService>()));
  locator.registerFactory<ProfileController>(() => ProfileController(
      locator.get<ProfileService>(), locator.get<SecureStorage>()));
  locator.registerFactory<ConfirmationController>(
      () => ConfirmationController(locator.get<ConfirmationService>()));
  locator.registerFactory<ConfigController>(
      () => ConfigController(locator.get<SecureStorage>()));

  locator.registerFactory<MonitoringController>(
      () => MonitoringController(locator.get<SymptomService>(), locator.get<SecureStorage>()));
}
