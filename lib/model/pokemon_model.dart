class PokemonModel {
  String? myPokeName;
  String? name;
  String? url;

  PokemonModel({this.myPokeName, this.name, this.url});

  PokemonModel.fromJson(Map<String, dynamic> json) {
    myPokeName = json['myPokeName'];
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['myPokeName'] = myPokeName;
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}
