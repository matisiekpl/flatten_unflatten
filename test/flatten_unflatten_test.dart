import 'package:test/test.dart';

import 'package:flatten_unflatten/flatten_unflatten.dart';

void main() {
  group('unflat', () {
    test('unflat property only nested object', () {
      final obj = Flatten();
      expect(
          obj.unflat({'a.b.c.d': 'x'}),
          equals({
            'a': {
              'b': {
                'c': {'d': 'x'}
              }
            }
          }));
    });

    test('unflat object with list in the middle', () {
      final obj = Flatten();
      expect(
          obj.unflat({'a.b[0].c.d': 'x'}),
          equals({
            'a': {
              'b': [
                {
                  'c': {'d': 'x'}
                }
              ]
            }
          }));
    });

    test('unflat object with list at the beginning', () {
      final obj = Flatten();
      expect(
          obj.unflat({'[0].a.b.c.d': 'x'}),
          equals([
            {
              'a': {
                'b': {
                  'c': {'d': 'x'}
                }
              }
            }
          ]));
    });

    test('unflat object with list at the starting property', () {
      final obj = Flatten();
      expect(
          obj.unflat({'a[0].b.c.d': 'x'}),
          equals({
            'a': [
              {
                'b': {
                  'c': {'d': 'x'}
                }
              }
            ]
          }));
    });

    test('unflat object with list in the end', () {
      final obj = Flatten();
      expect(
          obj.unflat({'a.b.c.d[0]': 'x'}),
          equals({
            'a': {
              'b': {
                'c': {
                  'd': ['x']
                }
              }
            }
          }));
    });

    test('unflat property-only complex input', () {
      final obj = Flatten();
      expect(
          obj.unflat({'a.b.c.d': 'x', 'a.b.e.f': 'y'}),
          equals({
            'a': {
              'b': {
                'c': {'d': 'x'},
                'e': {'f': 'y'}
              }
            }
          }));
    });

    test('unflat mixed complex input', () {
      final obj = Flatten();
      expect(
          obj.unflat({'a.b.c.d': 'x', 'a.b.e[1].f': 'y'}),
          equals({
            'a': {
              'b': {
                'c': {'d': 'x'},
                'e': [
                  {},
                  {'f': 'y'}
                ]
              }
            }
          }));
    });

    test('unflat with overriding', () {
      final obj = Flatten();
      expect(
          obj.unflat({'a.b.c.d': 'x', 'a.b.c': 'y'}),
          equals({
            'a': {
              'b': {'c': 'y'}
            }
          }));
    });
  });

  group('flat', () {
    test('flat simple object', () {
      final obj = Flatten();
      expect(
          obj.flat({
            'a': {
              'b': {'c': 'x'}
            }
          }),
          equals({'a.b.c': 'x'}));
    });

    test('flat simple object with nested list', () {
      final obj = Flatten();
      expect(
          obj.flat({
            'a': {
              'b': [11, 17]
            }
          }),
          equals({'a.b[0]': 11, 'a.b[1]': 17}));
    });

    test('flat list as the entrypoint', () {
      final obj = Flatten();
      expect(
          obj.flat([
            {
              'a': {
                'b': [11, 17]
              }
            }
          ]),
          equals({'[0].a.b[0]': 11, '[0].a.b[1]': 17}));
    });

    test('flat object with nested lists placed close to each other', () {
      final obj = Flatten();
      expect(
          obj.flat([
            {
              'a': {
                'b': [
                  [12, 13],
                  17
                ]
              }
            }
          ]),
          equals({'[0].a.b[0][0]': 12, '[0].a.b[0][1]': 13, '[0].a.b[1]': 17}));
    });
  });
}
