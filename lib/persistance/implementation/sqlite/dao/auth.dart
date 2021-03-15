import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3/src/api/database.dart';

import '../../../../server/logger.dart';
import '../../../connection/dao/auth.dart';
import '../../../model/auth.dart';
import '_base.dart';

class SqliteAuthDao extends SqliteBaseDao<Auth> implements AuthDao {

	SqliteAuthDao(Database database) :
		_get = database.prepare('SELECT * FROM Auth WHERE ID = ?', persistent: true),
		_getAll = database.prepare('SELECT * FROM Auth', persistent: true),
		_insert = database.prepare('INSERT INTO Auth VALUES (null,?,?,?,?,?)', persistent: true),
		_update = database.prepare('UPDATE Auth SET Username = ?, Password = ?, Salt = ?, Admin = ?, UserInitial = ? WHERE ID = ?', persistent: true),
		_delete = database.prepare('DELETE FROM Auth WHERE ID = ?', persistent: true),
		_count = database.prepare('SELECT COUNT(*) FROM Auth', persistent: true),
		_getFromUsername = database.prepare('SELECT * FROM Auth WHERE Username = ?', persistent: true),
		super(database);

	final PreparedStatement _get;
	final PreparedStatement _getAll;
	final PreparedStatement _insert;
	final PreparedStatement _update;
	final PreparedStatement _delete;
	final PreparedStatement _count;
	final PreparedStatement _getFromUsername;

	Auth? get(int id) {
		try {
			ResultSet resultSet = _get.select([id]);
			return resultSet.length > 0 ? Auth.fromServer(resultSet.first) : null;
		} on SqliteException catch (e) {
			Logger.e(e);
			return null;
		}
	}

	@override
	List<Auth> getAll() {
		try {
			ResultSet resultSet = _getAll.select();
			return List<Auth>.generate(
				resultSet.length,
				(index) => Auth.fromServer(resultSet.elementAt(index)),
				growable: false
			);
		} on SqliteException catch (e) {
			Logger.e(e);
			return <Auth>[];
		}
	}

	@override
	bool insert(Auth user) {
		try {
			_insert.execute(user.values);
			return database.getUpdatedRows() > 0;
		} on SqliteException catch (e) {
			Logger.e(e);
			return false;
		}
	}

	@override
	bool update(Auth user) {
		try {
			_update.execute(user.values..addAll(user.primaryValues));
			return database.getUpdatedRows() > 0;
		} on SqliteException catch (e) {
			Logger.e(e);
			return false;
		}
	}

	@override
	bool delete(Auth user) {
		try {
			_delete.execute(user.primaryValues);
			return database.getUpdatedRows() > 0;
		} on SqliteException catch (e) {
			Logger.e(e);
			return false;
		}
	}

	@override
	int count() {
		try {
			ResultSet resultSet = _count.select();
			return resultSet.first['COUNT(*)'];
		} on SqliteException catch (e) {
			Logger.e(e);
			return -1;
		}
	}

	@override
	Auth? getFromUsername(String? username) {
		if (username == null) {
			return null;
		}
		try {
			ResultSet resultSet = _getFromUsername.select([username]);
			return resultSet.length > 0 ? Auth.fromServer(resultSet.first) : null;
		} on SqliteException catch (e) {
			Logger.e(e);
			return null;
		}
	}

	@override
	Auth? login(String? username, String? password) {
		if (username == null || password == null) {
			return null;
		}
		Auth? auth = getFromUsername(username);
		if (auth != null) {
			if (auth.password == password.hashCode ^ auth.salt) {
				return auth;
			}
		}
		return null;
	}

}