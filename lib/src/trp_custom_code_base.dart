import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:google_fonts/google_fonts.dart';
import './form_field_controller.dart';

class CustomDropDown<T> extends StatefulWidget {
  CustomDropDown({
    super.key,
    this.hintText,
    this.searchHintText,
    this.optionLabels,
    this.onChanged,
    this.onMultiSelectChanged,
    this.width,
    this.height,
    this.maxHeight,
    this.fillColor,
    this.searchCursorColor,
    required this.options,
    required this.elevation,
    required this.borderWidth,
    required this.borderRadius,
    this.hidesUnderline = false,
    this.disabled = false,
    this.isOverButton = false,
    this.isSearchable = false,
    this.isMultiSelect = false,
    this.labelText,
    this.labelTextStyle,
    this.multiSelectController,
    this.cont,
  }) : assert(
          isMultiSelect
              ? (onChanged == null &&
                  multiSelectController != null &&
                  onMultiSelectChanged != null)
              : (onChanged != null &&
                  multiSelectController == null &&
                  onMultiSelectChanged == null),
        );

  final FormFieldController<List<T>?>? multiSelectController;
  final String? hintText;
  final String? searchHintText;
  final List<T> options;
  final List<String>? optionLabels;
  final Function(T?)? onChanged;
  final Function(List<T>?)? onMultiSelectChanged;
  final Widget icon = const Icon(
    Icons.keyboard_arrow_down_rounded,
    color: Color(0xFF966B4D),
    size: 24.0,
  );
  final double? width;
  final double? height;
  final double? maxHeight;
  final Color? fillColor;
  final TextStyle searchHintTextStyle = GoogleFonts.getFont(
    'Inter',
    color: const Color(0xFF744422),
    fontWeight: FontWeight.bold,
    fontSize: 13.0,
  );
  final TextStyle? searchTextStyle = GoogleFonts.getFont(
    'Inter',
    color: const Color(0xFF744422),
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
  );
  final Color? searchCursorColor;
  final double elevation;
  final double borderWidth;
  final double borderRadius;
  final Color borderColor = Colors.transparent;
  final bool hidesUnderline;
  final bool disabled;
  final bool isOverButton;
  final Offset menuOffset = const Offset(0, 0);
  final bool isSearchable;
  final bool isMultiSelect;
  final String? labelText;
  final TextStyle? labelTextStyle;
  final FormFieldController<T?>? cont;

  @override
  State<CustomDropDown<T>> createState() => _CustomDropDownState<T>();
}

class _CustomDropDownState<T> extends State<CustomDropDown<T>> {
  bool get isMultiSelect => widget.isMultiSelect;
  FormFieldController<T?> get controller => widget.cont!;

  FormFieldController<List<T>?> get multiSelectController =>
      widget.multiSelectController!;

