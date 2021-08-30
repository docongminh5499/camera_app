part of 'account_bloc.dart';

@immutable
abstract class AccountState extends Equatable {
  @override
  List<Object> get props => <dynamic>[];
}

class LoadingAccount extends AccountState {}

class LoadedAccount extends AccountState {
  final List<Account> accounts;
  LoadedAccount({@required this.accounts});
  @override
  List<Object> get props => <dynamic>[accounts];
}

class ErrorLoadingAccount extends AccountState {}

class ErrorCreateAccount extends AccountState {
  final String message;
  ErrorCreateAccount({@required this.message});
  @override
  List<Object> get props => <dynamic>[message];
}

class SuccessCreateAccount extends AccountState {
  final Account account;
  SuccessCreateAccount({@required this.account});
  @override
  List<Object> get props => <dynamic>[account];
}

class CreatingAccount extends AccountState {}

class ErrorModifyAccount extends AccountState {
  final String message;
  ErrorModifyAccount({@required this.message});
  @override
  List<Object> get props => <dynamic>[message];
}

class SuccessModifyAccount extends AccountState {
  final Account account;
  SuccessModifyAccount({@required this.account});
  @override
  List<Object> get props => <dynamic>[account];
}

class ModifyingAccount extends AccountState {}

class ErrorRemoveAccount extends LoadedAccount {
  final String message;
  ErrorRemoveAccount({
    @required this.message,
    @required accounts,
  }) : super(accounts: accounts);
  @override
  List<Object> get props => <dynamic>[message, accounts];
}

class SuccessRemoveAccount extends LoadedAccount {
  final Account account;
  SuccessRemoveAccount({
    @required this.account,
    @required accounts,
  }) : super(accounts: accounts);
  @override
  List<Object> get props => <dynamic>[account, accounts];
}

class RemovingAccount extends LoadedAccount {
  RemovingAccount({@required accounts}) : super(accounts: accounts);
  @override
  List<Object> get props => <dynamic>[accounts];
}
