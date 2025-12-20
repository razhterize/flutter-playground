import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/saved_cubit.dart';

class SavedDataPreview extends StatelessWidget {
  const SavedDataPreview({super.key});

  final indentJsonEncoder = const JsonEncoder.withIndent("  ");

  @override
  Widget build(BuildContext context) {
    return Card(
      child: BlocBuilder<SavedDataCubit, SavedState>(
        builder: (_, state) {
          return InteractiveJsonPreview(
            data: indentJsonEncoder.convert(state.rawData),
          );
        },
      ),
    );
  }
}

/// https://github.com/yeikel16/interactive_json_preview
///
/// {@template interactive_json_preview}
/// A pretty interactive JSON viewer
/// {@endtemplate}
class InteractiveJsonPreview extends StatefulWidget {
  /// {@macro interactive_json_preview}
  const InteractiveJsonPreview({
    required this.data,
    super.key,
    this.backgroundColor = Colors.transparent,
    this.stringColor = Colors.green,
    this.nullColor = Colors.grey,
    this.intColor = Colors.deepOrangeAccent,
    this.boolColor = Colors.pink,
    this.doubleColor = Colors.deepOrange,
    this.curlyBracketColor,
    this.squareBracketColor,
    this.textStyle = const TextStyle(),
    this.indentLength = 36,
    this.keyColor,
    this.commaColor,
    this.colonColor = Colors.deepPurple,
  });

  /// JSON String
  final dynamic data;

  /// Background color of the Widget
  final Color backgroundColor;

  /// Color of value of type [String]
  final Color stringColor;

  /// Color of value of type null
  final Color nullColor;

  /// Color of value of type [int]
  final Color intColor;

  /// Color of value of type [bool]
  final Color boolColor;

  /// Color of value of type [double]
  final Color doubleColor;

  /// Color of Curly brackets
  final Color? curlyBracketColor;

  /// Color of Square brackets
  final Color? squareBracketColor;

  /// Textstyle of parsed json data
  final TextStyle textStyle;

  /// Indent length in spaces, default to 4
  final int indentLength;

  /// Color of JSON Color Key
  final Color? keyColor;

  /// Color of comma
  final Color? commaColor;

  /// Color of colon
  final Color colonColor;

  @override
  InteractiveJsonPreviewState createState() => InteractiveJsonPreviewState();
}

