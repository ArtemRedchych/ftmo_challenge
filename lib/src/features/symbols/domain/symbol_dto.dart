import 'package:ftmo/src/constants/enums.dart';

class SymbolDto {
  final String id;
  final String symbolsId;
  final String assetClass;
  final String symbol;
  final double? open;
  final double? close;
  final double? bidPrice;
  final double? askPrice;
  final double commission;
  final double? spread;
  final PriceMovementType? bidPriceMovement;
  final PriceMovementType? askPriceMovement;
  final PriceMovementType? spreadPriceMovement;

  SymbolDto({
    this.bidPrice,
    this.open,
    this.close,
    this.askPrice,
    this.spread,
    this.bidPriceMovement,
    this.askPriceMovement,
    this.spreadPriceMovement,
    required this.id,
    required this.symbolsId,
    required this.assetClass,
    required this.symbol,
    required this.commission,
  });

  factory SymbolDto.fromJson(Map<String, dynamic> json) {
    return SymbolDto(
      id: json['id'],
      symbolsId: json['symbols_id'],
      assetClass: _getAssetClassName(json['asset_class']),
      symbol: json['symbol'],
      commission: double.parse(json['commission']),
      bidPriceMovement: PriceMovementType.none,
      askPriceMovement: PriceMovementType.none,
      spreadPriceMovement: PriceMovementType.none,
    );
  }

  SymbolDto copyWith({
    double? bidPrice,
    double? askPrice,
    double? spread,
    PriceMovementType? bidPriceMovement,
    PriceMovementType? askPriceMovement,
    PriceMovementType? spreadPriceMovement,
  }) {
    return SymbolDto(
      id: id,
      symbolsId: symbolsId,
      assetClass: assetClass,
      symbol: symbol,
      commission: commission,
      bidPrice: bidPrice ?? this.bidPrice,
      askPrice: askPrice ?? this.askPrice,
      spread: spread ?? this.spread,
      bidPriceMovement: bidPriceMovement ?? this.bidPriceMovement,
      askPriceMovement: askPriceMovement ?? this.askPriceMovement,
      spreadPriceMovement: spreadPriceMovement ?? this.spreadPriceMovement,
    );
  }

  static String _getAssetClassName(String assetClass) {
    switch (assetClass) {
      case 'Forex':
        return 'Forex';
      case 'Cash CFD':
        return 'Commodities';
      case 'Equities CFD':
        return 'Indices';
      case 'Crypto CFD':
        return 'Crypto';
      case 'Metals CFD':
        return 'Metals';
      case 'Exotics':
        return 'Exotics';
      default:
        return 'Unknown';
    }
  }
}
