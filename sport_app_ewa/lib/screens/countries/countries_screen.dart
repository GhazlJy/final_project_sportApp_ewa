// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_app_ewa/cubit/get_current_country_cubit.dart';
import 'package:sport_app_ewa/cubit/get_info_cubit.dart';
import 'package:sport_app_ewa/data/models/countries_model.dart';
import 'package:sport_app_ewa/screens/leagues/leagues_screen.dart';
import 'package:sport_app_ewa/screens/widgets/drawer_widget.dart';

class CountriesScreen extends StatefulWidget {
  const CountriesScreen({super.key});

  @override
  State<CountriesScreen> createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  CountriesList? countriesList;
  ScrollController controller = ScrollController();
  double itemHeight = 150.0;

  // void scrollToCountry(String country) {
  //   int index = result!.countries.indexOf(country);
  //   if (index != -1) {
  //     controller.animateTo(
  //       index * itemHeight,
  //       duration: Duration(milliseconds: 500),
  //       curve: Curves.easeInOut,
  //     );
  //   }
  // }

  @override
  void initState() {
    context.read<GetInfoCubit>().getInfoCountry();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries'),
        centerTitle: true,
      ),
      drawer: const DrawerWidget(),
      body: BlocBuilder<GetInfoCubit, GetInfoState>(
        builder: (context, state) {
          
          if (state is GetInfoCountryLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GetInfoCountrySuccess) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                controller: controller,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              const Color.fromARGB(255, 110, 190, 255))),
                      onPressed: () {
                        context
                            .read<GetCurrentCountryCubit>()
                            .getCurrentCountry();
                      },
                      icon: Icon(
                        Icons.location_on,
                        color: const Color.fromARGB(255, 105, 105, 105),
                      ),
                      label: Text(
                        'Get Current Location',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    BlocBuilder<GetCurrentCountryCubit, GetCurrentCountryState>(
                      builder: (context, state) {
                        if (state is GetCurrentCountryLoading) {
                          return Center(
                            child: LinearProgressIndicator(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                          );
                        } else if (state is GetCurrentCountrySuccess) {
                          return RichText(
                            text: TextSpan(
                              text: 'Current Country: ',
                              style: TextStyle(color: Colors.black87),
                              children: <TextSpan>[
                                TextSpan(
                                    text: '${state.currentCountry}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17)),
                              ],
                            ),
                          );
                        } else if (state is GetCurrentCountryError) {
                          return Center(
                            child: Text(
                                'There is an error, your current location cannot be retrieved'),
                          );
                        }
                        return Center(
                          child: Container(),
                        );
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GridView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.countriesList.countries.length,
                      itemBuilder: (context, index) {
                        final country = state.countriesList.countries[index];

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LeaguesScreen(
                                        countryKey: country.countryKey,
                                      )),
                            );
                          },
                          child: Container(
                            decoration: const BoxDecoration(),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Image.network(
                                    country.countryLogo ?? '',
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Icon(Icons.error),
                                  ),
                                ),
                                Text(
                                  country.countryName ?? 'Unknown',
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 7,
                        mainAxisSpacing: 2,
                      ),
                    )
                  ],
                ),
              ),
            );
          } else if (state is GetInfoCountryError) {
            return Center(child: Text('Something went wrong'));
          }
          return Center(child: Text('Initial State'));
        },
      ),
    );
  }
}
