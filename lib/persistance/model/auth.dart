import 'dart:math';

import '../connection/factory.dart';
import '_entity.dart';
import 'user.dart';

// ACCOUNT TYPE
// 0 - ADMIN
// 1 - USER

class Auth extends Entity {

	Auth(this.id, this.username, this.password, this.salt, this.type, this.user);

	factory Auth.fromServer(final Map<String, dynamic> map) {
		int? userID = map['UserID'];
		return Auth(
			map['ID'], map['Username'], map['Password'], map['Salt'],
			map['Type'], userID != null ? DaoFactory.instance.userDao.get(map['UserID'])! : null
		);
	}

	factory Auth.exp(int id, String username, String password, int type, int? userID) {
		Random random = Random.secure();
		int salt = random.nextInt(0x7FFFFFFF);
		int password_hash = password.hashCode ^ salt;
		return Auth(id, username, password_hash, salt, type, userID != null ? DaoFactory.instance.userDao.get(userID) : null);
	}

	factory Auth.fromJson(final Map<String, dynamic> map, final Random random) {
		int salt = random.nextInt(0x7FFFFFFF);
		int password = map['Password'].hashCode ^ salt;
		int? userID = map['UserID'];
		return Auth(
			map['ID'] ?? -1, map['Username'], password, salt,
			map['Admin'] ?? false, userID != null ? DaoFactory.instance.userDao.get(map['UserID'])! : null
		);
	}

	int id, password, salt, type;
	String username;
	User? user;

	// insert admin as boolean and not as integer
	@override
	Map<String, dynamic> toJson() => super.toJson()
		..remove('Password')
		..remove('Salt');

	List<String> get primaryKeys => <String>['ID'];
	List<dynamic> get primaryValues => [id];
	
	List<String> get keys => <String>['Username', 'Password', 'Salt', 'Type', 'UserID'];
	List<dynamic> get values => [username, password, salt, type, user?.id];

	@override bool operator ==(Object o) => o is Auth ? o.id == id : false;
	@override int get hashCode => id.hashCode;
	@override String toString() => toJson().toString();
	
}