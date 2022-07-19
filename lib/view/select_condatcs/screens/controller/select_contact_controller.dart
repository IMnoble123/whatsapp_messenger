//we does not need an repository here because we craeate an future in repository
//so its an fluture value so we can use future provider

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappmessenger/view/select_condatcs/repositores/select_condact.dart';

final getContactsProvider = FutureProvider(
  (ref) {
    final selectContactRepository = ref.watch(selectContactsRepositoryProvider);
    return selectContactRepository.getContacts();
  },
);
