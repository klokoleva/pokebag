import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pokebag/model/pokemon_model.dart';
import 'package:pokebag/other/appbar.dart';
import 'package:pokebag/theme.dart';

class MyPoke extends StatefulWidget {
  const MyPoke({Key? key}) : super(key: key);

  @override
  State<MyPoke> createState() => _MyPokeState();
}

class _MyPokeState extends State<MyPoke> {
  late PokemonModel myPoke = PokemonModel();
  final box = GetStorage();

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    myPoke = box.read('mypoke');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: appbar('My Pokemon', mypoke: true),
      body: myPoke == null || myPoke.name == null
          ? Center(
              child: Text('No data'),
            )
          : GridView.builder(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16),
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        children: [
                          Text(myPoke.myPokeName!, style: titleStyle),
                          Text(myPoke.name!, style: buttonStyle),
                          Image.network(myPoke.url!),
                        ],
                      ),
                      Positioned(
                          bottom: 0,
                          left: 0,
                          child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              )))
                    ],
                  ),
                );
              },
            ),
    ));
  }
}
