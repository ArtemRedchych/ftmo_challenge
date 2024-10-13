import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ftmo/src/constants/enums.dart';
import 'package:ftmo/src/features/symbols/application/websocket_service.dart';
import 'package:ftmo/src/features/symbols/domain/symbols_state.dart';
import 'package:ftmo/src/features/symbols/domain/symbol_dto.dart';
import 'package:ftmo/src/features/symbols/data/basic_symbols_repository.dart';
import 'package:ftmo/src/features/symbols/providers/selected_class_provider.dart';
import 'package:ftmo/src/features/symbols/providers/websocket_provider.dart';

class BasicSymbolsNotifier extends StateNotifier<AsyncValue<SymbolsState>> {
  BasicSymbolsNotifier(this.ref, this.repository, this.websocketService)
      : super(const AsyncLoading()) {
    _fetchSymbols();
  }

  final Ref ref;
  final SymbolsRepository repository;
  final WebsocketService websocketService;

  String _currentAssetClass = '';
  Set<String> _currentSymbols = {};

  Future<void> _fetchSymbols() async {
    try {
      final symbols = await repository.fetchSymbols();

      // Extract unique asset classes
      final assetClasses = symbols.keys.toList();

      // Create the SymbolsState
      final symbolsState =
          SymbolsState(symbols: symbols, assetClasses: assetClasses);

      state = AsyncValue.data(symbolsState);

      // Get the initial selected asset class
      _currentAssetClass = ref.read(selectedAssetClassProvider);

      // Subscribe to initial asset class symbols
      if (_currentAssetClass.isNotEmpty) {
        _subscribeToAssetClassSymbols(_currentAssetClass);
      }

      // Start listening to websocket messages
      _listenToWebsocket();

      // Listen to changes in selectedAssetClassProvider
      ref.listen<String>(selectedAssetClassProvider, (previous, next) {
        _onAssetClassChanged(previous, next);
      });
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void _onAssetClassChanged(String? previous, String next) {
    // Unsubscribe from previous symbols
    if (previous != null && previous.isNotEmpty) {
      _unsubscribeFromAssetClassSymbols(previous);
    }

    // Update current asset class
    _currentAssetClass = next;

    // Subscribe to new symbols
    if (next.isNotEmpty) {
      _subscribeToAssetClassSymbols(next);
    }
  }

  void _subscribeToAssetClassSymbols(String assetClass) {
    final symbolsState = state;
    if (symbolsState is AsyncData<SymbolsState>) {
      final symbols = symbolsState.value.symbols[assetClass];
      if (symbols != null && symbols.isNotEmpty) {
        final symbolsToSubscribe = symbols
            .map((s) => {'symbol': s.symbol, 'source': 'ctrader'})
            .toList();

        final message = {
          'eventType': 'wsTickStreamAddSymbols',
          'payload': {
            'symbols': symbolsToSubscribe,
          },
        };

        // Send the message via websocket
        websocketService.send(json.encode(message));

        // Update current symbols
        _currentSymbols = symbols.map((s) => s.symbol).toSet();
      }
    }
  }

  void _unsubscribeFromAssetClassSymbols(String assetClass) {
    final symbolsState = state;
    if (symbolsState is AsyncData<SymbolsState>) {
      final symbols = symbolsState.value.symbols[assetClass];
      if (symbols != null && symbols.isNotEmpty) {
        final symbolsToUnsubscribe = symbols
            .map((s) => {'symbol': s.symbol, 'source': 'ctrader'})
            .toList();

        final message = {
          'eventType': 'wsTickStreamRemoveSymbols',
          'payload': {
            'symbols': symbolsToUnsubscribe,
          },
        };

        // Send the message via websocket
        websocketService.send(json.encode(message));

        // Remove symbols from current symbols
        _currentSymbols.removeAll(symbols.map((s) => s.symbol));
      }
    }
  }

  void _listenToWebsocket() {
    websocketService.stream.listen((message) {
      // Parse the message and handle updates
      final data = json.decode(message);
      final eventType = data['eventType'];

      if (eventType == 'symbolTick') {
        final payload = data['payload'];
        final symbolName = payload['symbol'];
        if (payload['bid'] != null && payload['ask'] != null) {
          final bidPrice = (payload['bid'] as num).toDouble();
          final askPrice = (payload['ask'] as num).toDouble();

          // Update the symbol in the state
          _updateSymbolPrices(symbolName, bidPrice, askPrice);
        }
      }
    }, onError: (error) {
      // Handle i would handle websocket errors if necessary
    });
  }

  void _updateSymbolPrices(String symbolName, double bid, double ask) {
    final currentState = state;
    if (currentState is AsyncData<SymbolsState>) {
      final symbolsState = currentState.value;

      // Find the asset class for the symbol
      String? assetClass;
      for (var entry in symbolsState.symbols.entries) {
        if (entry.value.any((s) => s.symbol == symbolName)) {
          assetClass = entry.key;
          break;
        }
      }

      if (assetClass != null) {
        final symbolsList = symbolsState.symbols[assetClass]!;
        final index = symbolsList.indexWhere((s) => s.symbol == symbolName);
        if (index != -1) {
          // Update the symbol
          final oldSymbol = symbolsList[index];
          double spread = ask - bid;

          PriceMovementType bidPriceMovement = PriceMovementType.none;

          if (oldSymbol.bidPrice != null) {
            bidPriceMovement = bid > oldSymbol.bidPrice!
                ? PriceMovementType.up
                : PriceMovementType.down;
          }

          PriceMovementType askPriceMovement = PriceMovementType.none;

          if (oldSymbol.askPrice != null) {
            askPriceMovement = bid > oldSymbol.askPrice!
                ? PriceMovementType.up
                : PriceMovementType.down;
          }
          PriceMovementType spreadPriceMovement = PriceMovementType.none;
          if (oldSymbol.spread != null) {
            spreadPriceMovement = bid > oldSymbol.spread!
                ? PriceMovementType.up
                : PriceMovementType.down;
          }

          final updatedSymbol = oldSymbol.copyWith(
            bidPrice: bid,
            askPrice: ask,
            spread: spread,
            bidPriceMovement: bidPriceMovement,
            askPriceMovement: askPriceMovement,
            spreadPriceMovement: spreadPriceMovement,
          );

          // Create a new symbols list
          final updatedSymbolsList = List<SymbolDto>.from(symbolsList);
          updatedSymbolsList[index] = updatedSymbol;

          // Create a new symbols map
          final updatedSymbolsMap =
              Map<String, List<SymbolDto>>.from(symbolsState.symbols);
          updatedSymbolsMap[assetClass] = updatedSymbolsList;

          // Update the state
          final updatedSymbolsState = SymbolsState(
            symbols: updatedSymbolsMap,
            assetClasses: symbolsState.assetClasses,
          );

          state = AsyncData(updatedSymbolsState);
        }
      }
    }
  }

  @override
  void dispose() {
    websocketService.close();
    super.dispose();
  }
}

final symbolsProvider =
    AutoDisposeStateNotifierProvider<BasicSymbolsNotifier, AsyncValue<SymbolsState>>(
        (ref) {
  final repository = ref.read(symbolsRepositoryProvider);
  final websocketService = ref.read(websocketServiceProvider);
  return BasicSymbolsNotifier(ref, repository, websocketService);
});
