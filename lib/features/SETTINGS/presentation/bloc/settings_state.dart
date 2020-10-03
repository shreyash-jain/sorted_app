part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
}



class SettingsLoaded extends SettingsState {
  final SettingsDetails settingsDetails;
  final bool biometricState;
  final UserDetail userdetails;

  SettingsLoaded({this.settingsDetails, this.biometricState,this.userdetails});
  @override
  List<Object> get props => [settingsDetails, biometricState, userdetails];
}

