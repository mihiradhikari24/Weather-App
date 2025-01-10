import 'package:acm_app_project/consts.dart';
import 'package:acm_app_project/pages/settings.dart';
import 'package:acm_app_project/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:intl/intl.dart';

class homePage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) toggleTheme;

  const homePage({
    Key? key,
    required this.isDarkMode,
    required this.toggleTheme,
  }): super(key: key);


  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final WeatherFactory weather_factory = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? weather;
  String selectedCity = 'Indore';
  List<String> listOfCities = ['Los Angeles', 'Denver', 'Chicago', 'New York', 'Sao Paulo', 'London', 'Paris', 'Berlin', 'Cairo', 'Istanbul', 'Dubai', 'Karachi', 'Mumbai','New Delhi','Indore','Kolkata', 'Kathmandu', 'Dhaka', 'Bangkok', 'Jakarta', 'Beijing', 'Tokyo', 'Seoul', 'Sydney', 'Auckland', 'Honolulu', 'Anchorage', 'Mexico City', 'Lima', 'Buenos Aires', 'Moscow', 'Jerusalem', 'Tehran', 'Baghdad', 'Riyadh', 'Johannesburg', 'Nairobi', 'Singapore', 'Manila', 'Vladivostok', 'Melbourne', 'Suva'];



  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  // Fetch weather for the selected city
  void fetchWeather() {
    weather_factory.currentWeatherByCityName(selectedCity).then((w) {
      setState(() {
        weather = w;
      });
    });
  }

  void cityWeather(String city) {
    weather_factory.currentWeatherByCityName(city).then((w) {
      setState(() {
        weather = w;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Weather App',
            style: TextStyle(
                color: Colors.grey[850],
                fontWeight: FontWeight.w800,
                fontSize: 20
            ),
          ),
          backgroundColor: Colors.amber[700],
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => settingsPage(
                    isDarkMode: widget.isDarkMode,
                    toggleTheme: widget.toggleTheme,
                  )),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => searchPage()),
                );
              },
            ),
          ],
        ),

        body: buildUI()


    );
  }
  Widget buildUI(){
    if(weather == null){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    double h = MediaQuery.sizeOf(context).height;

    return SizedBox(width: MediaQuery.sizeOf(context).width,
      height: h,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          locationHeader(),
          SizedBox(height: h * 0.07),
          cityDropdownMenu(),
          SizedBox(height: h * 0.05),
          dateTimeInfo(),
          SizedBox(height: h * 0.05),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                weatherIcon(),
                currentTemp(),
              ],
            ),
          ),
          SizedBox(height: h * 0.03),
          extraInfo()
        ],
      ),
    );
  }

  Widget locationHeader() {
    return Text(
      weather?.areaName ?? "",
      style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold
      ),
    );
  }

  Widget cityDropdownMenu() {

    return Container(
      decoration: BoxDecoration(
        color: Colors.amber[700],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButton<String>(
        value: selectedCity,
        icon: const Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: Colors.blue[900]
        ),

        onChanged: (String? newCity) {
          setState(() {
            selectedCity = newCity!;
            fetchWeather();
          });
        },
        items: listOfCities.map<DropdownMenuItem<String>>((String city) {
          return DropdownMenuItem<String>(
            value: city,
            child: Text(city),
          );
        }).toList(),
      ),
    );
  }

  Widget dateTimeInfo(){
    DateTime current_info = weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat("h:mm a").format(current_info),
          style: const TextStyle(
              fontSize: 45
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              DateFormat("EEEE").format(current_info),
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600
              ),
            ),
            Text(
              "  ${DateFormat("d/M/y").format(current_info)}",
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400
              ),
            ),
          ],
        )

      ],
    );
  }
  Widget weatherIcon(){
    String iconUrl = "http://openweathermap.org/img/wn/${weather?.weatherIcon}@2x.png";
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.network(
          iconUrl,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
        ),
        Text(
          weather?.weatherDescription ?? "",
          style: const TextStyle(

            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget currentTemp() {
    return Text(
      "${weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
      style: const TextStyle(

        fontSize: 60,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget extraInfo() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.15,
      width: MediaQuery.sizeOf(context).width * 0.80,
      decoration: BoxDecoration(
        color: Colors.amber[700],
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Max: ${weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              Text(
                "Min: ${weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Wind: ${weather?.windSpeed?.toStringAsFixed(0)}m/s",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              Text(
                "Humidity: ${weather?.humidity?.toStringAsFixed(0)}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}