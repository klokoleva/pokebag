import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pokebag/bloc/pokemon_bloc.dart';
import 'package:pokebag/model/pokemon_details_model.dart';
import 'package:pokebag/model/pokemon_model.dart';
import 'package:pokebag/my_poke.dart';
import 'package:pokebag/other/appbar.dart';
import 'package:pokebag/theme.dart';

class PokemonDetail extends StatefulWidget {
  final int id;
  const PokemonDetail(this.id);

  @override
  State<PokemonDetail> createState() => _PokemonDetailState();
}

class _PokemonDetailState extends State<PokemonDetail> {
  PokemonBloc bloc = PokemonBloc();
  TextEditingController textcontroller = TextEditingController();

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    await bloc.fetchPokemonById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    Widget data() {
      return StreamBuilder<PokemonDetailsModel>(
        stream: bloc.streamPokemonDetails,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: [
                ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: Text(
                              snapshot.data.name,
                              style: titleStyle,
                            ),
                          ),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: List.generate(
                                snapshot.data.types.length,
                                (index) => Chip(
                                    label: Text(
                                        snapshot.data.types[index].type.name))),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        snapshot.data.sprites.frontDefault),
                                    fit: BoxFit.cover)),
                            constraints: BoxConstraints(
                                minHeight:
                                    MediaQuery.of(context).size.height * 0.3),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: Text(
                              'Moves',
                              style: titleStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 8,
                                offset: Offset(0.0, 0.75))
                          ],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16))),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(
                            snapshot.data.moves.length,
                            (index) => Chip(
                                label: Text(
                                    snapshot.data.moves[index].move.name))),
                      ),
                    )
                  ],
                ),
                Positioned(
                    bottom: 20,
                    right: 0,
                    left: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.white60,
                      radius: 50,
                      child: InkWell(
                        onTap: () async {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: EdgeInsets.all(16),
                                  child: SingleChildScrollView(
                                    padding: MediaQuery.of(context).viewInsets,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Gotcha',
                                          style: titleStyle,
                                        ),
                                        Text(
                                          'Now enter your ${snapshot.data.name} nickname',
                                          style: buttonStyle,
                                        ),
                                        TextFormField(
                                          controller: textcontroller,
                                          onSaved: (v) {
                                            textcontroller.text = v!;
                                          },
                                        ),
                                        SizedBox(height: 16),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                minimumSize: Size(
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    45)),
                                            onPressed: () {
                                              final box = GetStorage();
                                              PokemonModel mypoke =
                                                  PokemonModel(
                                                      myPokeName: textcontroller
                                                              .text.isEmpty
                                                          ? 'default'
                                                          : textcontroller.text,
                                                      name: snapshot.data.name,
                                                      url: snapshot.data.sprites
                                                          .frontDefault);
                                              box.write('mypoke', mypoke);
                                              Get.to(MyPoke());
                                            },
                                            child: Text(
                                              'Submit',
                                              style: buttonStyle,
                                            ))
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Image.asset(
                          'assets/ball.gif',
                        ),
                      ),
                    ))
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
        appBar: appbar('Details'),
        body: data(),
      ),
    );
  }
}
