import 'package:dropill_project/common/models/profile_model.dart';

abstract class ProfileState {}

class ProfileStateInitial extends ProfileState {}

class ProfileStateLoading extends ProfileState {}

class ProfileStateSuccess extends ProfileState {}

class ProfileStateSuccess2 extends ProfileState {
  final List<ProfileModel> profiles;

  ProfileStateSuccess2(this.profiles);
}

class ProfileStateError extends ProfileState {}


class ProfileStateEditLoading extends ProfileState {}

class ProfileStateEditSuccess extends ProfileState {}

class ProfileStateEditError extends ProfileState {}
