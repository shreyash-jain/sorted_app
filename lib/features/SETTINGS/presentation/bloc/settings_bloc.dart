import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/authentication/auth_native_data_source.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/database/cacheDataClass.dart';
import 'package:sorted/core/global/models/user_details.dart';
import 'package:sorted/features/ONSTART/domain/repositories/onstart_repository.dart';
import 'package:sorted/features/SETTINGS/data/models/settings_details.dart';
import 'package:sorted/features/SETTINGS/domain/repository/settings_repository.dart';
part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository settingsRepository;
  final OnStartRepository onstartRepository;

  SettingsBloc({this.settingsRepository, this.onstartRepository})
      : super(SettingsLoaded(
          settingsDetails: SettingsDetails.empty(),
          biometricState: false,
          userdetails: UserDetail(name:"shreyash",email: "shreyash")));
  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is LoadDetails) {
      Failure failure;
      SettingsDetails settingsDetails;
      bool biometricState = false;

      yield SettingsLoaded(
          settingsDetails: SettingsDetails.empty(),
          biometricState: false,
          userdetails: UserDetail().copyWith(name: "", email: ""));
      var userDetails = CacheDataClass.cacheData.getUserDetail();
      var fOrbiometricState = await onstartRepository.getBiometricState();
      var fOrSettingsDetails = await settingsRepository.settingsDetail;
      fOrbiometricState.fold((l) {
        failure = l;
      }, (r) {
        biometricState = r;
      });
      fOrSettingsDetails.fold((l) {
        failure = l;
        print(l.toString());
      }, (r) {
        print(r.toString());
        settingsDetails = r;
      });
      if (failure != null) {
        print("error");
        print(failure.toString());
        UserDetail(name:"shreyash",email: "shreyash");
      } else {
        yield SettingsLoaded(
            biometricState: biometricState,
            settingsDetails: settingsDetails,
            userdetails: userDetails);
      }
    } else if (event is UpdateDetails) {
      settingsRepository.updateSettingsDetails(event.details);
      yield SettingsLoaded(
          biometricState: (state as SettingsLoaded).biometricState,
          settingsDetails: event.details,
          userdetails: (state as SettingsLoaded).userdetails);
    } else if (event is UpdateBiometricState) {
       onstartRepository.setBiometricState(event.state);
      yield SettingsLoaded(
          biometricState: event.state,
          settingsDetails: (state as SettingsLoaded).settingsDetails,
          userdetails: (state as SettingsLoaded).userdetails);
    }
  }
}
