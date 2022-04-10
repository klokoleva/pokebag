import 'package:pokebag/model/pokemon_details_model.dart';
import 'package:pokebag/model/pokemon_model.dart';
import 'package:pokebag/service/pokemon_service.dart';
import 'package:rxdart/rxdart.dart';

class PokemonBloc {
  PokemonService services = PokemonService();

  late List<PokemonModel> pokeList;
  Stream<List<PokemonModel>> get streamPokemon => _pokemonFetcher.stream;
  final _pokemonFetcher = BehaviorSubject<List<PokemonModel>>();

  late PokemonDetailsModel pokeById;
  Stream<PokemonDetailsModel> get streamPokemonDetails =>
      _pokemonDetailsFetcher.stream;
  final _pokemonDetailsFetcher = BehaviorSubject<PokemonDetailsModel>();

  late List<PokemonModel> mypokeList;
  Stream<List<PokemonModel>> get streammyPokemon => _mypokemonFetcher.stream;
  final _mypokemonFetcher = BehaviorSubject<List<PokemonModel>>();

  fetchPokemonList( {bool isNext = false}) async {
    try {
      pokeList = await services.getPokeList( isNext:isNext);
      _pokemonFetcher.sink.add(pokeList);
    } catch (e) {
      _pokemonFetcher.sink.addError(e.toString());
    }
  }

  fetchPokemonById(int id) async {
    try {
      pokeById = await services.getPokeById(id: id);
      _pokemonDetailsFetcher.sink.add(pokeById);
    } catch (e) {
      _pokemonDetailsFetcher.sink.addError(e.toString());
    }
  } 
}
