part of 'payments_bloc.dart';
abstract class PaymentsState extends Equatable {
  const PaymentsState();
}
class PaymentsInitial extends PaymentsState {
  @override
  List<Object> get props => [];
}