// ignore: public_member_api_docs
class InteractiveJsonPreviewState extends State<InteractiveJsonPreview> {
  final Map<String, bool> _expandedState = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final childrens = _buildChildren(widget.data);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListView.builder(
        itemCount: childrens.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.only(right: 8),
                child: Text(
                  '${index + 1}: ',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(child: childrens[index]),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildJsonMapView(
    Map<String, dynamic> jsonData,
    String parentKey,
    int depth,
  ) {
    final jsonView = <Widget>[];

    if (depth == 0) {
      jsonView.add(
        SelectableText(
          '{',
          style: bodySmall?.copyWith(color: widget.curlyBracketColor),
        ),
      );
    }

    for (final entrie in jsonData.entries.indexed) {
      final (String key, dynamic value) = (entrie.$2.key, entrie.$2.value);
      final index = entrie.$1;
      final nodeKey = parentKey.isEmpty ? key : '$parentKey.$key.$index';
      final isExpanded = _expandedState[nodeKey] ?? true;

      final isMap = value is Map;
      final isList = value is List;

      final valueLegth = _getLegthofValue(value);

      final leftPadding = depth * widget.indentLength.toDouble();
      jsonView.add(
        Padding(
          padding: EdgeInsets.only(left: max(leftPadding, 6)),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _expandedState[nodeKey] = !isExpanded;
              });
            },
            child: Row(
              children: [
                if (isMap || isList)
                  Icon(
                    isExpanded ? Icons.expand_less_rounded : Icons.expand_more,
                    size: 16,
                    color: Colors.grey,
                  ),
                Expanded(
                  child: SelectableText.rich(
                    TextSpan(
                      text: '"$key": ',
                      style: bodySmall?.copyWith(color: widget.keyColor),
                      children: [
                        if (isExpanded && isMap)
                          TextSpan(
                            text: ' {',
                            style: bodySmall?.copyWith(
                              color: widget.curlyBracketColor,
                            ),
                          ),
                        if (isExpanded && isList)
                          TextSpan(
                            text: ' [',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: widget.squareBracketColor),
                          ),
                        if (!isExpanded && (isMap || isList)) ...[
                          TextSpan(
                            text: isMap ? '{...}' : '[...]',
                            style: bodySmall?.copyWith(
                              color: isMap
                                  ? widget.curlyBracketColor
                                  : widget.squareBracketColor,
                            ),
                          ),
                          TextSpan(
                            text: ' // $valueLegth items',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        ],
                        if (!isList && !isMap)
                          TextSpan(
                            text: _formatValue(value),
                            style: _getValueTextStyle(value),
                            children: [
                              TextSpan(
                                text: ',',
                                style: bodySmall?.copyWith(
                                  color: widget.commaColor,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      if (isExpanded) {
        if (isMap) {
          jsonView
            ..addAll(
              _buildJsonMapView(
                value.map((k, v) => MapEntry(k.toString(), v)),
                nodeKey,
                depth + 1,
              ),
            )
            ..add(
              Padding(
                padding: EdgeInsets.only(
                  left: depth * widget.indentLength.toDouble(),
                ),
                child: SelectableText(
                  ' },',
                  style: bodySmall?.copyWith(color: widget.curlyBracketColor),
                ),
              ),
            );
        } else if (isList) {
          jsonView
            ..addAll(_buildJsonObjectListView(value, nodeKey, depth + 1))
            ..add(
              Padding(
                padding: EdgeInsets.only(
                  left: depth * widget.indentLength.toDouble(),
                ),
                child: SelectableText(
                  ' ],',
                  style: bodySmall?.copyWith(color: widget.curlyBracketColor),
                ),
              ),
            );
        }
      }
    }

    if (depth == 0) {
      jsonView.add(
        SelectableText(
          '}',
          style: bodySmall?.copyWith(color: widget.curlyBracketColor),
        ),
      );
    }

    return jsonView;
  }

  List<Widget> _buildJsonObjectListView(
    List<dynamic> jsonData,
    String parentKey,
    int depth,
  ) {
    final jsonObjectView = <Widget>[];

    if (depth == 0) {
      jsonObjectView.add(
        SelectableText(
          '[',
          style: bodySmall?.copyWith(color: widget.squareBracketColor),
        ),
      );
    }

    for (final (index, value) in jsonData.indexed) {
      final stateKey = '$parentKey.$index';

      final isExpanded = _expandedState[stateKey] ?? true;

      final isMap = value is Map;
      final isList = value is List;

      final valueLegth = _getLegthofValue(value);

      jsonObjectView.add(
        Padding(
          padding: EdgeInsets.only(
            left: depth * widget.indentLength.toDouble(),
          ),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _expandedState[stateKey] = !isExpanded;
              });
            },
            child: Row(
              children: [
                if (isMap || isList)
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 16,
                    color: Colors.grey,
                  ),
                if (!isExpanded && (isMap || isList))
                  Text.rich(
                    TextSpan(
                      text: isMap ? '{...}' : '[...]',
                      style: bodySmall?.copyWith(
                        color: isMap
                            ? widget.curlyBracketColor
                            : widget.squareBracketColor,
                      ),
                      children: [
                        TextSpan(
                          text: ' // $valueLegth items',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (!isList && !isMap)
                  Expanded(
                    child: SelectableText.rich(
                      TextSpan(
                        text: _formatValue(value),
                        style: _getValueTextStyle(value),
                        children: [
                          TextSpan(
                            text: ',',
                            style: bodySmall?.copyWith(
                              color: widget.commaColor,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 1,
                    ),
                  )
                else if (isExpanded)
                  SelectableText(
                    ' {',
                    style: bodySmall?.copyWith(color: widget.curlyBracketColor),
                  ),
              ],
            ),
          ),
        ),
      );

      if (isExpanded) {
        if (isMap) {
          jsonObjectView
            ..addAll(
              _buildJsonMapView(
                value.map((k, v) => MapEntry(k.toString(), v)),
                stateKey,
                depth + 1,
              ),
            )
            ..add(
              Padding(
                padding: EdgeInsets.only(
                  left: depth * widget.indentLength.toDouble(),
                ),
                child: SelectableText(
                  ' },',
                  style: bodySmall?.copyWith(color: widget.curlyBracketColor),
                ),
              ),
            );
        } else if (isList) {
          for (var i = 0; i < value.length; i++) {
            final item = value[i];
            if (item is Map) {
              jsonObjectView.addAll(
                _buildJsonMapView(
                  item.map((k, v) => MapEntry(k.toString(), v)),
                  '$stateKey.$i',
                  depth + 1,
                ),
              );
            } else {
              jsonObjectView.addAll(
                _buildJsonObjectListView(
                  item as List,
                  '$stateKey.$i',
                  depth + 1,
                ),
              );
            }
          }
          jsonObjectView.add(
            Padding(
              padding: EdgeInsets.only(
                left: depth * widget.indentLength.toDouble(),
              ),
              child: SelectableText(
                ' ]',
                style: bodySmall?.copyWith(color: widget.squareBracketColor),
              ),
            ),
          );
        }
      }
    }

    if (depth == 0) {
      jsonObjectView.add(
        SelectableText(
          ']',
          style: bodySmall?.copyWith(color: widget.squareBracketColor),
        ),
      );
    }
    return jsonObjectView;
  }

  int _getLegthofValue(dynamic value) {
    final valueLegth = switch (value) {
      final Map<String, dynamic> map => map.length,
      final List<dynamic> list => list.length,
      _ => 0,
    };
    return valueLegth;
  }

  String _formatValue(dynamic value) {
    if (value is String) {
      return '"$value"';
    }
    if (value == null) {
      return 'null';
    }
    if (value is bool) {
      return value ? 'true' : 'false';
    }
    return value.toString();
  }

  /// Current text theme
  TextTheme get textTheme => Theme.of(context).textTheme;

  /// Current small body text theme
  TextStyle? get bodySmall =>
      textTheme.bodySmall?.copyWith(overflow: TextOverflow.ellipsis);

  TextStyle? _getValueTextStyle(dynamic value) {
    if (value is String) {
      return bodySmall?.copyWith(color: widget.stringColor);
    }
    if (value == null) {
      return bodySmall?.copyWith(color: widget.nullColor);
    }
    if (value is int) {
      return bodySmall?.copyWith(color: widget.intColor);
    }
    if (value is bool) {
      return bodySmall?.copyWith(color: widget.boolColor);
    }
    if (value is double) {
      return bodySmall?.copyWith(color: widget.doubleColor);
    }
    return widget.textStyle;
  }

  List<Widget> _buildChildren(dynamic data) {
    if (data is String) {
      if ((data.startsWith('[') && data.endsWith(']')) ||
          (data.startsWith('{') && data.endsWith('}'))) {
        final json = jsonDecode(data);
        return _buildChildren(json);
      }

      return [
        Text(data, style: bodySmall?.copyWith(color: widget.stringColor)),
      ];
    } else if (data is List) {
      return _buildJsonObjectListView(data, '', 0);
    } else if (data is Map) {
      return _buildJsonMapView(data as Map<String, dynamic>, '', 0);
    }

    return [];
  }
}
