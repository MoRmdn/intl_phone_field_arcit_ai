import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';

class PickerDialogStyle {
  final Color? backgroundColor;

  final TextStyle? countryCodeStyle;

  final TextStyle? countryNameStyle;

  final Widget? listTileDivider;

  final EdgeInsets? listTilePadding;

  final EdgeInsets? padding;

  final Color? searchFieldCursorColor;

  final InputDecoration? searchFieldInputDecoration;

  final EdgeInsets? searchFieldPadding;

  final double? width;

  PickerDialogStyle({
    this.backgroundColor,
    this.countryCodeStyle,
    this.countryNameStyle,
    this.listTileDivider,
    this.listTilePadding,
    this.padding,
    this.searchFieldCursorColor,
    this.searchFieldInputDecoration,
    this.searchFieldPadding,
    this.width,
  });
}

class CountryPickerDialog extends StatefulWidget {
  final List<Country> countryList;
  final Country selectedCountry;
  final ValueChanged<Country> onCountryChanged;
  // final String searchText;
  final List<Country> filteredCountries;
  // final PickerDialogStyle? style;
  final String languageCode;
  final bool selectPhone;
  final Widget header;
  final Widget subTitle;
  final Widget cancelButton;
  final Widget doneButton;
  final double? bottomHight;
  final EdgeInsetsGeometry? padding;
  final double? headerHeight;
  final TextStyle? countryNameStyle;
  final Color? radioActiveColor;
  final Color? radioFocusColor;
  final Color? radioHoverColor;
  final MaterialStateProperty<Color?>? radioOverlayColor;
  final MaterialStateProperty<Color?>? radioFillColor;

  const CountryPickerDialog({
    Key? key,
    // required this.searchText,
    required this.languageCode,
    required this.countryList,
    required this.onCountryChanged,
    required this.selectedCountry,
    required this.filteredCountries,
    required this.selectPhone,
    required this.countryNameStyle,
    this.radioActiveColor,
    this.radioFillColor,
    this.radioFocusColor,
    this.radioHoverColor,
    this.radioOverlayColor,
    required this.header,
    this.headerHeight,
    required this.subTitle,
    required this.cancelButton,
    required this.doneButton,
    this.bottomHight,
    this.padding,

    // this.style,
  }) : super(key: key);

  @override
  State<CountryPickerDialog> createState() => _CountryPickerDialogState();
}

class _CountryPickerDialogState extends State<CountryPickerDialog> {
  late List<Country> _filteredCountries;
  late Country _selectedCountry;

  @override
  void initState() {
    _selectedCountry = widget.selectedCountry;
    _filteredCountries = widget.filteredCountries.toList()
      ..sort(
        (a, b) => a.localizedName(widget.languageCode).compareTo(b.localizedName(widget.languageCode)),
      );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    // final width = widget.style?.width ?? mediaWidth;
    // const defaultHorizontalPadding = 40.0;
    // const defaultVerticalPadding = 24.0;
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xfffefeff),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //* create center container with grey background
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            height: widget.headerHeight ?? 60,
            child: widget.header,
          ),
          const Divider(
            thickness: 1,
            color: Color(0xffe9e8e8),
          ),

          widget.subTitle,

          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredCountries.length,
              itemBuilder: (ctx, index) => Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 10,
                ),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: kIsWeb
                          ? Image.asset(
                              'assets/flags/${_filteredCountries[index].code.toLowerCase()}.png',
                              package: 'intl_phone_field',
                              width: 32,
                            )
                          : Text(
                              _filteredCountries[index].flag,
                              style: const TextStyle(fontSize: 18),
                            ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                      title: Text(
                        _filteredCountries[index].localizedName(widget.languageCode),
                        style: widget.countryNameStyle,
                      ),
                      trailing: Radio<Country>.adaptive(
                        activeColor: widget.radioActiveColor,
                        focusColor: widget.radioFocusColor,
                        hoverColor: widget.radioHoverColor,
                        overlayColor: widget.radioOverlayColor,
                        fillColor: widget.radioFillColor,
                        value: _filteredCountries[index],
                        groupValue: _selectedCountry,
                        onChanged: (value) {
                          _selectedCountry = value!;
                          setState(() {});
                        },
                      ),
                      onTap: () => setState(() {
                        _selectedCountry = _filteredCountries[index];
                      }),
                    ),

                    // widget.style?.listTileDivider ?? const Divider(thickness: 1),
                  ],
                ),
              ),
            ),
          ),
          Container(
              width: mediaWidth,
              height: widget.bottomHight ?? 90,
              padding: widget.padding,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                border: Border.all(
                  color: const Color(0xffe9e8e8),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: widget.cancelButton,
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        widget.onCountryChanged(_selectedCountry);
                        Navigator.pop(context);
                      },
                      child: widget.doneButton,
                    ),
                  ),
                ],
              )
              // color: Colors.grey[300],
              ),
        ],
      ),
    );
  }
}
