import 'package:flutter_triple/flutter_triple.dart';

import '../../../../models/colaborador_model.dart';

class FinanceiroStore extends Store<int> {
  List<ColaboradorModel> colaboradores = [];

  FinanceiroStore() : super(0);
}
