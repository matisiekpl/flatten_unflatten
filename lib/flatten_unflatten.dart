library flatten_unflatten;

class Flatten {
  List<dynamic> _generateList(int size) {
    var list = <dynamic>[];
    for (int i = 0; i < size; i++) list.add({});
    return list;
  }

  dynamic unflat(Map<String, dynamic> target) {
    var normalized = {};
    for (var k in target.keys)
      normalized[k.replaceAll(
          '][', '].__dart__unflattener__control__operator[')] = target[k];
    dynamic result = {};
    normalized.keys.forEach((path) {
      path = path.replaceAll('][', '].__dart__unflattener__control__operator[');
      var parts = path.split('.');
      var pointer = result;
      for (var part in parts) {
        if (part.endsWith(']')) {
          bool isLast = part == parts.last;
          var idx = int.parse(
              part.substring(part.indexOf('[') + 1, part.indexOf(']')));
          part = part.substring(0, part.indexOf('['));
          if (pointer[part] == null) pointer[part] = _generateList(idx + 1);
          while (pointer[part].length < idx + 1) {
            pointer[part].add({});
          }
          if (isLast)
            pointer[part][idx] = normalized[path];
          else
            pointer = pointer[part][idx];
        } else {
          if (!(pointer as Map).containsKey(part)) pointer[part] = {};
          if (parts.last == part)
            pointer[part] = normalized[path];
          else
            pointer = pointer[part];
        }
      }
    });
    var removeHelperTags = null;
    removeHelperTags = (input) {
      if (input is Map) {
        if (input.containsKey('__dart__unflattener__control__operator')) {
          return removeHelperTags(
              input['__dart__unflattener__control__operator']);
        } else {
          var o = {};
          for (var k in input.keys) {
            o[k] = removeHelperTags(input[k]);
          }
          return o;
        }
      }
      if (input is List) {
        var o = [];
        for (int i = 0; i < input.length; i++) {
          o.add(removeHelperTags(input[i]));
        }
        return o;
      }
      return input;
    };
    result = removeHelperTags(result);
    if (normalized.keys.first.toString().startsWith('[')) result = result[''];
    return result;
  }

  Map<dynamic, dynamic> flat(dynamic input) {
    var flatten = null;
    flatten = (obj, res, extraKey) {
      if (obj is List) {
        int i = 0;
        for (var row in obj) {
          if (row is Map || row is List)
            flatten(row, res, '$extraKey[$i].');
          else
            res[extraKey + '[$i]'] = row;
          i++;
        }
      } else
        for (var key in obj.keys) {
          if (obj[key] is List) {
            int i = 0;
            for (var row in obj[key]) {
              if (row is Map || row is List)
                flatten(row, res, '$extraKey$key[$i].');
              else
                res[extraKey + key + '[$i]'] = row;
              i++;
            }
          } else if (obj[key] is Map) {
            flatten(obj[key], res, '$extraKey$key.');
          } else {
            res[extraKey + key] = obj[key];
          }
        }
      return res;
    };
    var out = flatten(input, {}, '');
    var result = {};
    for (var k in out.keys)
      result[k.toString().replaceAll('].[', '][')] = out[k];
    return result;
  }
}