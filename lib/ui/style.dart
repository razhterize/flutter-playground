import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const allMargin = Variant("all_margin");
const verticalMargin = Variant("v_margin");
const horizontalMargin = Variant("h_margin");

Style get cardStyle => Style(
  $box.color(Colors.white24),
  $box.borderRadius.all.circular(10),
  $box.padding.all(10),
  $text.color(Colors.white),
  verticalMargin(
    $box.margin.vertical(10),
  ),
  horizontalMargin(
    $box.margin.vertical(10),
  ),
  allMargin(
    $box.margin.all(10),
  )
);

const flexNoGap = Variant("no_gap");
const flexH = Variant("flex_h");
const flexV = Variant("flex_v");

Style get flexStyle => Style(
  $flex.crossAxisAlignment.center(),
  $flex.mainAxisAlignment.start(),
  $flex.gap(10),
  flexV(
    $flex.direction.vertical()
  ),
  flexH($flex.direction.horizontal()),
  flexNoGap(
    $flex.gap(0)
  )
);

Style get vboxStyle => flexStyle.applyVariant(flexV);
Style get hboxStyle => flexStyle.applyVariant(flexH);