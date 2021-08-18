import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:my_camera_app_demo/cores/failures/failure.dart';
import 'package:my_camera_app_demo/cores/localize/app_localize.dart';
import 'package:my_camera_app_demo/features/account/domain/entities/account.dart';
import 'package:my_camera_app_demo/features/account/domain/usecases/add_account.dart';
import 'package:my_camera_app_demo/features/account/domain/usecases/get_list_account.dart';
import 'package:my_camera_app_demo/features/account/domain/usecases/modify_account.dart';
import 'package:my_camera_app_demo/features/account/domain/usecases/param.dart';
import 'package:my_camera_app_demo/features/account/domain/usecases/remove_account.dart';
part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final GetListAccountUsecase getListAccountUsecase;
  final AddAccountUsecase addAccountUsecase;
  final ModifyAccountUsecase modifyAccountUsecase;
  final RemoveAccountUsecase removeAccountUsecase;
  AccountBloc({
    @required this.getListAccountUsecase,
    @required this.addAccountUsecase,
    @required this.modifyAccountUsecase,
    @required this.removeAccountUsecase,
  }) : super(LoadingAccount());

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    if (event is LoadAccountEvent) {
      final result = await getListAccountUsecase(
        GetListAccountParams(jwt: event.jwt),
      );
      yield result.fold(
        (failure) => ErrorLoadingAccount(),
        (accounts) => LoadedAccount(accounts: accounts),
      );
    } else if (event is CreateAccountEvent) {
      yield CreatingAccount();
      final result = await addAccountUsecase(AddAccountParams(
        jwt: event.jwt,
        username: event.username,
        password: event.password,
        admin: event.admin,
      ));
      yield result.fold((Failure failure) {
        CreateAccountFailure error = failure;
        String message;

        if (error.statusCode == 409)
          message = event.localizations.translate('sameAccountError');
        else
          message = event.localizations.translate('serverError');
        return ErrorCreateAccount(message: message);
      }, (account) => SuccessCreateAccount(account: account));
    } else if (event is ModifyAccountEvent) {
      yield ModifyingAccount();
      final result = await modifyAccountUsecase(ModifyAccountParams(
        jwt: event.jwt,
        id: event.id,
        username: event.username,
        admin: event.admin,
      ));
      yield result.fold((Failure failure) {
        ModifyAccountFailure error = failure;
        String message;

        if (error.statusCode == 409)
          message = event.localizations.translate('sameAccountError');
        else if (error.statusCode == 400)
          message = event.localizations.translate('requireError');
        else if (error.statusCode == 401)
          message = event.localizations.translate('perrmissionError');
        else if (error.statusCode == 404)
          message = event.localizations.translate('notFoundError');
        else
          message = event.localizations.translate('serverError');
        return ErrorModifyAccount(message: message);
      }, (account) => SuccessModifyAccount(account: account));
    } else if (event is RemoveAccountEvent) {
      LoadedAccount currentState = state;
      yield RemovingAccount(accounts: currentState.accounts);
      final result = await removeAccountUsecase(RemoveAccountParams(
        jwt: event.jwt,
        id: event.id,
      ));
      yield* result.fold((Failure failure) async* {
        RemoveAccountFailure error = failure;
        String message;

        if (error.statusCode == 409)
          message = event.localizations.translate('deleteDependenceError');
        else if (error.statusCode == 400)
          message = event.localizations.translate('requireError');
        else if (error.statusCode == 401)
          message = event.localizations.translate('perrmissionError');
        else if (error.statusCode == 404)
          message = event.localizations.translate('notFoundError');
        else
          message = event.localizations.translate('serverError');
        yield ErrorRemoveAccount(
          message: message,
          accounts: currentState.accounts,
        );
      }, (account) async* {
        final getAccountListResult = await getListAccountUsecase(
          GetListAccountParams(jwt: event.jwt),
        );
        yield getAccountListResult.fold(
          (failure) => ErrorRemoveAccount(
            message: event.localizations.translate('serverError'),
            accounts: currentState.accounts,
          ),
          (accounts) => SuccessRemoveAccount(
            account: account,
            accounts: accounts,
          ),
        );
      });
    }
  }
}
