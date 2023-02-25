import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nepal_administrative_division/region_service.dart';

import 'modal.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Province? selectedProvince;
  final TextEditingController provinceController = TextEditingController();
  District? selectedDistrict;
  LocalLevel? selectedLocalLevel;
  AddressModal? address;
  @override
  void initState() {
    super.initState();
    getAddress();
  }

  getAddress() async {
    var res = await getAddressFromJson();
    setState(() {
      address = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select Province'),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    content: Container(
                                      color: Colors.white,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        //         // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Select Province",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Expanded(
                                            child: GridView.count(
                                              shrinkWrap: true,
                                              crossAxisCount: 2,
                                              childAspectRatio: 0.8,
                                              mainAxisSpacing: 12,
                                              crossAxisSpacing: 20,
                                              children: [
                                                for (Province province
                                                    in address!.province)
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      setState(() {
                                                        selectedProvince =
                                                            province;
                                                        provinceController
                                                                .text =
                                                            province.textNP;
                                                        selectedDistrict = null;
                                                        selectedLocalLevel =
                                                            null;
                                                      });
                                                    },
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            constraints:
                                                                const BoxConstraints(
                                                                    maxHeight:
                                                                        50),
                                                            child: Image.asset(
                                                              'assets/provinces/${province.id}.png',
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: Text(
                                                            province.textNP,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                              });
                        },
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'required_field';
                            }
                            return null;
                          },
                          controller: provinceController,
                          enabled: false,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                (RegExp(r'[0-9]'))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (selectedProvince != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('district'),
                      DropdownButtonFormField<District>(
                        value: selectedDistrict,
                        isExpanded: true,
                        onChanged: (District? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            selectedDistrict = value!;
                            selectedLocalLevel = null;
                          });
                        },
                        items: address!.district
                            .where(
                                (item) => item.stateid == selectedProvince?.id)
                            .map<DropdownMenuItem<District>>((District value) {
                          return DropdownMenuItem<District>(
                            value: value,
                            child: Text(value.textNP),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                if (selectedDistrict != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('local_level'),
                      DropdownButtonFormField<LocalLevel>(
                        value: selectedLocalLevel,
                        isExpanded: true,
                        onChanged: (LocalLevel? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            selectedLocalLevel = value!;
                          });
                        },
                        items: address!.localLevel
                            .where((item) =>
                                item.districtid == selectedDistrict?.id)
                            .map<DropdownMenuItem<LocalLevel>>(
                                (LocalLevel value) {
                          return DropdownMenuItem<LocalLevel>(
                            value: value,
                            child: Text(value.textNP),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
