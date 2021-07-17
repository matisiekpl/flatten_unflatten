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
}
