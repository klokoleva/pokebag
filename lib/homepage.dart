import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokebag/bloc/pokemon_bloc.dart';
import 'package:pokebag/model/pokemon_model.dart';
import 'package:pokebag/other/appbar.dart';
import 'package:pokebag/pokemon_detail.dart';
import 'package:pokebag/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PokemonBloc bloc = PokemonBloc();

  @override
  void initState() {
    bloc.fetchPokemonList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget data() {
      return StreamBuilder<List<PokemonModel>>(
        stream: bloc.streamPokemon,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Pokedex',
                    style: titleStyle,
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var x = Uri.tryParse(snapshot.data[index].url)?.path;
                    var z = x?.replaceAll(RegExp(r'[^0-9]'), '');
                    String zx;
                    if (z!.length > 2) {
                      zx = z.substring(1, 3);
                    } else {
                      zx = z.substring(1, 2);
                    }
                    return InkWell(
                      onTap: () {
                        Get.to(PokemonDetail(index + 1));
                      },
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(snapshot.data[index].name, style: buttonStyle),
                            Image.network(
                                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$zx.png')
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: appbar('Home', isHome: true),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton(
              onPressed: () async {
                await bloc.fetchPokemonList(isNext: true);
              },
              child: Text('Show More ...')),
        ),
        body: data(),
      ),
    );
  }
}
