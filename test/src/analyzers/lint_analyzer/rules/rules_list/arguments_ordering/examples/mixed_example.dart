A? create(String a, String b, {required String c, String? d}) => null;

final good1 = create('a', 'b', c: 'c', d: 'd');
final good2 = create('a', 'b', c: 'c');

final bad1 = create('a', c: 'c', 'b', d: 'd'); // LINT
final bad2 = create('a', d: 'd', 'b', c: 'c'); // LINT
final bad3 = create('a', 'b', d: 'd', c: 'c'); // LINT
final bad4 = create('a', c: 'c', 'b'); // LINT
final bad5 = create(c: 'c', 'a', 'b'); // LINT
