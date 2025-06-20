import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/common/controllers/create_account_controller.dart';
import 'package:medlink/components/field/search.dart';

class InputCountryCodeScreen extends StatefulWidget {
  const InputCountryCodeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InputCountryCodeScreenState createState() => _InputCountryCodeScreenState();
}

class _InputCountryCodeScreenState extends State<InputCountryCodeScreen> {
  final CreateAccountController createAccountController = Get.put(CreateAccountController());
  TextEditingController searchController = TextEditingController();
  List<Country> countries = Country.values.toList();
  Map<String, List<Country>> groupedCountries = {};

  @override
  void initState() {
    super.initState();
    groupCountriesByAlphabet();
  }

  void groupCountriesByAlphabet() {
    countries.sort((a, b) => a.name.compareTo(b.name));
    groupedCountries = SplayTreeMap();

    for (var country in countries) {
      String firstLetter = country.name[0].toUpperCase();
      if (!groupedCountries.containsKey(firstLetter)) {
        groupedCountries[firstLetter] = [];
      }
      groupedCountries[firstLetter]?.add(country);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 35),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      // Thêm Expanded để TextField chiếm hết chiều rộng còn lại
                      child: SearchTextField(
                        hintText: 'search'.tr,
                        controller: searchController,
                        onSearch: (query) {
                          setState(() {
                            countries = Country.values.where((country) {
                              return country.name.toLowerCase().contains(query.toLowerCase()) ||
                                  country.dialCode.contains(query);
                            }).toList();
                            groupCountriesByAlphabet();
                          });
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        'cancel'.tr,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: AppFontStyleTextStrings.bold,
                          color: AppColors.disable,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: groupedCountries.keys.length,
                  itemBuilder: (context, index) {
                    String key = groupedCountries.keys.elementAt(index);
                    List<Country> countriesInGroup = groupedCountries[key] ?? [];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            key,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: AppFontStyleTextStrings.bold,
                              color: AppColors.primaryText,
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: countriesInGroup.length,
                          itemBuilder: (context, innerIndex) {
                            final country = countriesInGroup[innerIndex];
                            return Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    country.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: AppFontStyleTextStrings.regular,
                                    ),
                                  ),
                                  trailing: Text(
                                    country.dialCode,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: AppFontStyleTextStrings.regular,
                                    ),
                                  ),
                                  onTap: () {
                                    createAccountController.selectedCountry(country);
                                    Get.back();
                                  },
                                ),
                                if (innerIndex != countriesInGroup.length - 1)
                                  const Divider(thickness: 1, color: AppColors.dividers),
                              ],
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
