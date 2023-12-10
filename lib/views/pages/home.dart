part of 'pages.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  List<Province> provinceData = [];
  bool isLoading = false;
  bool isLoadingCityOrigin = false;
  bool isLoadingCityDestination = false;

  Future<dynamic> getProvinces() async {
    await MasterDataService.getProvince().then((value) {
      setState(() {
        provinceData = value;
      });
    });
  }

  dynamic provinceIdOrigin;
  dynamic selectedprovinceOrigin;

  dynamic provinceIdDestination;
  dynamic selectedprovinceDestination;

  dynamic cityDataOrigin;
  dynamic cityIdOrigin;
  dynamic selectedCityOrigin;

  dynamic cityDataDestination;
  dynamic cityIdDestination;
  dynamic selectedCityDestination;

  Future<List<City>> getCities(var provinsiID, var asalTujuan) async {
    ////
    dynamic city;
    await MasterDataService.getCity(provinsiID).then((value) {
      setState(() {
        city = value;
        if (asalTujuan == 'origin') {
          isLoadingCityOrigin = false;
        } else {
          isLoadingCityDestination = false;
        }
      });
    });

    return city;
  }

  var pilihKurir = 'jne';
  List<Costs> costData = [];

  Future<dynamic> getCost(var kurir, var asal, var tujuan, var berat) async {
    ////
    dynamic costs;
    await MasterDataService.getCost(asal, tujuan, berat, kurir).then((value) {
      setState(() {
        costs = value;
      });
      isLoading = false;
    });

    return costs;
  }

  var weight = 0;

  @override
  void initState() {
    super.initState();
    getProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Calculate Shipping Costs",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color.fromARGB(255, 128, 170, 224),
      body: AbsorbPointer(
        absorbing: isLoading,
        child: Stack(
          children: [
            Column(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Other widgets above "Choose Courier" if any
                          Text(
                            "Choose Courier",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: DropdownButtonFormField(
                                  items: [
                                    DropdownMenuItem(
                                      value: 'jne',
                                      child: Text(
                                        'JNE',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'pos',
                                      child: Text(
                                        'POS',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'tiki',
                                      child: Text(
                                        'TIKI',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      pilihKurir = value
                                          as String; // Update selected value
                                    });
                                  },
                                  value: pilihKurir,
                                  isDense: true, // Reduces the vertical space
                                  isExpanded: false,
                                ),
                              ),
                              SizedBox(width: 30),
                              Flexible(
                                flex: 2,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Weight (gr)',
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      weight = int.tryParse(value) ??
                                          0; // Use 0 as a default value if parsing fails
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),

                          //SECOND ROW for ORIGIN = PROVINCE DAN CITY
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20), // Adjust padding as needed
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Origin",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: provinceData.isEmpty
                                    ? UiLoading.loadingSmall()
                                    : DropdownButtonFormField(
                                        items: provinceData
                                            .map((Province province) {
                                          return DropdownMenuItem(
                                            value: province.provinceId,
                                            child:
                                                Text(province.province ?? ""),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            provinceIdOrigin = value;
                                            isLoadingCityOrigin = true;
                                            selectedCityOrigin = null;
                                            cityDataOrigin = getCities(
                                                provinceIdOrigin, 'origin');
                                          });
                                          cityIdOrigin = null;
                                        },
                                        value: provinceIdOrigin,
                                        isExpanded: true,
                                        decoration: InputDecoration(
                                          labelText: 'Choose Province',
                                        ),
                                      ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                flex: 1,
                                child: FutureBuilder<List<City>>(
                                  future: cityDataOrigin,
                                  builder: (context, snapshot) {
                                    // if (costsList != null && costsList.isNotEmpty)
                                    //   for (Cost cost in c)
                                    if (isLoadingCityOrigin) {
                                      return UiLoading.loadingSmall();
                                    } else if (snapshot.hasData) {
                                      return DropdownButton(
                                        isExpanded: true,
                                        value: selectedCityOrigin,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 4,
                                        style: TextStyle(color: Colors.black),
                                        hint: selectedCityOrigin == null
                                            ? Text('Choose City')
                                            : Text(selectedCityOrigin.cityName),
                                        items: snapshot.data!
                                            .map<DropdownMenuItem<City>>(
                                                (City value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child:
                                                Text(value.cityName.toString()),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedCityOrigin = newValue;
                                            cityIdOrigin =
                                                selectedCityOrigin.cityId;
                                          });
                                        },
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text("No one data");
                                    }
                                    return AbsorbPointer(
                                      absorbing: true,
                                      child: DropdownButton(
                                        isExpanded: true,
                                        value: selectedCityDestination,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 4,
                                        style: TextStyle(color: Colors.black),
                                        hint: Text('Choose City'),
                                        items: [],
                                        onChanged: null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),

                          // THIRD ROW DESTINATION = PROVINCE AND CITY
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20), // Adjust padding as needed
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Destination",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: provinceData.isEmpty
                                    ? UiLoading.loadingSmall()
                                    : DropdownButtonFormField(
                                        items: provinceData
                                            .map((Province province) {
                                          return DropdownMenuItem(
                                            value: province.provinceId,
                                            child:
                                                Text(province.province ?? ""),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            provinceIdDestination = value;
                                            isLoadingCityDestination = true;
                                            selectedCityDestination = null;
                                            cityDataDestination = getCities(
                                                provinceIdDestination,
                                                'destination');
                                            cityIdDestination = null;
                                          });
                                        },
                                        value: provinceIdDestination,
                                        isExpanded: true,
                                        decoration: InputDecoration(
                                          labelText: 'Choose Province',
                                        ),
                                      ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                flex: 1,
                                child: FutureBuilder<List<City>>(
                                  future: cityDataDestination,
                                  builder: (context, snapshot) {
                                    if (isLoadingCityDestination) {
                                      return UiLoading.loadingSmall();
                                    } else if (snapshot.hasData) {
                                      return DropdownButton(
                                        isExpanded: true,
                                        value: selectedCityDestination,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 4,
                                        style: TextStyle(color: Colors.black),
                                        hint: selectedCityDestination == null
                                            ? Text('Choose City')
                                            : Text(selectedCityDestination
                                                .cityName),
                                        items: snapshot.data!
                                            .map<DropdownMenuItem<City>>(
                                                (City value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child:
                                                Text(value.cityName.toString()),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedCityDestination = newValue;
                                            cityIdDestination =
                                                selectedCityDestination.cityId;
                                          });
                                        },
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text("No one data");
                                    }
                                    return AbsorbPointer(
                                      absorbing: true,
                                      child: DropdownButton(
                                        isExpanded: true,
                                        value: selectedCityDestination,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 4,
                                        style: TextStyle(color: Colors.black),
                                        hint: Text('Choose City'),
                                        items: [],
                                        onChanged: null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (cityIdDestination == null ||
                                      cityIdOrigin == null ||
                                      weight < 1) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Please Fill In all informations!'),
                                      ),
                                    );
                                  } else {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    setState(() async {
                                      costData = await getCost(
                                        pilihKurir,
                                        cityIdOrigin,
                                        cityIdDestination,
                                        weight,
                                      );
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue, // Warna latar biru
                                ),
                                child: Text(
                                  'Calculate the costs',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: costData.isEmpty || costData[0].cost.isEmpty
                          ? const Align(
                              alignment: Alignment.center,
                              child: Text("No one Data"),
                            )
                          : ListView.builder(
                              itemCount: costData.length,
                              itemBuilder: (context, index) {
                                return CardProvince(costData[index]);
                              })),
                ),
              ],
            ),
            isLoading == true ? UiLoading.loadingBlock() : Container()
          ],
        ),
      ),
    );
  }
}
