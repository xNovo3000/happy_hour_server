import '_entity.dart';

class User extends Entity {

	User(this.id, this.initial, this.name, this.surname);

	factory User.fromServer(final Map<String, dynamic> map) => User(
		map['ID'], map['Initial'], map['Name'], map['Surname']
	);

	factory User.fromJson(final Map<String, dynamic> map) => User(
		map['ID'] ?? -1, map['Initial'], map['Name'], map['Surname']
	);

	int id, initial;
	String name, surname;

	List<String> get primaryKeys => <String>['ID'];
	List<dynamic> get primaryValues => [id];
	
	List<String> get keys => <String>['Initial', 'Name', 'Surname'];
	List<dynamic> get values => [initial, name, surname];

	@override bool operator ==(Object o) => o is User ? o.id == id : false;
	@override int get hashCode => id.hashCode;
	@override String toString() => toJson().toString();

}