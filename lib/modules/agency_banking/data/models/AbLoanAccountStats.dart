import 'package:decimal/decimal.dart';

class AbLoanAccountStats {
  String? _compname;
  Decimal? _expected;
  Decimal? _overdue;
  Decimal? _outstanding;
  Decimal? _advance;
  String? _compccy;

  AbLoanAccountStats({
    String? compname,
    Decimal? expected,
    Decimal? overdue,
    Decimal? outstanding,
    Decimal? advance,
    String? compccy,
  })  : _compname = compname,
        _expected = expected,
        _overdue = overdue,
        _outstanding = outstanding,
        _advance = advance,
        _compccy = compccy;

  // Getters
  String? get compname => _compname;
  Decimal? get expected => _expected;
  Decimal? get overdue => _overdue;
  Decimal? get outstanding => _outstanding;
  Decimal? get advance => _advance;
  String? get compccy => _compccy;

  // Setters
  set compname(String? value) => _compname = value;
  set expected(Decimal? value) => _expected = value;
  set overdue(Decimal? value) => _overdue = value;
  set outstanding(Decimal? value) => _outstanding = value;
  set advance(Decimal? value) => _advance = value;
  set compccy(String? value) => _compccy = value;

  // fromJson factory constructor
  factory AbLoanAccountStats.fromJson(Map<String, dynamic> json) {
    return AbLoanAccountStats(
      compname: json['compname'],
      expected: json['expected'] != null ? Decimal.parse(json['expected'].toString()) : null,
      overdue: json['overdue'] != null ? Decimal.parse(json['overdue'].toString()) : null,
      outstanding: json['outstanding'] != null ? Decimal.parse(json['outstanding'].toString()) : null,
      advance: json['advance'] != null ? Decimal.parse(json['advance'].toString()) : null,
      compccy: json['compccy'],
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'compname': _compname,
      'expected': _expected?.toString(),
      'overdue': _overdue?.toString(),
      'outstanding': _outstanding?.toString(),
      'advance': _advance?.toString(),
      'compccy': _compccy,
    };
  }
}