  // workaround
  late TextStyle _textStyle;
  final EdgeInsetsGeometry margin =
      const EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 5.0, 0.0);

  //
  T? get currentValue {
    final value = isMultiSelect
        ? multiSelectController.value?.firstOrNull
        : controller.value;
    return widget.options.contains(value) ? value : null;
  }

  Set<T> get currentValues {
    if (!isMultiSelect || multiSelectController.value == null) {
      return {};
    }
    return widget.options
        .toSet()
        .intersection(multiSelectController.value!.toSet());
  }

  Map<T, String> get optionLabels => Map.fromEntries(
        widget.options.asMap().entries.map(
              (option) => MapEntry(
                option.value,
                widget.optionLabels == null ||
                        widget.optionLabels!.length < option.key + 1
                    ? option.value.toString()
                    : widget.optionLabels![option.key],
              ),
            ),
      );

  EdgeInsetsGeometry get horizontalMargin => margin.clamp(
        EdgeInsetsDirectional.zero,
        const EdgeInsetsDirectional.symmetric(horizontal: double.infinity),
      );

  late void Function() _listener;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textStyle = widget.labelTextStyle ??
        GoogleFonts.getFont(
        'Inter',
        color: const Color(0xFF744422),
        fontWeight: FontWeight.normal,
        fontSize: 12.0,
      );

    if (isMultiSelect) {
      _listener =
          () => widget.onMultiSelectChanged!(multiSelectController.value);
      multiSelectController.addListener(_listener);
    } else {
      _listener = () => widget.onChanged!(controller.value);
      controller.addListener(_listener);
    }
  }

  @override
  void dispose() {
    if (isMultiSelect) {
      multiSelectController.removeListener(_listener);
    } else {
      controller.removeListener(_listener);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dropdownWidget = _buildDropdownWidget();
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: widget.borderColor,
            width: widget.borderWidth,
          ),
          color: widget.fillColor,
        ),
        child: Padding(
          padding: _useDropdown2() ? EdgeInsets.zero : margin,
          child: widget.hidesUnderline
              ? DropdownButtonHideUnderline(child: dropdownWidget)
              : dropdownWidget,
        ),
      ),
    );
  }

  bool _useDropdown2() =>
      widget.isMultiSelect ||
      widget.isSearchable ||
      !widget.isOverButton ||
      widget.maxHeight != null;

  Widget _buildDropdownWidget() =>
      _useDropdown2() ? _buildDropdown() : _buildLegacyDropdown();

  Widget _buildLegacyDropdown() {
    return DropdownButtonFormField<T>(
      value: currentValue,
      hint: _createHintText(),
      items: _createMenuItems(),
      elevation: widget.elevation.toInt(),
      onChanged: widget.disabled ? null : (value) => controller.value = value,
      icon: widget.icon,
      isExpanded: true,
      dropdownColor: widget.fillColor,
      focusColor: Colors.transparent,
      decoration: InputDecoration(
        labelText: widget.labelText == null || widget.labelText!.isEmpty
            ? null
            : widget.labelText,
        labelStyle: widget.labelTextStyle,
        border: widget.hidesUnderline
            ? InputBorder.none
            : const UnderlineInputBorder(),
      ),
    );
  }

  Text? _createHintText() => widget.hintText != null
      ? Text(widget.hintText!, style: _textStyle)
      : null;

  List<DropdownMenuItem<T>> _createMenuItems() => widget.options
      .map(
        (option) => DropdownMenuItem<T>(
            value: option,
            child: Padding(
              padding: _useDropdown2() ? horizontalMargin : EdgeInsets.zero,
              child: Text(optionLabels[option] ?? '', style: _textStyle),
            )),
      )
      .toList();

  List<DropdownMenuItem<T>> _createMultiselectMenuItems() => widget.options
      .map(
        (item) => DropdownMenuItem<T>(
          value: item,
          // Disable default onTap to avoid closing menu when selecting an item
          enabled: false,
          child: StatefulBuilder(
            builder: (context, menuSetState) {
              final isSelected =
                  multiSelectController.value?.contains(item) ?? false;
              return InkWell(
                  onTap: () {
                    multiSelectController.value ??= [];
                    isSelected
                        ? multiSelectController.value!.remove(item)
                        : multiSelectController.value!.add(item);
                    multiSelectController.update();
                    // This rebuilds the StatefulWidget to update the button's text.
                    setState(() {});
                    // This rebuilds the dropdownMenu Widget to update the check mark.
                    menuSetState(() {});
                  },
                  child: Container(
                    height: double.infinity,
                    padding: horizontalMargin,
                    child: Row(
                      children: [
                        if (isSelected)
                          const Icon(Icons.check_box_outlined)
                        else
                          const Icon(Icons.check_box_outline_blank),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            optionLabels[item]!,
                            style: _textStyle,
                          ),
                        ),
                      ],
                    ),
                  ));
            },
          ),
        ),
      )
      .toList();

  Widget _buildDropdown() {
    final overlayColor = MaterialStateProperty.resolveWith<Color?>((states) =>
        states.contains(MaterialState.focused) ? Colors.transparent : null);
    final iconStyleData = IconStyleData(icon: widget.icon);
    return DropdownButton2<T>(
      value: currentValue,
      hint: _createHintText(),
      items: isMultiSelect ? _createMultiselectMenuItems() : _createMenuItems(),
      iconStyleData: iconStyleData,
      buttonStyleData: ButtonStyleData(
        elevation: widget.elevation.toInt(),
        overlayColor: overlayColor,
        padding: margin,
      ),
      menuItemStyleData: MenuItemStyleData(
        overlayColor: overlayColor,
        padding: EdgeInsets.zero,
      ),
      dropdownStyleData: DropdownStyleData(
        elevation: widget.elevation.toInt(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: widget.fillColor,
        ),
        isOverButton: widget.isOverButton,
        offset: widget.menuOffset,
        maxHeight: widget.maxHeight,
        padding: EdgeInsets.zero,
      ),
      onChanged: widget.disabled
          ? null
          : (isMultiSelect ? (_) {} : (val) => controller.value = val),
      isExpanded: true,
      selectedItemBuilder: (context) => widget.options
          .map((item) => Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  isMultiSelect
                      ? currentValues
                          .where((v) => optionLabels.containsKey(v))
                          .map((v) => optionLabels[v])
                          .join(', ')
                      : optionLabels[item]!,
                  style: _textStyle,
                  maxLines: 1,
                ),
              ))
          .toList(),
      dropdownSearchData: widget.isSearchable
          ? DropdownSearchData<T>(
              searchController: _textEditingController,
              searchInnerWidgetHeight: 50,
              searchInnerWidget: Container(
                height: 50,
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 4,
                  right: 8,
                  left: 8,
                ),
                child: TextFormField(
                  expands: true,
                  maxLines: null,
                  controller: _textEditingController,
                  cursorColor: widget.searchCursorColor,
                  style: widget.searchTextStyle,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: widget.searchHintText,
                    hintStyle: widget.searchHintTextStyle,
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: widget.searchCursorColor!)),
                  ),
                ),
              ),
              searchMatchFn: (item, searchValue) {
                return (optionLabels[item.value] ?? '')
                    .toLowerCase()
                    .contains(searchValue.toLowerCase());
              },
            )
          : null,
      // This is to clear the search value when you close the menu
      onMenuStateChange: widget.isSearchable
          ? (isOpen) {
              if (!isOpen) {
                _textEditingController.clear();
              }
            }
          : null,
    );
  }
}
