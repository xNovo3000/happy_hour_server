import 'package:sqlite3/sqlite3.dart';

import '../../../../server/logger.dart';
import '../../../connection/dao/user.dart';
import '../../../model/user.dart';
import '_base.dart';

class SqliteUserDao extends SqliteBaseDao<User> implements UserDao {

	SqliteUserDao(final Database database) :
		_get = database.prepare('SELECT * FROM User WHERE ID = ?', persistent: true),
		_getAll = database.prepare('SELECT * FROM User', persistent: true),
		_insert = database.prepare('INSERT INTO User VALUES (null,?,?,?)', persistent: true),
		_update = database.prepare('UPDATE User SET Initial = ?, Name = ?, Surname = ? WHERE ID = ?', persistent: true),
		_delete = database.prepare('DELETE FROM User WHERE ID = ?', persistent: true),
		_count = database.prepare('SELECT COUNT(*) FROM User', persistent: true),
		_getFromInitial = database.prepare('SELECT * FROM User WHERE Initial = ?', persistent: true),
		super(database);

	final PreparedStatement _get;
	final PreparedStatement _getAll;
	final PreparedStatement _insert;
	final PreparedStatement _update;
	final PreparedStatement _delete;
	final PreparedStatement _count;
	final PreparedStatement _getFromInitial;
	
	User? get(int id) {
		try {
			ResultSet resultSet = _get.select([id]);
			return resultSet.length > 0 ? User.fromServer(resultSet.first) : null;
		} on SqliteException catch (e) {
			Logger.e(e);
			return null;
		}
	}

	@override
	List<User> getAll() {
		try {
			ResultSet resultSet = _getAll.select();
			return List<User>.generate(
				resultSet.length,
				(index) => User.fromServer(resultSet.elementAt(index)),
				growable: false
			);
		} on SqliteException catch (e) {
			Logger.e(e);
			return <User>[];
		}
	}

	@override
	bool insert(User user) {
		try {
			_insert.execute(user.values);
			return database.getUpdatedRows() > 0;
		} on SqliteException catch (e) {
			Logger.e(e);
			return false;
		}
	}

	@override
	bool update(User user) {
		try {
			_update.execute(user.values..addAll(user.primaryValues));
			return database.getUpdatedRows() > 0;
		} on SqliteException catch (e) {
			Logger.e(e);
			return false;
		}
	}

	@override
	bool delete(User user) {
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
	User? getFromInitial(int? initial) {
		if (initial == null) {
			return null;
		}
		try {
			ResultSet resultSet = _getFromInitial.select([initial]);
			return resultSet.length > 0 ? User.fromServer(resultSet.first) : null;
		} on SqliteException catch (e) {
			Logger.e(e);
			return null;
		}
	}

}