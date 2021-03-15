import 'dart:math';

import '../connection/factory.dart';
import '_entity.dart';
import 'user.dart';

class Auth extends Entity {

	Auth(this.id, this.username, this.password, this.salt, this.admin, this.user);

	factory Auth.fromServer(final Map<String, dynamic> map) => Auth(
		map['ID'], map['Username'], map['Password'], map['Salt'],
		map['Admin'] != 0 ? true : false, DaoFactory.instance.userDao.getFromInitial(map['UserInitial'])
	);

	factory Auth.exp(int id, String username, String password, bool admin, int? userID) {
		Random random = Random.secure();
		int salt = random.nextInt(0x7FFFFFFF);
		int password_hash = password.hashCode ^ salt;
		return Auth(id, username, password_hash, salt, admin, DaoFactory.instance.userDao.getFromInitial(userID));
	}

	factory Auth.fromJson(final Map<String, dynamic> map, final Random random) {
		int salt = random.nextInt(0x7FFFFFFF);
		int password = map['Password'].hashCode ^ salt;
		return Auth(
			map['ID'] ?? -1, map['Username'], password, salt,
			map['Admin'], DaoFactory.instance.userDao.getFromInitial(map['UserInitial'])
		);
	}

	int id, password, salt;
	String username;
	bool admin;
	User? user;

	// insert admin as boolean and not as integer
	@override
	Map<String, dynamic> toJson() => super.toJson()
		..addAll(<String, dynamic>{'Admin': admin})
		..remove('Password')
		..remove('Salt');

	List<String> get primaryKeys => <String>['ID'];
	List<dynamic> get primaryValues => [id];
	
	List<String> get keys => <String>['Username', 'Password', 'Salt', 'Admin', 'UserInitial'];
	List<dynamic> get values => [username, password, salt, admin ? 1 : 0, user?.initial];

	@override bool operator ==(Object o) => o is Auth ? o.id == id : false;
	@override int get hashCode => id.hashCode;
	@override String toString() => toJson().toString();
	
}