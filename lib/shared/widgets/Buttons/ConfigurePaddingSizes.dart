List<double> configurePaddingSizes(String? initialPaddingConfig) {

  if (initialPaddingConfig == "" || initialPaddingConfig == null) return [8,16,8,16];

  var paddings = initialPaddingConfig.split(" ").map((e) => double.parse(e)).toList();

  if (paddings.length == 1) {
    return List.filled(4, paddings[0]);
  } else if (paddings.length == 2) {
    return [paddings[0], paddings[1], paddings[0], paddings[1]];
  } else if (paddings.length == 4) {
    return [paddings[0], paddings[1], paddings[2], paddings[3]];
  } else {
    throw Error.safeToString('"Incorrect padding configuration"');
  }
}