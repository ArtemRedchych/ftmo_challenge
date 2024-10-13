import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ftmo/src/constants/constants.dart';
import 'package:ftmo/src/features/symbols/domain/symbol_dto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SymbolsRepository {
  final String symbolsUrl;

  SymbolsRepository({required this.symbolsUrl});

  Future<Map<String, List<SymbolDto>> > fetchSymbols() async {
    final response = await http.get(Uri.parse(symbolsUrl));

    final data = json.decode(response.body);

    if (response.statusCode != 200) {
      throw Exception('Failed to load symbols.json');
    }
    if (data['symbols'] == null) {
      throw Exception('Failed to load symbols.json');
    }

    List<SymbolDto> symbols =
        List<SymbolDto>.from(data['symbols'].map((x) => SymbolDto.fromJson(x)));
    return groupSymbolsByAssetClass(symbols);
  }

  //function that groups symbols by asset class and return a map of asset class and symbols
  Map<String, List<SymbolDto>> groupSymbolsByAssetClass(List<SymbolDto> symbols) {
    Map<String, List<SymbolDto>> groupedSymbols = {};

    for (var symbol in symbols) {
      if (groupedSymbols.containsKey(symbol.assetClass)) {
        groupedSymbols[symbol.assetClass]!.add(symbol);
      } else {
        groupedSymbols[symbol.assetClass] = [symbol];
      }
    }

    return groupedSymbols;
  }
}

// Provider for SymbolsRepository
final symbolsRepositoryProvider = AutoDisposeProvider<SymbolsRepository>((ref) {
  return SymbolsRepository(
    symbolsUrl: basicSymbolsUrl,
  );
});
