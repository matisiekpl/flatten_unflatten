library flatten_unflatten;

class Flatten {
  List<dynamic> _generateList(int size) {
    var list = <dynamic>[];
    for (int i = 0; i < size; i++) list.add({});
    return list;
  }

  dynamic unflat(Map<String, dynamic> target) {
    dynamic result = {};
    target.keys.forEach((path) {
      var parts = path.split('.');
      var pointer = result;
      for (var part in parts) {
        if (part.endsWith(']')) {
          bool isLast = part == parts.last;
          var idx = int.parse(
              part.substring(part.indexOf('[') + 1, part.indexOf(']')));
          part = part.substring(0, part.indexOf('['));
          pointer[part] = _generateList(idx + 1);
          if (isLast)
            pointer[part][idx] = target[path];
          else
            pointer = pointer[part][idx];
        } else {
          if (!(pointer as Map).containsKey(part)) pointer[part] = {};
          if (parts.last == part)
            pointer[part] = target[path];
          else
            pointer = pointer[part];
        }
      }
    });
    if (target.keys.first.toString().startsWith('[')) result = result[''];
    return result;
  }
}
