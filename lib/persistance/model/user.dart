import '_entity.dart';

class User extends Entity {

	User(this.id, this.name, this.surname);

	factory User.fromServer(final Map<String, dynamic> map) => User(
		map['ID'], map['Name'], map['Surname']
	);

	factory User.fromJson(final Map<String, dynamic> map) => User(
		map['ID'], map['Name'], map['Surname']
	);

	int id;
	String name, surname;

	List<String> get primaryKeys => <String>['ID'];
	List<dynamic> get primaryValues => [id];
	
	List<String> get keys => <String>['Name', 'Surname'];
	List<dynamic> get values => [name, surname];

	@override bool operator ==(Object o) => o is User ? o.id == id : false;
	@override int get hashCode => id.hashCode;
	@override String toString() => toJson().toString();

}