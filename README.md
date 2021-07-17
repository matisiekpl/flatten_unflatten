flatten_unflatten is a zero-dependency flatten and unflatten implementations for maps and lists

![dart](https://github.com/matisiekpl/flatten_unflatten/actions/workflows/dart.yml/badge.svg)

## Usage

```dart
import 'package:flatten_unflatten/flatten_unflatten.dart';

void main() {
  final flattener = new Flatten();

  var flattened = flattener.flat({
    'a': {
      'b': {
        'c': ['hello', 'world']
      }
    }
  });
  print(flattened); // prints {a.b.c[0]: hello, a.b.c[1]: world}

  var unflattened = flattener.unflat({
    'a.b.c[0]': 'hello', 'a.b.c[1]': 'world',
  });
  print(unflattened); // prints {a: {b: {c: [hello, world]}}}
}
```