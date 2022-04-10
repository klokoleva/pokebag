import 'package:dio/dio.dart';
import 'package:pokebag/model/pokemon_details_model.dart';
import 'package:pokebag/model/pokemon_model.dart';

class PokemonService {
  final Dio api = Dio();
  String? page;

  Future<List<PokemonModel>> getPokeList({bool isNext = false}) async {
    try {
      dynamic url;
      if (isNext) {
        url = page;
      } else {
        url = 'https://pokeapi.co/api/v2/pokemon/?offset=0&limit=25';
      }
      final getPokemon = await api.get(url);
      page = getPokemon.data['next'];
      List result = getPokemon.data['results'];
      List<PokemonModel> lsPokemon =
          result.map((x) => PokemonModel.fromJson(x)).toList();
      return lsPokemon;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<PokemonDetailsModel> getPokeById({int? id}) async {
    try {
      final url = 'https://pokeapi.co/api/v2/pokemon/$id';
      final getPokeById = await api.get(url);
      return PokemonDetailsModel.fromJson(getPokeById.data);
    } catch (e) {
      return throw Exception(e.toString());
    }
  }
}
