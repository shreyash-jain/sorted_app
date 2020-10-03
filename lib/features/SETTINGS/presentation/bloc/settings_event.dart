part of 'settings_bloc.dart';
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}
class UpdateDetails extends SettingsEvent{
  final SettingsDetails details;
  
  UpdateDetails(this.details);
  @override
  List<Object> get props => [details];
}
class LoadDetails extends SettingsEvent{
 
  @override
  List<Object> get props => [];
}

class UpdateBiometricState extends SettingsEvent{
  final bool state;
  UpdateBiometricState(this.state);

  @override
  List<Object> get props => [state];
}