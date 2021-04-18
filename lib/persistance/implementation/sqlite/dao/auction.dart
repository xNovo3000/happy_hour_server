import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3/src/api/database.dart';

import '../../../../server/logger.dart';
import '../../../connection/dao/auction.dart';
import '../../../model/auction.dart';
import '_base.dart';

class SqliteAuctionDao extends SqliteBaseDao<Auction> implements AuctionDao {

	static final int GET_AFTER_DATE_LIMIT = 50;

	SqliteAuctionDao(Database database) :
		_get = database.prepare('SELECT * FROM Auction WHERE ID = ?', persistent: true),
		_getAll = database.prepare('SELECT * FROM Auction', persistent: true),
		_insert = database.prepare('INSERT INTO Auction VALUES (null,?,?,?)', persistent: true),
		_update = database.prepare('UPDATE Auction SET Name = ?, Expires = ?, ImageName = ? WHERE ID = ?', persistent: true),
		_delete = database.prepare('DELETE FROM Auction WHERE ID = ?', persistent: true),
		_count = database.prepare('SELECT COUNT(*) FROM Auction', persistent: true),
		_getAfterDate = database.prepare('SELECT * FROM Auction WHERE Expires > ? ORDER BY Expires ASC LIMIT $GET_AFTER_DATE_LIMIT', persistent: true),
		_getByName = database.prepare('SELECT * FROM Auction WHERE Name LIKE ? ORDER BY Expires ASC LIMIT $GET_AFTER_DATE_LIMIT', persistent: true),
		super(database);

	final PreparedStatement _get;
	final PreparedStatement _getAll;
	final PreparedStatement _insert;
	final PreparedStatement _update;
	final PreparedStatement _delete;
	final PreparedStatement _count;
	final PreparedStatement _getAfterDate;
	final PreparedStatement _getByName;

	@override
	Auction? get(int id) {
		try {
			ResultSet resultSet = _get.select([id]);
			return resultSet.length > 0 ? Auction.fromServer(resultSet.first) : null;
		} on SqliteException catch (e) {
			Logger.e(e);
			return null;
		}
	}

	@override
	List<Auction> getAll() {
		try {
			ResultSet resultSet = _getAll.select();
			return List<Auction>.generate(
				resultSet.length,
				(index) => Auction.fromServer(resultSet.elementAt(index)),
				growable: false
			);
		} on SqliteException catch (e) {
			Logger.e(e);
			return <Auction>[];
		}
	}

	@override
	bool insert(Auction auction) {
		try {
			_insert.execute(auction.values);
			return database.getUpdatedRows() > 0;
		} on SqliteException catch (e) {
			Logger.e(e);
			return false;
		}
	}

	@override
	bool update(Auction auction) {
		try {
			_update.execute(auction.values..addAll(auction.primaryValues));
			return database.getUpdatedRows() > 0;
		} on SqliteException catch (e) {
			Logger.e(e);
			return false;
		}
	}

	@override
	bool delete(Auction auction) {
		try {
			_delete.execute(auction.primaryValues);
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
	List<Auction> getAfterDate(DateTime? date) {
		if (date == null) {
			return <Auction>[];
		}
		try {
			ResultSet resultSet = _getAfterDate.select([date.millisecondsSinceEpoch]);
			return List<Auction>.generate(
				resultSet.length,
				(index) => Auction.fromServer(resultSet.elementAt(index)),
				growable: false
			);
		} on SqliteException catch (e) {
			Logger.e(e);
			return <Auction>[];
		}
	}

	@override
	List<Auction> getByName(String name) {
		if (name == '') {
			return <Auction>[];
		}
		try {
			ResultSet resultSet = _getByName.select([name]);
			return List<Auction>.generate(
				resultSet.length,
				(index) => Auction.fromServer(resultSet.elementAt(index)),
				growable: false
			);
		} on SqliteException catch (e) {
			Logger.e(e);
			return <Auction>[];
		}
	}

}