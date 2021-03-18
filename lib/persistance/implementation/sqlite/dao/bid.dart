import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3/src/api/database.dart';

import '../../../../server/logger.dart';
import '../../../connection/dao/bid.dart';
import '../../../model/auction.dart';
import '../../../model/bid.dart';
import '../../../model/user.dart';
import '_base.dart';

class SqliteBidDao extends SqliteBaseDao<Bid> implements BidDao {

	SqliteBidDao(Database database) :
		_get = database.prepare('SELECT * FROM Bid WHERE ID = ?', persistent: true),
		_getAll = database.prepare('SELECT * FROM Bid', persistent: true),
		_insert = database.prepare('INSERT INTO Bid VALUES (null,?,?,?)', persistent: true),
		_update = database.prepare('UPDATE Bid SET AuctionID = ?, UserID = ?, Amount = ? WHERE ID = ?', persistent: true),
		_delete = database.prepare('DELETE FROM Bid WHERE ID = ?', persistent: true),
		_count = database.prepare('SELECT COUNT(*) FROM Bid', persistent: true),
		_getFromAuction = database.prepare('SELECT * FROM Bid WHERE AuctionID = ?', persistent: true),
		_getFromUser = database.prepare('SELECT * FROM Bid WHERE UserID = ?', persistent: true),
		super(database);
	
	final PreparedStatement _get;
	final PreparedStatement _getAll;
	final PreparedStatement _insert;
	final PreparedStatement _update;
	final PreparedStatement _delete;
	final PreparedStatement _count;
	final PreparedStatement _getFromAuction;
	final PreparedStatement _getFromUser;

	@override
	Bid? get(int id) {
		try {
			ResultSet resultSet = _get.select([id]);
			return resultSet.length > 0 ? Bid.fromServer(resultSet.first) : null;
		} on SqliteException catch (e) {
			Logger.e(e);
			return null;
		}
	}

	@override
	List<Bid> getAll() {
		try {
			ResultSet resultSet = _getAll.select();
			return List<Bid>.generate(
				resultSet.length,
				(index) => Bid.fromServer(resultSet.elementAt(index)),
				growable: false
			);
		} on SqliteException catch (e) {
			Logger.e(e);
			return <Bid>[];
		}
	}

	@override
	bool insert(Bid bid) {
		try {
			_insert.execute(bid.values);
			return database.getUpdatedRows() > 0;
		} on SqliteException catch (e) {
			Logger.e(e);
			return false;
		}
	}

	@override
	bool update(Bid bid) {
		try {
			_update.execute(bid.values..addAll(bid.primaryValues));
			return database.getUpdatedRows() > 0;
		} on SqliteException catch (e) {
			Logger.e(e);
			return false;
		}
	}

	@override
	bool delete(Bid bid) {
		try {
			_delete.execute(bid.primaryValues);
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
	List<Bid> getFromAuction(Auction? auction) {
		if (auction == null) {
			return <Bid>[];
		}
		try {
			ResultSet resultSet = _getFromAuction.select([auction.id]);
			return List<Bid>.generate(
				resultSet.length,
				(index) => Bid.fromServer(resultSet.elementAt(index)),
				growable: false
			);
		} on SqliteException catch (e) {
			Logger.e(e);
			return <Bid>[];
		}
	}

	@override
	List<Bid> getFromUser(User? user) {
		if (user == null) {
			return <Bid>[];
		}
		try {
			ResultSet resultSet = _getFromUser.select([user.id]);
			return List<Bid>.generate(
				resultSet.length,
				(index) => Bid.fromServer(resultSet.elementAt(index)),
				growable: false
			);
		} on SqliteException catch (e) {
			Logger.e(e);
			return <Bid>[];
		}
	}

}