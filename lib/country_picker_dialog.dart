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
  final String searchText;
  final List<Country> filteredCountries;
  final PickerDialogStyle? style;
  final String languageCode;

  const CountryPickerDialog({
    Key? key,
    required this.searchText,
    required this.languageCode,
    required this.countryList,
    required this.onCountryChanged,
    required this.selectedCountry,
    required this.filteredCountries,
    this.style,
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
    return Column(
      children: [
        //* create center container with grey background
        Container(
          width: mediaWidth,
          height: 50,
          color: Colors.grey[300],
        ),

        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _filteredCountries.length,
            itemBuilder: (ctx, index) => Column(
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
                  contentPadding: widget.style?.listTilePadding,
                  title: Text(
                    _filteredCountries[index].localizedName(widget.languageCode),
                    style: widget.style?.countryNameStyle ?? const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  trailing: Radio<Country>(
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
        Container(
            width: mediaWidth,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: Colors.grey[300],
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    widget.onCountryChanged(_selectedCountry);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            )
            // color: Colors.grey[300],
            ),
      ],
    );
  }
}
