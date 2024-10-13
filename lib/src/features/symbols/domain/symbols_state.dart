import 'package:ftmo/src/features/symbols/domain/symbol_dto.dart';

class SymbolsState {
  final Map<String, List<SymbolDto>>  symbols;
  final List<String> assetClasses;

  SymbolsState({required this.symbols, required this.assetClasses});
}